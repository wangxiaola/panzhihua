//
//  ZKCallPoliceViewController.m
//  CYTemplate
//
//  Created by 王小腊 on 16/5/11.
//  Copyright © 2016年 王小腊. All rights reserved.
//

#import "ZKCallPoliceViewController.h"
#import "ZKCallPoliceTableViewCell.h"
#import "ZKCallLabelTableViewCell.h"
#import "GSLocationTool.h"
#import "ZKDateSelectionViewController.h"

static NSString *labelCell = @"labelCell";

@interface ZKCallPoliceViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UITextViewDelegate,CustomCalendarViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *lefTitleArray;
@property (strong, nonatomic) NSArray *lefImageArray;
@property (strong, nonatomic) NSArray *labelArray;

@property (strong, nonatomic) NSString *lableStr;//标签
@property (weak, nonatomic) UITextField *dataTextFielf;
@property (weak, nonatomic) UITextField *adderTextFielf;
@property (weak, nonatomic) UITextField *phoneTextFielf;
@property (strong, nonatomic) UITextView *textViewS;
@property (strong, nonatomic) UILabel *inforlabel;
@property (strong, nonatomic) UIView *footerView;
@end


@implementation ZKCallPoliceViewController

@synthesize inforlabel = inforlabel;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"一键报警";
    

    self.lefTitleArray = @[@"事件时间",@"发生地点",@"联系电话",@"快速选择标签"];
    self.lefImageArray = @[@"callPolice_0",@"callPolice_1",@"callPolice_2",@"callPolice_3"];
    self.labelArray = @[@"车没油",@"滑坡",@"火灾",@"有人受伤",@"迷路",@"斗殴",@"群体事件",@"投诉"];
    _tableView.backgroundColor = YJCorl(249, 249, 249);
    //去掉plain样式下多余的分割线
    _tableView.tableFooterView = [[UIView alloc] init];
    //设置分割线左边无边距，默认是15
    _tableView.separatorInset = UIEdgeInsetsZero;
    _tableView.estimatedRowHeight = 44; //预估行高 可以提高性能
    _tableView.delegate =self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
    [_tableView registerNib:[UINib nibWithNibName:@"ZKCallPoliceTableViewCell" bundle:nil] forCellReuseIdentifier:ZKCallPoliceCellID];
    _tableView.tableFooterView = [self cjFooterView];
    
    
    int64_t delayInSeconds = 0.5;
    
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        
        __weak typeof(self)weekSelf = self;
        
        [[GSLocationTool sharedLocationTool] getProvinceAndCompletion:^(NSString *province, NSString *city) {
            
            weekSelf.adderTextFielf.text = [NSString stringWithFormat:@"%@%@",province,city];

            
        } error:nil];
        
        if ([ZKUserInfo sharedZKUserInfo].mobile)
        {
            
            self.phoneTextFielf.text = [ZKUserInfo sharedZKUserInfo].mobile;
        }
        
        // NSDate 日期类型
        NSDate *date = [NSDate date];
        //1,创建一个日期格式化器
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        // 2,设置格式
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        // 3,格式化日期
        NSString *dataStr = [formatter stringFromDate:date];
        self.dataTextFielf.text = dataStr;

        
    });
    

   
    
}

