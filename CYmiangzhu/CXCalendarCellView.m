//
//  CXCalendarCellView.m
//  Calendar
//
//  Created by Vladimir Grichina on 13.07.11.
//  Copyright 2011 Componentix. All rights reserved.
//

#import "CXCalendarCellView.h"

@implementation CXCalendarCellView

- (UILabel *)enterLabel
{
    if (_enterLabel == nil) {
        self.enterLabel = [[UILabel alloc] init];
        _enterLabel.text = @"入住";
        _enterLabel.font = [UIFont systemFontOfSize:10];
        _enterLabel.textColor = [UIColor whiteColor];
        _enterLabel.textAlignment = NSTextAlignmentCenter;
        _enterLabel.frame = CGRectMake(0, self.frame.size.height - 20, self.frame.size.width, 20);
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
        _leaveLabel.frame = CGRectMake(0, self.frame.size.height - 20, self.frame.size.width, 20);
    }
    
    return _leaveLabel;
}


- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.layer.cornerRadius = 3;
        self.layer.masksToBounds = YES;
        [self setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    }
    return self;
}

- (void) setDay: (NSUInteger) day {
    if (_day != day) {
        _day = day;
        [self setTitle: [NSString stringWithFormat: @"%zd", _day] forState: UIControlStateNormal];
    }
}

- (NSDate *) dateWithBaseDate: (NSDate *) baseDate withCalendar: (NSCalendar *)calendar {
    NSDateComponents *components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth
                                               fromDate:baseDate];
    components.day = self.day;
    return [calendar dateFromComponents:components];
}

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];

    if (selected) {
        self.backgroundColor = self.selectedBackgroundColor;
    } else {
        self.backgroundColor = self.normalBackgroundColor;
    }
}

-(void)dealloc
{
    [_enterLabel release];
    [_leaveLabel release];
    [_cellDate release];
    [super dealloc];
}

@end
