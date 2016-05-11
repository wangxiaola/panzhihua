//
//  ZKCircleBackButton.m
//  CYmiangzhu
//
//  Created by 汤亮 on 15/12/23.
//  Copyright © 2015年 WangXiaoLa. All rights reserved.
//

#import "ZKCircleBackButton.h"

@implementation ZKCircleBackButton

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        self.imageView.contentMode = UIViewContentModeCenter;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.imageView.contentMode = UIViewContentModeCenter;
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    [[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.5] set];
    
    CGContextAddEllipseInRect(ctx, CGRectMake(0, 0,rect.size.width, rect.size.height));
    CGContextFillPath(ctx);
    
}

@end
