//
//  ZKDateSelectionViewController.h
//  CYmiangzhu
//
//  Created by 王小腊 on 16/5/16.
//  Copyright © 2016年 WangXiaoLa. All rights reserved.
//

#import "ZKNewBaseViewController.h"

@class ZKDateSelectionViewController;

@protocol CustomCalendarViewControllerDelegate <NSObject>

@optional

- (void)customCalendarViewController:(ZKDateSelectionViewController *)customCalendarViewController didSelectedDate:(NSString *)date;

@end

/**
 *  时间选择
 */
@interface ZKDateSelectionViewController : ZKNewBaseViewController

@property (weak, nonatomic)id<CustomCalendarViewControllerDelegate>delegate;

- (instancetype)initNsdate:(NSDate*)date;

@end
