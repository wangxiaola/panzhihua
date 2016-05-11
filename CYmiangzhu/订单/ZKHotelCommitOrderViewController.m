//
//  ZKHotelCommitOrderViewController.m
//  CYmiangzhu
//
//  Created by 汤亮 on 15/9/28.
//  Copyright © 2015年 WangXiaoLa. All rights reserved.
//

#import "ZKHotelCommitOrderViewController.h"
#import "ZKTextField.h"
#import "ZKProduction.h"
#import "ZKHotelSureOrderViewController.h"
#import "ZKOrder.h"
#import "ZKregisterViewController.h"
#import "ZKMutiCalendarViewController.h"

@interface ZKHotelCommitOrderViewController()<UITextFieldDelegate, UIScrollViewDelegate,ZKMutiCalendarViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *dayCountLabel;

@property (weak, nonatomic) IBOutlet UILabel *enterLeaveLabel;
@property (weak, nonatomic) IBOutlet ZKTextField *nameTextField;
@property (weak, nonatomic) IBOutlet ZKTextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UILabel *totalPriceLabel;
@property (weak, nonatomic) IBOutlet UIButton *commitButton;
@property (weak, nonatomic) IBOutlet UILabel *productionNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *houseTypeLabel;

@property (weak, nonatomic) IBOutlet UITextField *countTextField;
@property (weak, nonatomic) IBOutlet UIButton *reduceButton;
@property (weak, nonatomic) IBOutlet UIButton *addButton;
@property (retain,nonatomic)NSArray *titisArray;

@property (assign,nonatomic) NSInteger number;
@property (strong,nonatomic) NSString *staDate;
@property (strong,nonatomic) NSString *endDate;
@property (nonatomic,strong) NSString * url;
@property (nonatomic,strong) NSString *ored;
- (IBAction)commitOrder;

@property (assign, nonatomic)NSInteger dayCount;

@end

@implementation ZKHotelCommitOrderViewController

@synthesize number;


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNavigationBar];
    [self setupTextField];
    
    [self setupData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChange) name:UITextFieldTextDidChangeNotification object:self.countTextField];
    
    [self.countTextField addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionNew context:nil];
    
    [self observeValueForKeyPath:nil ofObject:nil change:@{@"new":self.countTextField.text} context:nil];
    
}

#pragma mark -  购买数量增加减少

- (IBAction)AddSnder:(UIButton *)sender {
    
    NSLog(@" ihweicudshvciwu ");
    int count = self.countTextField.text.intValue;
    count++;
    
    if (count<0) {
        count = 1;
    }
    self.countTextField.text = [NSString stringWithFormat:@"%d", count];
}
- (IBAction)reduecSender:(UIButton *)sender {
    
    
    int count = self.countTextField.text.intValue;
    if (count>0) {
        count--;
    }
    self.countTextField.text = [NSString stringWithFormat:@"%d", count];
    
}



