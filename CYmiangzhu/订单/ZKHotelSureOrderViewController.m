//
//  ZKHotelSureOrderViewController.m
//  CYmiangzhu
//
//  Created by 汤亮 on 15/9/30.
//  Copyright © 2015年 WangXiaoLa. All rights reserved.
//

#import "ZKHotelSureOrderViewController.h"
#import "ZKOrder.h"
#import "ZKmyOrderViewController.h"
#import "Order.h"
#import "DataSigner.h"
#import <AlipaySDK/AlipaySDK.h>

#import "APAuthV2Info.h"

@interface ZKHotelSureOrderViewController()
@property (weak, nonatomic) IBOutlet UILabel *productionNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *enterLeaveLabel;
@property (weak, nonatomic) IBOutlet UILabel *dayCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UIButton *alipayButton;

@property (weak, nonatomic) IBOutlet UIButton *sureButton;
@property (weak, nonatomic) IBOutlet UILabel *totalPriceLabel;

- (IBAction)alipayClick;



@end

@implementation ZKHotelSureOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.titeLabel.text = @"订单支付";
    
    [self setupButtons];
    [self setupData];
}

#pragma mark - 设置数据
- (void)setupData
{
    
    self.productionNameLabel.text = self.order.name;
    self.enterLeaveLabel.text = self.order.enterLeave;
    self.dayCountLabel.text = self.order.dayCount;
    
    self.nameLabel.text = self.order.userName;
    self.phoneLabel.text = self.order.userPhone;
    
    NSString *totalPrice = [NSString stringWithFormat:@"%@元", self.order.totalPrice];
    self.totalPriceLabel.text = [totalPrice stringByReplacingOccurrencesOfString:@".00" withString:@""];
}

#pragma mark - 配置按钮样式
- (void)setupButtons
{
    self.alipayButton.adjustsImageWhenHighlighted = NO;
    self.alipayButton.selected = YES;
    self.sureButton.layer.cornerRadius = 5;
    self.sureButton.layer.masksToBounds = YES;
    
}



/**
 *  确认订单
 *
 *  @param sender 
 */
- (IBAction)senderBUtton:(UIButton *)sender {
    
    
    
    if (![ZKUserInfo sharedZKUserInfo].ID) {
        [self.view makeToast:@"请先登录！"];
    }else{
        
        
        /*
         *生成订单信息及签名
         */
        //将商品信息赋予AlixPayOrder的成员变量
        Order *order = [[Order alloc] init];
        order.partner = PARTNER;
        order.seller = SELLER;
        order.tradeNO = self.order.ordercode; //订单ID（由商家自行制定）
        order.productName = self.order.name; //商品标题
        order.productDescription = [NSString stringWithFormat:@"%@-总价%@",self.order.name ,self.order.totalPrice]; //商品描述
        order.amount = self.order.totalPrice; //商品价格
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
                    
                    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                    [dic setObject:[ZKUtil timeStamp] forKey:@"TimeStamp"];
                    [dic setObject:@"60" forKey:@"interfaceId"];
                    [dic setObject:self.order.ordercode forKey:@"out_trade_no"];
                    [dic setObject:@"" forKey:@"trade_no"];
                    
                    [ZKHttp post:universalServerUrl params:dic success:^(id responseObj) {
                        
                        NSLog(@"服务器 == %@\n",responseObj);
                        
                       [SVProgressHUD showSuccessWithStatus:@"支付成功" duration:1.5];
                        
              
                        [self pushView:1];
                        
                        
                    } failure:^(NSError *error) {
                        
                        [self.view makeToast:@"网络错误!"];
                    }];
                    
                }else{
                    
                    [SVProgressHUD showErrorWithStatus:@"支付失败" duration:1.5];
                    [self pushView:0];
                }
                
            }];
        }

        
    }
    
}
/**
 *  跳转页面
 *
 *  @param p 
 */

-(void)pushView:(NSInteger)p
{

    NSMutableArray * array =[[NSMutableArray alloc]initWithArray:self.navigationController.viewControllers];
    if (array.count>2) {
        
        [array removeObjectAtIndex:array.count-1];
        [array removeObjectAtIndex:array.count-1];
    }

    ZKmyOrderViewController *order = [[ZKmyOrderViewController alloc] init];
    order.index=p;
     //添加一个视图控制器
    [array addObject:order];
    [self.navigationController setViewControllers:array animated:YES];

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1 && indexPath.row==1) {
        
        [self alipayClick];
        
    }
    
    
}

- (IBAction)alipayClick {
    self.alipayButton.selected = YES;

}
@end
