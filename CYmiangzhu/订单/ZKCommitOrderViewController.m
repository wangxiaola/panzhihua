//
//  ZKCommitOrderViewController.m
//  CYmiangzhu
//
//  Created by 汤亮 on 15/8/25.
//  Copyright (c) 2015年 WangXiaoLa. All rights reserved.
//

#import "ZKCommitOrderViewController.h"
#import "ZKTextField.h"
#import "SVProgressHUD.h"
#import "ZKProduction.h"
#import "ZKOrder.h"
#import "ZKSureOrderViewController.h"
#import "ZKregisterViewController.h"

@interface ZKCommitOrderViewController ()<UITextFieldDelegate, UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UITextField *countTextField;
@property (weak, nonatomic) IBOutlet ZKTextField *nameTextField;
@property (weak, nonatomic) IBOutlet ZKTextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UIButton *reduceButton;
@property (weak, nonatomic) IBOutlet UIButton *addButton;
@property (weak, nonatomic) IBOutlet UILabel *totalPriceLabel;
@property (weak, nonatomic) IBOutlet UIButton *commitButton;
@property (weak, nonatomic) IBOutlet UILabel *productionNameLabel;

@property (nonatomic,strong) NSString * url;
@property (nonatomic,strong) NSString *ored;
@property (strong,nonatomic) NSString *staDate;
@property (strong,nonatomic) NSString *endDate;

- (IBAction)addCount;
- (IBAction)reduceCount;
- (IBAction)commitOrder;

@end

@implementation ZKCommitOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupNavigationBar];
    [self setupTextField];
    
    [self setupData];
  
}

#pragma mark - 初始化数据
- (void)setupData
{
    self.productionNameLabel.text = self.production.pzh_name;
    self.priceLabel.text = [NSString stringWithFormat:@"%@元", self.production.pzh_price];
    
    NSArray *times = [self.production.pzh_qixian componentsSeparatedByString:@","];
    
    if (times.count ==2) {
        _staDate = times[0];
        _endDate = times[1];
    }

    NSString *totalPrice = [NSString stringWithFormat:@"%.2f元", self.countTextField.text.intValue * self.production.pzh_price.doubleValue];
    self.totalPriceLabel.text = [totalPrice stringByReplacingOccurrencesOfString:@".00" withString:@""];
    
 }

#pragma mark - UITextFieldDelegate
- (void)setupTextField
{
    self.nameTextField.backgroundColor =[UIColor clearColor];
    self.nameTextField.delegate =self;
    self.nameTextField.textColor =YJCorl(104, 104, 104);
    //再次编辑就清空
    self.nameTextField.clearsOnBeginEditing =NO;
    self.nameTextField.spacing =5;
    
    self.phoneTextField.backgroundColor =[UIColor clearColor];
    self.phoneTextField.textColor =YJCorl(104, 104, 104);
    //输入框中叉号编辑时出现
    self.phoneTextField.delegate =self;
    self.phoneTextField.spacing =5;
    
    self.countTextField.backgroundColor =[UIColor clearColor];
    self.countTextField.textColor =YJCorl(104, 104, 104);
    //输入框中叉号编辑时出现
    self.countTextField.delegate =self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChange) name:UITextFieldTextDidChangeNotification object:self.countTextField];
    
    [self.countTextField addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionNew context:nil];
    [self observeValueForKeyPath:nil ofObject:nil change:@{@"new":self.countTextField.text} context:nil];
}

#pragma mark - 计算时间相差天数
- (NSInteger)stayNightDaysWithEnter:(NSString *)enter leave:(NSString *)leave
{
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-M-d";
    fmt.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    
    NSDate *enterDate = [fmt dateFromString:enter];
    NSDate *leaveDate = [fmt dateFromString:leave];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierChinese];
    NSDateComponents *cmp = [calendar components:NSCalendarUnitDay fromDate:enterDate toDate:leaveDate options:0];
    
    return cmp.day;
}

#pragma mark - 设置导航栏
- (void)setupNavigationBar
{
    self.titeLabel.text = @"提交订单";
    [self.navigationController setNavigationBarHidden:YES];
    
    self.priceLabel.textColor = YJCorl(51, 202, 171);
    self.totalPriceLabel.textColor = YJCorl(214, 116, 0);
    
    self.commitButton.layer.cornerRadius = 5;
    self.commitButton.layer.masksToBounds = YES;
    
    
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.tableView endEditing:YES];
}