- (UIView*)cjFooterView
{

    self.footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, 120)];
    self.footerView.backgroundColor = YJCorl(249, 249, 249);
    UIButton *tsBtton =[[UIButton alloc]initWithFrame:CGRectMake(20, 20, kDeviceWidth-40, 34)];
    tsBtton.layer.masksToBounds =YES;
    tsBtton.layer.cornerRadius =8;
    tsBtton.backgroundColor = [UIColor orangeColor];
    [tsBtton setTitle:@"确认提交" forState:UIControlStateNormal];
    tsBtton.titleLabel.font =[UIFont systemFontOfSize:14];
    [tsBtton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [tsBtton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [tsBtton addTarget:self action:@selector(tsbuttonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.footerView addSubview:tsBtton];

    return self.footerView;
}
#pragma  mark table 代理

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3 - section;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 1 && indexPath.row == 1) {
        
        ZKCallLabelTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:labelCell];
        if (!cell) {
            
            cell = [[ZKCallLabelTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:labelCell listData:self.labelArray];
            
        }
        __weak typeof(self)weekSelf = self;
        [cell choice:^(NSInteger index) {
            
            weekSelf.lableStr = weekSelf.labelArray[index];
        }];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else if (indexPath.section == 2)
    {
        
        static NSString *indentfier = @"inforCell";
        
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:indentfier];
        if (!cell) {
            
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentfier];
            
            self.textViewS =[[UITextView alloc]initWithFrame:CGRectMake(5, 5, self.view.frame.size.width-10 , 110)];
            self.textViewS.backgroundColor =[UIColor whiteColor];
            self.textViewS.font =[UIFont systemFontOfSize:13];
            self.textViewS.delegate =self;
            self.textViewS.textColor =[UIColor blackColor];
            [cell addSubview:self.textViewS];
            
            inforlabel =[[UILabel alloc]init];
            inforlabel.frame =CGRectMake(10, 5, self.view.frame.size.width -20, 20);
            inforlabel.text = @"请填写事件简述...";
            inforlabel.font =[UIFont systemFontOfSize:13];
            inforlabel.textColor =TabelBackCorl;
            inforlabel.enabled = NO;
            inforlabel.backgroundColor = [UIColor clearColor];
            [self.textViewS addSubview:inforlabel];

            
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
        
    }
    else
    {
        
        NSString *indentfier = [NSString stringWithFormat:@"stataCell%d",indexPath.row];
        
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:indentfier];
        if (!cell) {
            
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:indentfier];
            
            if (indexPath.section == 0)
            {
                
                cell.textLabel.text = self.lefTitleArray[indexPath.row];
                
                if (indexPath.row == 0)
                {
                    self.dataTextFielf = [self cjTextFiled];
                    self.dataTextFielf.placeholder = @"请选择";
                    self.dataTextFielf.userInteractionEnabled = NO;
                    [cell addSubview:self.dataTextFielf];
                }
                else if (indexPath.row == 1)
                {
                    self.adderTextFielf = [self cjTextFiled];
                    self.adderTextFielf.placeholder = @"请填写";
                    [cell addSubview:self.adderTextFielf];
                }
                else if (indexPath.row == 2)
                {
                    self.phoneTextFielf = [self cjTextFiled];
                    self.phoneTextFielf.placeholder = @"请填写";
                    self.phoneTextFielf.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
                    [cell addSubview:self.phoneTextFielf];
                }
                
            }
            
            
        }
        if (indexPath.section == 0)
        {
            
            cell.textLabel.text = self.lefTitleArray[indexPath.row];
            
            cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
            
            cell.imageView.image = [UIImage imageNamed:self.lefImageArray[indexPath.row]];
        }
        else
        {
            cell.textLabel.text =self.lefTitleArray[3];
            cell.accessoryType=UITableViewCellAccessoryNone;
            cell.imageView.image = [UIImage imageNamed:self.lefImageArray[3]];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.textLabel.textColor = [UIColor blackColor];
        
        return cell;
        
    }
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (indexPath.section == 0 && indexPath.row == 0) {
        
        ZKDateSelectionViewController *dateVc = [[ZKDateSelectionViewController alloc] init];
        dateVc.delegate = self;
        [self.navigationController pushViewController:dateVc animated:YES];
        
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 8;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 2)
    {
        
        return 120;
    }
    else if (indexPath.section == 1 && indexPath.row == 1)
    {
        
        return 70;
    }
    else
    {
        
        return 44;
    }
    
}

- (UITextField*)cjTextFiled
{
    
    UITextField * field = [[UITextField alloc] initWithFrame:CGRectMake(kDeviceWidth-200, 0, 170, 44)];
    field.borderStyle = UITextBorderStyleNone;
    field.textAlignment =NSTextAlignmentRight;
    field.returnKeyType =UIReturnKeySend;
    field.font = [UIFont systemFontOfSize:14];
    field.textColor = [UIColor grayColor];
    field.delegate = self;
    return field;
    
}
#pragma mark textField
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.phoneTextFielf resignFirstResponder];
    [self.adderTextFielf resignFirstResponder];
    
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField;
{
    [textField resignFirstResponder];
    return YES;
}

#pragma  mark dataPick Delegate 

- (void)customCalendarViewController:(CustomCalendarViewController *)customCalendarViewController didSelectedDate:(NSDate *)date;
{

}

#pragma mark - UITextView delegate methods
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView;
{
    
    if (textView.text.length>200) {
        
        return;
        [self.view makeToast:@"投诉内容不能超过200字。"];
    }
    self.textViewS.text =  textView.text;
    if (textView.text.length == 0) {
        inforlabel.text = @"请填写事件简述...";
    }else{
        
        inforlabel.text = @"";
    }
    
}
- (void)textViewDidBeginEditing:(UITextView *)textView;
{
    
    [UIView animateWithDuration:0.4 animations:^{
        self.view.center = CGPointMake(kDeviceWidth/2, kDeviceHeight/2 -140+self.tableView.contentOffset.y);
    }];
}
- (void)textViewDidEndEditing:(UITextView *)textView;
{

    [UIView animateWithDuration:0.4 animations:^{
        self.view.center = CGPointMake(kDeviceWidth/2, kDeviceHeight/2 );
    }];
    
}

#pragma mark button 提交

- (void)tsbuttonClick
{

    if (!self.adderTextFielf.text)
    {
        
        [self.view makeToast:@"请填写地址"];
        return;
    }
    if (!self.phoneTextFielf.text) {
        
        [self.view makeToast:@"请填写电话号码"];
        return;
    }
    
    if (![ZKUtil isValidateTelNumber:self.phoneTextFielf.text])
    {
        [self.view makeToast:@"请填写正确的电话号码"];
        return;
    }
    
    if (!self.lableStr)
    {
        [self.view makeToast:@"请选择事件标签"];
        return;
        
    }
    
    

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
