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

@interface ZKDateSelectionViewController ()<CalendarDataSource, CalendarDelegate>

@property (nonatomic, strong) CalendarView * customCalendarView;
@property (nonatomic, strong) NSCalendar * gregorian;
@property (nonatomic, assign) NSInteger currentYear;

@property (nonatomic, strong) NSDate *selectedDate;

@end

@implementation ZKDateSelectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:YJCorl(249, 249, 249)];
    
    self.title = @"选择日期";
    
    _gregorian       = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    _customCalendarView                             = [[CalendarView alloc]initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, (kDeviceHeight-64)*4/7)];
    _customCalendarView.delegate                    = self;
    _customCalendarView.datasource                  = self;
    _customCalendarView.calendarDate                = [NSDate date];
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
    
    NSDateComponents * yearComponent = [_gregorian components:NSCalendarUnitYear fromDate:[NSDate date]];
    _currentYear = yearComponent.year;
    
    
    ZKPickDateView *pickView = [[ZKPickDateView alloc] initWithFrame:CGRectMake(0, _customCalendarView.frame.size.height+74, kDeviceWidth, kDeviceHeight - _customCalendarView.frame.size.height+74)];
    [self.view addSubview:pickView];
    
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

-(void)back
{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    
}

-(void)sender
{
    
    if ([self timeAfterSuper:_selectedDate]) {
        
        [self dismissViewControllerAnimated:YES completion:^{
            
            if ([self timeAfterSuper:_selectedDate]) {
                
                if ([self.delegate respondsToSelector:@selector(customCalendarViewController:didSelectedDate:)]) {
                    [self.delegate customCalendarViewController:self didSelectedDate:self.selectedDate];
                }
            }
            
            
        }];
        
    }else{
        ZKMoreReminderView *more =[[ZKMoreReminderView alloc]initTs:@"温馨提示" MarkedWords:@"当前选择的时间无效，请重新选择时间."];
        [more show];
        [more  sectec:^(int pgx) {
            
            if (pgx == 0) {
                
                [self dismissViewControllerAnimated:YES completion:nil];
            }
        }];
        
    }
    
    
    
}


-(BOOL)timeAfterSuper:(NSDate*)timeDate
{
    
    NSDate *data = [NSDate date];
    
    
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyyMMdd";
    
    NSInteger dateStr = [fmt stringFromDate:_selectedDate].integerValue;
    NSInteger newStr = [fmt stringFromDate:data].integerValue;
    
    if (dateStr == 0) {
        return YES;
    }else{
        
        return dateStr>=newStr ? YES:NO;
        
    }
    NSLog(@"%ld -- %ld",(long)dateStr,(long)newStr);
    
    
    
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
