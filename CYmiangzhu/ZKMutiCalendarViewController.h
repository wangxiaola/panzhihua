//
//  ZKMutiCalendarViewController.h
//  CYmiangzhu
//
//  Created by 汤亮 on 15/9/30.
//  Copyright © 2015年 WangXiaoLa. All rights reserved.
//

#import "ZKSuperViewController.h"

@class ZKMutiCalendarViewController;

@protocol ZKMutiCalendarViewControllerDelegate <NSObject>

@optional
- (void)mutiCalendarViewController:(ZKMutiCalendarViewController *)mutiCalendarViewController didSelectRangeFrom:(NSDate *)startDate to:(NSDate *)endDate dayCount:(NSInteger)dayCount;

@end

@interface ZKMutiCalendarViewController : ZKSuperViewController
@property (weak, nonatomic)id<ZKMutiCalendarViewControllerDelegate>delegate;

-(void)didSelectRangeFrom:(NSDate *)startDate to:(NSDate *)endDate;

@end
