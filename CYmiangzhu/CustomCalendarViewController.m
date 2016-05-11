//
//  CustomCalendarViewController.h
//  sampleCalendar
//
//  Created by Michael Azevedo on 21/07/2014.
//  Copyright (c) 2014 Michael Azevedo All rights reserved.
//

#import "CustomCalendarViewController.h"
#import "CalendarView.h"
#import "ZKMoreReminderView.h"
@interface CustomCalendarViewController () <CalendarDataSource, CalendarDelegate>

@property (nonatomic, strong) CalendarView * customCalendarView;
@property (nonatomic, strong) NSCalendar * gregorian;
@property (nonatomic, assign) NSInteger currentYear;

@property (nonatomic, strong) NSDate *selectedDate;
@end

@implementation CustomCalendarViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    self.titeLabel.text = @"选择日期";
    

    
  
    UIButton *bty =[[UIButton alloc]initWithFrame:CGRectMake(30, kDeviceHeight - 100, kDeviceWidth-60, 36)];
    bty.backgroundColor = CYBColorGreen;
    [bty setTitle:@"确 定" forState:0];
    bty.layer.masksToBounds = YES;
    bty.layer.cornerRadius = 4;
    [bty addTarget:self action:@selector(sender) forControlEvents:UIControlEventTouchUpInside];
    [bty setTitleColor:[UIColor whiteColor] forState:0];
    bty.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:bty];

}
- (void)back{

    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
- (void)setDate:(NSString*)dateStr;
{


    _gregorian       = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    _customCalendarView                             = [[CalendarView alloc]initWithFrame:CGRectMake(0, 64, kDeviceWidth, 360)];
    _customCalendarView.delegate                    = self;
    _customCalendarView.datasource                  = self;
    _customCalendarView.calendarDate                = [NSDate date];
    _customCalendarView.selectedDate                = [self dateFromString:dateStr];
    _customCalendarView.titleFont                   = [UIFont systemFontOfSize:11];
    //    _customCalendarView.originY                     = 10;
    _customCalendarView.monthAndDayTextColor        = [UIColor colorWithRed:51/255.0 green:202/255.0 blue:171/255.0 alpha:1];
    _customCalendarView.dayBgColorWithData          = [UIColor whiteColor];
    _customCalendarView.dayBgColorWithoutData       = [UIColor whiteColor];
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
    //    _customCalendarView.hideMonthLabel              = YES;
    _selectedDate                                   = [self dateFromString:dateStr];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.view addSubview:_customCalendarView];
        _customCalendarView.center = CGPointMake(self.view.center.x, _customCalendarView.center.y);
    });
    
    NSDateComponents * yearComponent = [_gregorian components:NSCalendarUnitYear fromDate:[NSDate date]];
    _currentYear = yearComponent.year;
    
}

/**
 *  时间转换
 *
 *  @param str 时间字符
 *
 *  @return date
 */
- (NSDate*)dateFromString:(NSString*)str;
{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat: @"yyyy-MM-dd"];
    
    NSDate *destDate= [dateFormatter dateFromString:str];
    
    return destDate;
    
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
    //NSDateComponents * yearComponent = [_gregorian components:NSYearCalendarUnit fromDate:date];
    //return (yearComponent.year == _currentYear || yearComponent.year == _currentYear+1);
    return YES;
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
    NSLog(@"%d -- %d",dateStr,newStr);
    
    
    
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

@end
