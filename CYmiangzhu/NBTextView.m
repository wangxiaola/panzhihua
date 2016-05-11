//
//  NBTextView.m
//  28-Quart2D-带有placeholder的UITextView
//
//  Created by Mac on 14-10-27.
//  Copyright (c) 2014年 TL. All rights reserved.
//

#import "NBTextView.h"

@implementation NBTextView

- (void)setPlaceHolder:(NSString *)placeHolder
{
    _placeHolder = placeHolder;
    
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = self.font;
    if (self.text.length) {
        // 保证alpha为0即可，即隐藏placeHolder
        attrs[NSForegroundColorAttributeName] = [UIColor colorWithWhite:1.0 alpha:0.0];
    } else {
        // 当文本框没有文字时，placeHolder显示
        attrs[NSForegroundColorAttributeName] = [UIColor grayColor];
    }
        // 画文字
    [self.placeHolder drawAtPoint:CGPointMake(10, 8) withAttributes:attrs];
}

@end
