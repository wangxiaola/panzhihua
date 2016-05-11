//
//  ZKCustomizationCommitOrderViewController.m
//  CYmiangzhu
//
//  Created by 汤亮 on 15/10/9.
//  Copyright © 2015年 WangXiaoLa. All rights reserved.
//

#import "ZKCustomizationCommitOrderViewController.h"
#import "ZKCustomizationSureOrderViewController.h"
#import "ZKTextField.h"
#import "ZKOrder.h"
#import "ZKProduction.h"
#import "ZKregisterViewController.h"

@interface ZKCustomizationCommitOrderViewController()

@property (weak, nonatomic) IBOutlet ZKTextField *nameTextField;
@property (weak, nonatomic) IBOutlet ZKTextField *phoneTextField;

@property (weak, nonatomic) IBOutlet UILabel *totalPriceLabel;

@property (nonatomic,strong) NSString * url;
@property (nonatomic,strong) NSString *ored;
@property (nonatomic,strong) NSString *staDate;
@property (nonatomic,strong) NSString *endDate;
@end

@implementation ZKCustomizationCommitOrderViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.titeLabel.text = @"提交订单";
    NSArray *times = [self.production.pzh_qixian componentsSeparatedByString:@","];
    if (times.count ==2) {
        _staDate = times[0];
        _endDate = times[1];
    }
    
   
    
}



- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    
    ZKCustomizationSureOrderViewController *sureVC = segue.destinationViewController;
    ZKOrder *order = [[ZKOrder alloc] init];
    
    order.payurl = _url;
    order.ordercode = _ored;
    
    order.name = self.production.pzh_name;
    order.price = self.production.pzh_price;
    order.totalPrice = self.totalPriceLabel.text;
    order.productID = self.production.pzh_productID;
    order.qixian = self.production.pzh_qixian;
    order.userName = self.nameTextField.text;
    order.userPhone = self.phoneTextField.text;
    
    sureVC.order = order;
    
    
}

- (IBAction)commitOrder {
    
    
    
    if (self.nameTextField.text.length == 0) {
        
        [SVProgressHUD showErrorWithStatus:@"请填写姓名"];
        return;
    }
    
    
    
    if (self.phoneTextField.text.length == 0) {
        
        [SVProgressHUD showErrorWithStatus:@"请填写电话号码"];
        return;
    }
    
    
    if (![ZKUtil isMobileNumber:self.phoneTextField.text]) {
        
        [SVProgressHUD showErrorWithStatus:@"请填写正确的电话号码"];
        return;
    }
    
    NSString *      regex = @"(^[a-zA-Z0-9_\u4e00-\u9fa5]+$)";
    NSPredicate *   pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    if (![pred evaluateWithObject:_nameTextField.text]) {
        
        [SVProgressHUD showErrorWithStatus:@"请填写正确姓名"];
        return;
    }
    
    if ([ZKUserInfo sharedZKUserInfo].ID) {
        
        NSMutableDictionary *dic =[NSMutableDictionary dictionary];
        
        [dic setObject:[ZKUtil timeStamp] forKey:@"TimeStamp"];
        [dic setObject:@"10" forKey:@"interfaceId"];
        [dic setObject:@"createOrder" forKey:@"method"];
        [dic setObject:self.production.pzh_productID forKey:@"pid"];
        [dic setObject:@"1" forKey:@"buynum"];
        [dic setObject:self.production.pzh_price forKey:@"price"];
        [dic setObject:self.nameTextField.text forKey:@"name"];
        [dic setObject:self.phoneTextField.text forKey:@"phone"];
        [dic setObject:[ZKUserInfo sharedZKUserInfo].ID forKey:@"memberid"];
        [dic setObject:_staDate  forKey:@"starttime"];
        [dic setObject:_endDate forKey:@"endtime"];
        
        [ZKHttp post:universalServerUrl params:dic success:^(id responseObj) {
            
            NSDictionary *data = [responseObj valueForKey:@"root"];
            NSDictionary *ko = [data valueForKey:@"result"];
            
            NSLog(@" ===   --%@",ko);
            if (!ko) {
                
                [self.view makeToast:@"网络错误，请稍候再试！"];
            }else{
                
                _url = [ko valueForKey:@"payurl"];
                _ored = [ko valueForKey:@"ordercode"];
                
                [self performSegueWithIdentifier:@"CustomizationCommit2Sure" sender:nil];
                
                
            }
        } failure:^(NSError *error) {
            [self.view makeToast:@"网络错误，请稍候再试！"];
            NSLog(@" =err== %@",error);
        }];
        
        
    }else{
        
        ZKregisterViewController *vc =[[ZKregisterViewController alloc]init];
        vc.isMy =YES;
        [vc  dengluCG:^{
            
            [self commitOrder];
            
        }];
        
        UINavigationController *nav =[[UINavigationController alloc]initWithRootViewController:vc];
        nav.navigationBarHidden =YES;
        [self.navigationController presentViewController:nav animated:YES completion:^{
            
        }];
        
    }
    
    
    
}

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


@end
