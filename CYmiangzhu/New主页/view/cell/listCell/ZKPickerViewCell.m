//
//  ZKPickerViewCell.m
//  CYmiangzhu
//
//  Created by 小腊 on 16/5/16.
//  Copyright © 2016年 WangXiaoLa. All rights reserved.
//

#import "ZKPickerViewCell.h"

@implementation ZKPickerViewCell

- (instancetype)initWithFrame:(CGRect)frame ;
{

    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        self.label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.width)];
        self.label.textColor = [UIColor grayColor];
        self.label.textAlignment = NSTextAlignmentCenter;
        self.label.center = self.center;
        self.label.font = [UIFont systemFontOfSize:18];
        self.label.font = [UIFont boldSystemFontOfSize:18];
        [self addSubview:self.label];
        
    }
    
    return self;
}

- (void)select;
{
    self.label.layer.masksToBounds = YES;
    self.label.layer.cornerRadius = self.frame.size.width/2;
    self.label.layer.borderColor = CYBColorGreen.CGColor;
    self.label.textColor = CYBColorGreen;
    self.label.layer.borderWidth = 1;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
