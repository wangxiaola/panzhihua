//
//  ZKDateSelectionViewController.m
//  CYmiangzhu
//
//  Created by 王小腊 on 16/5/16.
//  Copyright © 2016年 WangXiaoLa. All rights reserved.
//

#import "ZKDateSelectionViewController.h"
#import "CalendarView.h"
#import "ZKMoreReminderView.h"
#import "ZKPickDateView.h"

@interface ZKDateSelectionViewController ()<CalendarDataSource, CalendarDelegate,ZKPickDateViewDelegate>

@property (nonatomic, strong) CalendarView * customCalendarView;
@property (nonatomic, strong) NSCalendar * gregorian;
@property (nonatomic, assign) NSInteger currentYear;

@property (nonatomic, strong) NSDate *selectedDate;
@property (nonatomic, strong) NSString *hmStr;
@property (nonatomic, strong) NSDate * dqDate;
@end

@implementation ZKDateSelectionViewController
-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
   
}

- (instancetype)initNsdate:(NSDate*)date;
{
    self = [super init];
    if (self) {
        
        self.dqDate = date;
    }

    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:YJCorl(249, 249, 249)];
    
     self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithIcon:@"backimage" highIcon:@"backimage" target:self action:@selector(sender)];
    
    self.title = @"选择日期";
    
    self.selectedDate = self.dqDate;
    
    _gregorian       = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
 
    _customCalendarView                             = [[CalendarView alloc]initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, (kDeviceHeight-64)*4/7)];
    _customCalendarView.delegate                    = self;
    _customCalendarView.datasource                  = self;
    _customCalendarView.calendarDate                = self.dqDate;
    _customCalendarView.titleFont                   = [UIFont systemFontOfSize:11];
    //    _customCalendarView.originY                     = 10;
    _customCalendarView.monthAndDayTextColor        = CYBColorGreen;
    _customCalendarView.dayBgColorWithData          = [UIColor whiteColor];
    _customCalendarView.dayBgColorWithoutData       = [UIColor clearColor];
    _customCalendarView.dayBgColorSelected          = [UIColor colorWithRed:51/255.0 green:202/255.0 blue:171/255.0 alpha:1];
    _customCalendarView.dayTxtColorWithoutData      = RGBCOLOR(57, 69, 84);
    _customCalendarView.dayTxtColorWithData         = [UIColor blackColor];
    _customCalendarView.dayTxtColorSelected         = [UIColor whiteColor];
    _customCalendarView.borderColor                 = [UIColor blackColor];
    
    NSDateComponents *components = [_customCalendarView.gregorian  components:_customCalendarView.dayInfoUnits fromDate:_dqDate];
    components.hour         = 0;
    components.minute       = 0;
    components.second       = 0;
    
    _customCalendarView.selectedDate = [_customCalendarView.gregorian dateFromComponents:components];

    
    _customCalendarView.borderWidth                 = 0;
    _customCalendarView.allowsChangeMonthByDayTap   = YES;
    _customCalendarView.allowsChangeMonthByButtons  = YES;
    _customCalendarView.keepSelDayWhenMonthChange   = YES;
    _customCalendarView.nextMonthAnimation          = UIViewAnimationOptionTransitionCrossDissolve;
    _customCalendarView.prevMonthAnimation          = UIViewAnimationOptionTransitionCrossDissolve;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.view addSubview:_customCalendarView];
        _customCalendarView.center = CGPointMake(self.view.center.x, _customCalendarView.center.y);
    });
    
    NSDateComponents * yearComponent = [_gregorian components:NSCalendarUnitYear fromDate:self.dqDate];
    _currentYear = yearComponent.year;
    
    
    ZKPickDateView *pickView = [[ZKPickDateView alloc] initWithFrame:CGRectMake(0, _customCalendarView.frame.size.height+74, kDeviceWidth, kDeviceHeight - _customCalendarView.frame.size.height+74) selcetDate:self.dqDate];
    
    pickView.delegate = self;
    [self.view addSubview:pickView];
    [pickView xqData];
}
#pragma mark - Gesture recognizer

-(void)swipeleft:(id)sender
{
    [_customCalendarView showNextMonth];
}

-(void)swiperight:(id)sender
{
    [_customCalendarView showPreviousMonth];
}

#pragma mark - CalendarDelegate protocol conformance

-(void)dayChangedToDate:(NSDate *)selectedDate
{
    
    self.selectedDate = selectedDate;
    
    if (![self timeAfterSuper: self.selectedDate]) {
        
        [self.view makeToast:@"亲，不能选择以前的时间。"];
    }
    
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    
}
#pragma mark -- ZKPickDateViewDelegate
- (void)selectHstr:(NSString*)h mStr:(NSString*)m;
{
    self.hmStr = [NSString stringWithFormat:@"%@:%@",h,m];
}

#pragma mark - CalendarDataSource protocol conformance

-(BOOL)isDataForDate:(NSDate *)date
{
    
    
    if ([date compare:[NSDate date]] == NSOrderedAscending)
        return YES;
    return NO;
}

-(BOOL)canSwipeToDate:(NSDate *)date
{
    
    return YES;
}

#pragma mark - Action methods

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(void)sender
{
    
    
    if ([self timeAfterSuper:_selectedDate]) {

        NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
        fmt.dateFormat = @"yyyy-M-d";
        NSString *dateStr = [fmt stringFromDate:_selectedDate];
        [self.delegate customCalendarViewController:self didSelectedDate:[NSString stringWithFormat:@"%@ %@",dateStr,self.hmStr]];
        [self.navigationController popViewControllerAnimated:YES];

    }else{
        
        ZKMoreReminderView *more =[[ZKMoreReminderView alloc]initTs:@"温馨提示" MarkedWords:@"当前选择的时间无效，请重新选择时间."];
        [more show];
        [more  sectec:^(int pgx) {
            
            if (pgx == 0) {
                
              [self.navigationController popViewControllerAnimated:YES];
            }
        }];
        
    }
    
    
    
}


-(BOOL)timeAfterSuper:(NSDate*)timeDate
{
    
    NSDate *data = [NSDate date];
    
    
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyyMd";
    
    NSInteger dateStr = [fmt stringFromDate:_selectedDate].integerValue;
    NSInteger newStr = [fmt stringFromDate:data].integerValue;
    
    if (dateStr == 0) {
        return YES;
    }else{
        
        return dateStr>=newStr ? YES:NO;
        
    }
    
    
    
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
