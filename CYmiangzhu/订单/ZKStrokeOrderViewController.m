//
//  ZKStrokeOrderViewController.m
//  CYmiangzhu
//
//  Created by 王小腊 on 16/1/26.
//  Copyright © 2016年 WangXiaoLa. All rights reserved.
//

#import "ZKStrokeOrderViewController.h"
#import "ZKTextField.h"
//支付宝
#import "Order.h"
#import "DataSigner.h"
#import <AlipaySDK/AlipaySDK.h>
#import "APAuthV2Info.h"


@interface ZKStrokeOrderViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *jgLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet ZKTextField *oredNameLabel;
@property (weak, nonatomic) IBOutlet ZKTextField *oredPhoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *zjLabel;
@property (strong, nonatomic) NSMutableDictionary *list;

@end

@implementation ZKStrokeOrderViewController
@synthesize list = list;

-(id)initData:(NSArray*)data;
{
    self =[super init];
    
    if (self) {
        
        list =[NSMutableDictionary dictionary];
        
        for (int i = 0; i<data.count; ++i) {
            NSArray *cmp = [data[i] componentsSeparatedByString:@"="];
            
            [list setObject:cmp[1] forKey:cmp[0]];
        }
        
    }
    return self;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titeLabel.text =@"提交订单";
    // Do any additional setup after loading the view from its nib.
    self.oredNameLabel.delegate =self;
    self.oredPhoneLabel.delegate =self;
    [self updata];
}
/**
 *  数据填充
 *
 *  @param str 数据
 */
-(void)updata;
{
    self.jgLabel.textColor =CYBColorGreen;
    NSString *str = [list valueForKey:@"pzh_whichroom"];
    self.nameLabel.text =str;
    self.jgLabel.text =[NSString stringWithFormat:@"%@元",[list valueForKey:@"pzh_price"]];
    self.zjLabel.text =[NSString stringWithFormat:@"%@元",[list valueForKey:@"pzh_price"]];
    
    
}
- (IBAction)tjClick:(UIButton *)sender {
    

      [self dismissTield];
    
    if (self.oredNameLabel.text.length == 0) {
        
        [SVProgressHUD showErrorWithStatus:@"请填写姓名"];
        return;
    }
    
    
    if (self.oredPhoneLabel.text.length == 0) {
        
        [SVProgressHUD showErrorWithStatus:@"请填写电话号码"];
        return;
    }
    
    if (![ZKUtil isValidateTelNumber:self.oredPhoneLabel.text]) {
        
        [SVProgressHUD showErrorWithStatus:@"请填写正确的电话号码"];
        return;
    }
    
    [SVProgressHUD showSuccessWithStatus:@"正在提交订单"];
    NSMutableDictionary *dic =[NSMutableDictionary dictionary];
    
    [dic setObject:[ZKUtil timeStamp] forKey:@"TimeStamp"];
    [dic setObject:@"58" forKey:@"interfaceId"];
    [dic setObject:self.oredPhoneLabel.text forKey:@"phone"];
    [dic setObject:[list valueForKey:@"pzh_productID"] forKey:@"planid"];
    [dic setObject:self.oredNameLabel.text forKey:@"name"];
    
    [ZKHttp post:universalServerUrl params:dic success:^(id responseObj) {
        
        NSLog(@"-- %@",responseObj);
        if ([[responseObj valueForKey:@"errmsg"] isEqualToString:@"SUCCESS"]) {
            
            [SVProgressHUD dismissWithSuccess:@"订单提交成功"];
            
            NSString *orderCode =[[responseObj valueForKey:@"root"] valueForKey:@"orderCode"];
            [list setObject:orderCode forKey:@"orderCode"];
            
            [self Success:list];

            
        }else{
            
            [SVProgressHUD dismissWithError:@"订单提交出错了！"];
        }
        
    } failure:^(NSError *error) {
        [SVProgressHUD dismissWithError:@"网络错误！"];
        
    }];
}

-(void)Success:(NSDictionary*)dic;
{
    /*
     *生成订单信息及签名
     */
    //将商品信息赋予AlixPayOrder的成员变量
    Order *order = [[Order alloc] init];
    order.partner = PARTNER;
    order.seller = SELLER;
    order.tradeNO = [dic valueForKey:@"orderCode"]; //订单ID（由商家自行制定）
    order.productName = [dic valueForKey:@"pzh_whichroom"]; //商品标题
    order.productDescription = [NSString stringWithFormat:@"%@-总价%@",[dic valueForKey:@"pzh_whichroom"],[dic valueForKey:@"pzh_price"]]; //商品描述
    order.amount = [dic valueForKey:@"pzh_price"]; //商品价格
    order.notifyURL =  @"http://pzh.geeker.com.cn/planFrontNotify.jkb"; //回调URL
    
    order.service = @"mobile.securitypay.pay";
    order.paymentType = @"1";
    order.inputCharset = @"utf-8";
    order.itBPay = @"30m";
    order.showUrl = @"m.alipay.com";
    
    //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
    NSString *appScheme = @"CYmiangzhu";
    
    //将商品信息拼接成字符串
    NSString *orderSpec = [order description];
    NSLog(@"orderSpec = %@",orderSpec);
    
    //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
    id<DataSigner> signer = CreateRSADataSigner(PRIVATEKEY);
    NSString *signedString = [signer signString:orderSpec];
    
    //将签名成功字符串格式化为订单字符串,请严格按照该格式
    NSString *orderString = nil;
    if (signedString != nil) {
        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                       orderSpec, signedString, @"RSA"];
        
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            
            NSString *result =[resultDic valueForKey:@"result"];
            NSLog(@" 支付宝  ＝＝  %@\n",resultDic);
            
            if (strIsEmpty(result) ==0) {
                
                [SVProgressHUD showSuccessWithStatus:@"支付成功" duration:1.5];
                
                
            }else{
                
                [SVProgressHUD showErrorWithStatus:@"支付失败" duration:1.5];

                
            }
            
            [self pushView];
            
        }];
    }

}

- (void)pushView
{
    
    NSMutableArray * array =[[NSMutableArray alloc]initWithArray:self.navigationController.viewControllers];
    
    if (array.count>2) {
       //删除到只剩最后一个控制器
        NSInteger p =array.count-2;
        
        for (int i = 0; i< p ; i++) {
            [array removeObjectAtIndex:array.count-1];
        }
    }

    [self.navigationController setViewControllers:array animated:YES];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{

    [self dismissTield];

}

-(void)dismissTield
{

    [self.oredNameLabel resignFirstResponder];
    [self.oredPhoneLabel resignFirstResponder];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;
{
    
    if (textField.tag == 2000) {
        
        
        return range.location>=6 ? NO:YES;
        
        
    }else if (textField.tag == 2001){
        
        return range.location>=11 ? NO:YES;
        
    }else{
        
        return YES;
    }
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (self.oredNameLabel == textField) {
        [textField resignFirstResponder];
        [self.oredNameLabel becomeFirstResponder];
    }else if (self.oredPhoneLabel == textField) {
        [textField resignFirstResponder];
        
    }else{
        [textField resignFirstResponder];
    }
    
    return  YES;
}


/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
