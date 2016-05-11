//
//  UIBarButtonItem+YY.m
//  mocha
//
//  Created by AIR on 13-5-21.
//  Copyright (c) 2013年 yunyao. All rights reserved.
//

#import "UIBarButtonItem+YY.h"

@implementation UIBarButtonItem (YY)

+(UIBarButtonItem *)barItemWithImage:(UIImage *)image target:(id)target action:(SEL)action{
    CGFloat offset = 0;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 23+offset, 23);
    [button setImage:image forState:UIControlStateNormal];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [button setImageEdgeInsets:UIEdgeInsetsMake(0, offset, 0, 0)];
    return [[UIBarButtonItem alloc] initWithCustomView:button];
}

@end
