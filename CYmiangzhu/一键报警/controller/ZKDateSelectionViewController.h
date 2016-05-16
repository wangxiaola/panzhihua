//
//  ZKDateSelectionViewController.h
//  CYmiangzhu
//
//  Created by 王小腊 on 16/5/16.
//  Copyright © 2016年 WangXiaoLa. All rights reserved.
//

#import "ZKNewBaseViewController.h"

@class CustomCalendarViewController;

@protocol CustomCalendarViewControllerDelegate <NSObject>

@optional

- (void)customCalendarViewController:(CustomCalendarViewController *)customCalendarViewController didSelectedDate:(NSDate *)date;

@end


@interface ZKDateSelectionViewController : ZKNewBaseViewController

@property (weak, nonatomic)id<CustomCalendarViewControllerDelegate>delegate;
@end