#pragma mark - Segue准备
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    ZKSureOrderViewController *sureVC = segue.destinationViewController;
    ZKOrder *order = [[ZKOrder alloc] init];
    
    order.payurl = _url;
    order.ordercode = _ored;
    
    order.name = self.production.pzh_name;
    order.price = self.production.pzh_price;
    order.totalPrice = [NSString stringWithFormat:@"%.2f", self.countTextField.text.intValue * self.production.pzh_price.floatValue];
    order.productID = self.production.pzh_productID;
    order.qixian = [NSString stringWithFormat:@"%@,%@",_staDate,_endDate];
    order.userName = self.nameTextField.text;
    order.userPhone = self.phoneTextField.text;

    sureVC.order = order;
//    @property (nonatomic, copy)NSString *name;
//    @property (nonatomic, copy)NSString *totalPrice;
//    @property (nonatomic, copy)NSString *usetime;
//    @property (nonatomic, copy)NSString *whichroom;
//    @property (nonatomic, copy)NSString *productID;
//    @property (nonatomic, copy)NSString *qixian;
//    @property (nonatomic, assign) NSInteger *orderCount;
//    
//    @property (nonatomic, copy)NSString *userName;
//    @property (nonatomic, copy)NSString *userIDCard;
//    @property (nonatomic, copy)NSString *userPhone;
//    sureVC
}

#pragma mark -  购买数量增加减少
- (IBAction)addCount {
    
    int count = self.countTextField.text.intValue;
    count++;
    
    if (count<0) {
        count = 1;
    }
    self.countTextField.text = [NSString stringWithFormat:@"%d", count];
}

- (IBAction)reduceCount {
    
    int count = self.countTextField.text.intValue;
    if (count>0) {
        count--;
    }
    self.countTextField.text = [NSString stringWithFormat:@"%d", count];
}

#pragma mark -  提交订单
- (IBAction)commitOrder {
    
    
    
    if (self.countTextField.text.intValue <= 0 || self.countTextField.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请填写正确的购买数量"];
        return;
    }

    if (self.nameTextField.text.length == 0) {
        
        [SVProgressHUD showErrorWithStatus:@"请填写姓名"];
        return;
    }
    
    
    NSString *      regex = @"(^[a-zA-Z0-9_\u4e00-\u9fa5]+$)";
    NSPredicate *   pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    if (![pred evaluateWithObject:_nameTextField.text]) {
        
        [SVProgressHUD showErrorWithStatus:@"请填写正确姓名"];
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
    
    
    if ([ZKUserInfo sharedZKUserInfo].ID) {
            

    
    NSMutableDictionary *dic =[NSMutableDictionary dictionary];

     [dic setObject:[ZKUtil timeStamp] forKey:@"TimeStamp"];
     [dic setObject:@"10" forKey:@"interfaceId"];
     [dic setObject:@"createOrder" forKey:@"method"];
     [dic setObject:self.production.pzh_productID forKey:@"pid"];
     [dic setObject:[NSString stringWithFormat:@"%d",[self.countTextField.text integerValue]] forKey:@"buynum"];
     [dic setObject:self.production.pzh_price forKey:@"price"];
     [dic setObject:self.nameTextField.text forKey:@"name"];
     [dic setObject:self.phoneTextField.text forKey:@"phone"];
     [dic setObject:[ZKUserInfo sharedZKUserInfo].ID forKey:@"memberid"];
     [dic setObject:_staDate forKey:@"starttime"];
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
            
            [self performSegueWithIdentifier:@"TicketCommit2Sure" sender:nil];

        
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
    if (self.countTextField == textField) {
        [textField resignFirstResponder];
        [self.nameTextField becomeFirstResponder];
    }else if (self.nameTextField == textField) {
        [textField resignFirstResponder];
       
    }else{
        [textField resignFirstResponder];
    }

    return  YES;
}

- (void)textChange
{  
    int count = self.countTextField.text.intValue;
    if (count <=0) {
        self.reduceButton.enabled = NO;

    }else {
        self.reduceButton.enabled = YES;
    }
    
    if (count>=0) {
        NSString *totalPrice = [NSString stringWithFormat:@"%.2f元", self.countTextField.text.intValue * self.production.pzh_price.doubleValue];
        self.totalPriceLabel.text = [totalPrice stringByReplacingOccurrencesOfString:@".00" withString:@""];
    }
}

#pragma mark - kvo监听购买数量改变
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
 
    int count = self.countTextField.text.intValue;
    if (count <=1 || !self.countTextField.text.length) {
        self.reduceButton.enabled = NO;

    }else {
        self.reduceButton.enabled = YES;
    }
    
    if (count>0) {
        NSString *totalPrice = [NSString stringWithFormat:@"%.2f元", self.countTextField.text.intValue * self.production.pzh_price.doubleValue];
        self.totalPriceLabel.text = [totalPrice stringByReplacingOccurrencesOfString:@".00" withString:@""];
    }

}

- (void)dealloc
{
    [self.countTextField removeObserver:self forKeyPath:@"text"];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
