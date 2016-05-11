//
//  CXCalendarCellView.h
//  Calendar
//
//  Created by Vladimir Grichina on 13.07.11.
//  Copyright 2011 Componentix. All rights reserved.
//


@interface CXCalendarCellView : UIButton

@property(nonatomic, assign) NSUInteger day;
@property(retain, nonatomic)NSDate *cellDate;
@property(nonatomic, assign) UIColor *normalBackgroundColor;
@property(nonatomic, assign) UIColor *selectedBackgroundColor;

- (NSDate *) dateWithBaseDate: (NSDate *) baseDate withCalendar: (NSCalendar *)calendar;

@property(retain, nonatomic)UILabel *enterLabel;
@property(retain, nonatomic)UILabel *leaveLabel;

@end
