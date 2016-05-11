//
//  CustomCalendarViewController.h
//  sampleCalendar
//
//  Created by Michael Azevedo on 21/07/2014.
//  Copyright (c) 2014 Michael Azevedo All rights reserved.
//

#import "ZKSuperViewController.h"
@class CustomCalendarViewController;

@protocol CustomCalendarViewControllerDelegate <NSObject>

@optional

- (void)customCalendarViewController:(CustomCalendarViewController *)customCalendarViewController didSelectedDate:(NSDate *)date;

@end

@interface CustomCalendarViewController : ZKSuperViewController
- (void)setDate:(NSString*)dateStr;
@property (weak, nonatomic)id<CustomCalendarViewControllerDelegate>delegate;
@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com