//
//  ZKMutiCalendarViewController.m
//  CYmiangzhu
//
//  Created by 汤亮 on 15/9/30.
//  Copyright © 2015年 WangXiaoLa. All rights reserved.
//

#import "ZKMutiCalendarViewController.h"
#import "CXMultidateCalendarView.h"
#import "CXCalendarCellView.h"
@interface ZKMutiCalendarViewController()<CXMultidateCalendarViewDelegate>
@property(weak, nonatomic) CXMultidateCalendarView *calendarView;

@property(strong, nonatomic)UILabel *enterLabel;
@property(strong, nonatomic)UILabel *leaveLabel;
@end

@implementation ZKMutiCalendarViewController

- (UILabel *)enterLabel
{
    if (_enterLabel == nil) {
        self.enterLabel = [[UILabel alloc] init];
        _enterLabel.text = @"入住";
        _enterLabel.font = [UIFont systemFontOfSize:10];
        _enterLabel.textColor = [UIColor whiteColor];
        _enterLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _enterLabel;
}


- (UILabel *)leaveLabel
{
    if (_leaveLabel == nil) {
        self.leaveLabel = [[UILabel alloc] init];
        _leaveLabel.text = @"离开";
        _leaveLabel.font = [UIFont systemFontOfSize:10];
        _leaveLabel.textColor = [UIColor whiteColor];
        _leaveLabel.textAlignment = NSTextAlignmentCenter;
      
    }
    
    return _leaveLabel;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.titeLabel.text = @"选择日期";
    
    [[BaiduMobStat defaultStat] logEvent:@"select_hotel_time" eventLabel:@"选择住宿时间"];
    
    CXMultidateCalendarView *calendarView = [[CXMultidateCalendarView alloc] initWithFrame: CGRectMake(0, 64, self.view.bounds.size.width, 320)];
    
    calendarView.delegate = self;
    [self.view addSubview: calendarView];
    
    self.calendarView = calendarView;

    UIButton *bty =[[UIButton alloc]initWithFrame:CGRectMake(30, kDeviceHeight - 100, kDeviceWidth-60, 36)];
    bty.backgroundColor = CYBColorGreen;
    [bty setTitle:@"确 定" forState:0];
    bty.layer.masksToBounds = YES;
    bty.layer.cornerRadius = 4;
    [bty addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [bty setTitleColor:[UIColor whiteColor] forState:0];
    bty.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:bty];
    
    
    
    
}

-(void)didSelectRangeFrom:(NSDate *)startDate to:(NSDate *)endDate;
{

    self.calendarView.startDate = startDate;
    self.calendarView.endDate = endDate;
    
}


- (void)back
{
    [self dismissViewControllerAnimated:YES completion:nil];

}

#pragma mark CXCalendarViewDelegate

- (void) calendarView: (CXCalendarView *) calendarView
        didSelectDate: (NSDate *) date {
    
    [self.enterLabel removeFromSuperview];
    [self.leaveLabel removeFromSuperview];
}

- (void)calendarView:(CXCalendarView *)calendarView didSelectRangeFrom:(NSDate *)startDate to:(NSDate *)endDate
{
    
    CXCalendarCellView *startCell = [calendarView cellForDate:startDate];
    CXCalendarCellView *endCell = [calendarView cellForDate:endDate];
  
    self.enterLabel.frame = CGRectMake(0, startCell.height -20, startCell.width, 20);
    self.leaveLabel.frame = CGRectMake(0, endCell.height -20, endCell.width, 20);
    
    [startCell addSubview:self.enterLabel];
    [endCell addSubview:self.leaveLabel];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierChinese];
    
    NSDateComponents *cmp = [calendar components:NSCalendarUnitDay fromDate:startDate toDate:endDate options:0];
    
    if ([self.delegate respondsToSelector:@selector(mutiCalendarViewController:didSelectRangeFrom:to:dayCount:)]) {
        [self.delegate mutiCalendarViewController:self didSelectRangeFrom:startDate to:endDate dayCount:cmp.day];
    }
    
    
}


@end