#pragma mark - 初始化数据
- (void)setupData
{
    self.titisArray = [self.production.pzh_name componentsSeparatedByString:@"-"];
    
    self.productionNameLabel.text = self.titisArray[0];
    self.priceLabel.text = [NSString stringWithFormat:@"%@元", self.production.pzh_price];
    

    NSArray *dateArray = [self.production.pzh_qixian componentsSeparatedByString:@","];
    _staDate = dateArray[0];
    _endDate = dateArray[1];
    NSString *enter = [NSString stringWithFormat:@"%@入住", [self exchangeDateString:dateArray[0]]];
    NSString *leave = [NSString stringWithFormat:@"%@离开", [self exchangeDateString:dateArray[1]]];
    
    self.enterLeaveLabel.text = [NSString stringWithFormat:@"%@ %@", enter, leave];
    
   
    self.dayCount = [self stayNightDaysWithEnter:dateArray[0] leave:dateArray[1]];
     number = self.dayCount;
    self.dayCountLabel.text = [NSString stringWithFormat:@"共%ld晚", (long)number];
    
    
    self.houseTypeLabel.text = self.titisArray[1];
    
    NSString *totalPrice = [NSString stringWithFormat:@"%.2f元", self.production.pzh_price.doubleValue * self.dayCount];
    self.totalPriceLabel.text = [totalPrice stringByReplacingOccurrencesOfString:@".00" withString:@""];
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

#pragma mark - 转换时间格式
- (NSString *)exchangeDateString:(NSString *)dateString
{
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-M-d";
    fmt.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
   
    NSDate *date = [fmt dateFromString:dateString];
    fmt.dateFormat = @"M月d日";
    
    return [fmt stringFromDate:date];
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
    
}

#pragma mark - 设置导航栏
- (void)setupNavigationBar
{
    self.titeLabel.text = @"提交订单";
    [self.navigationController setNavigationBarHidden:YES];
    
    self.priceLabel.textColor = YJCorl(51, 202, 171);
    self.dayCountLabel.textColor = YJCorl(51, 202, 171);
    self.totalPriceLabel.textColor = YJCorl(214, 116, 0);
    self.nameTextField.textColor = YJCorl(51, 202, 171);
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

    ZKHotelSureOrderViewController *hotelSureVC = segue.destinationViewController;
    ZKOrder *order = [[ZKOrder alloc] init];
    order.name = self.productionNameLabel.text;
    order.dayCount = self.dayCountLabel.text;
    order.enterLeave = self.enterLeaveLabel.text;
    order.userName = self.nameTextField.text;
    order.userPhone = self.phoneTextField.text;
    order.usetime = [NSString stringWithFormat:@"%ld",(long)number];
    order.productID = self.production.pzh_productID;
    order.totalPrice = [NSString stringWithFormat:@"%.2f", self.countTextField.text.intValue * self.production.pzh_price.doubleValue * number];
    order.payurl = _url;
    order.ordercode = _ored;
    hotelSureVC.order = order;
}
/**
 *  选择日期
 *
 *  @param sender
 */
- (void)sectDate {
    
    
    ZKMutiCalendarViewController *datePickerTwo = [[ZKMutiCalendarViewController alloc] init];
    datePickerTwo.delegate = self;
    [self presentViewController:datePickerTwo animated:YES completion:nil];
    
}

#pragma mark   选择时间代理
- (void)mutiCalendarViewController:(ZKMutiCalendarViewController *)mutiCalendarViewController didSelectRangeFrom:(NSDate *)startDate to:(NSDate *)endDate dayCount:(NSInteger)dayCount
{


    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"M月d日";
    fmt.locale = [NSLocale localeWithLocaleIdentifier:@"en_US"];
    
    NSDateFormatter *fmtt = [[NSDateFormatter alloc] init];
    fmtt.dateFormat = @"yyyy-MM-dd";
    fmtt.locale = [NSLocale localeWithLocaleIdentifier:@"en_US"];
    
    _staDate = [fmtt stringFromDate:startDate];
    _endDate = [fmtt stringFromDate:endDate];
    
    NSString *start = [fmt stringFromDate:startDate];
    NSString *end = [fmt stringFromDate:endDate];
    
    number =dayCount;
     self.enterLeaveLabel.text = [NSString stringWithFormat:@"%@入住 %@离开", start, end];
     self.dayCountLabel.text = [NSString stringWithFormat:@"共%ld晚", (long)dayCount];
    
    [self observeValueForKeyPath:nil ofObject:nil change:@{@"new":self.countTextField.text} context:@""];
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
        [dic setObject:[NSString stringWithFormat:@"%d",[self.countTextField.text integerValue]*number] forKey:@"buynum"];
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
                
                [self performSegueWithIdentifier:@"HotelCommit2Sure" sender:nil];
                
                
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
    if (self.nameTextField == textField) {
        [textField resignFirstResponder];
        
    }else{
        [textField resignFirstResponder];
    }
    
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
        NSString *totalPrice = [NSString stringWithFormat:@"%.2f元", self.countTextField.text.intValue * self.production.pzh_price.doubleValue * number];
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
        
        NSString *totalPrice = [NSString stringWithFormat:@"%.2f元", self.countTextField.text.intValue * self.production.pzh_price.doubleValue * number];
        self.totalPriceLabel.text = [totalPrice stringByReplacingOccurrencesOfString:@".00" withString:@""];
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 &&indexPath.row == 1) {
        [self sectDate];
    }

}

- (void)dealloc
{
    [self.countTextField removeObserver:self forKeyPath:@"text"];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
