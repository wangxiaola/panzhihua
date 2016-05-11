//
//  ZKDetailTimeView.m
//  CYmiangzhu
//
//  Created by 汤亮 on 16/1/7.
//  Copyright © 2016年 WangXiaoLa. All rights reserved.
//

#import "ZKDetailTimeView.h"

@interface ZKDetailTimeView()
@property (weak, nonatomic) IBOutlet UILabel *enterTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *leaveTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *daycountLabel;
@end

@implementation ZKDetailTimeView
@synthesize enterTime = _enterTime;
@synthesize leaveTime = _leaveTime;

+ (instancetype)detailTimeView
{
    ZKDetailTimeView *detailTimeView = [[[NSBundle mainBundle] loadNibNamed:@"ZKDetailTimeView" owner:nil options:nil] firstObject];
    
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-M-d";
    NSDate *now = [NSDate date];
    detailTimeView.enterTimeLabel.text = [fmt stringFromDate:now];
    detailTimeView.leaveTimeLabel.text = [fmt stringFromDate:[now dateByAddingTimeInterval:24 * 60 * 60]];
    detailTimeView.daycountLabel.text = @"共1天";
    detailTimeView.enterTime = [fmt stringFromDate:now];
    detailTimeView.leaveTime = [fmt stringFromDate:[now dateByAddingTimeInterval:24 * 60 * 60]];
    return detailTimeView;
}

- (IBAction)selectDate {
    if (self.selectDateBlock) {
        self.selectDateBlock();
    }
}

- (void)setEnterTime:(NSString *)enterTime leaveTime:(NSString *)leaveTime dayCount:(NSInteger)dayCount
{
    self.enterTimeLabel.text = enterTime;
    self.leaveTimeLabel.text = leaveTime;
    self.daycountLabel.text = [NSString stringWithFormat:@"共%ld天", (long)dayCount];
}

- (void)setEnterTime:(NSString *)enterTime
{
    _enterTime = enterTime;
}

- (void)setLeaveTime:(NSString *)leaveTime
{
    _leaveTime = leaveTime;
}

- (NSString *)enterTime
{
    return self.enterTimeLabel.text;
}

- (NSString *)leaveTime
{
    return self.leaveTimeLabel.text;
}

@end
