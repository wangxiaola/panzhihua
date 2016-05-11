//
//  UIBarButtonItem+Custom.m
//  guide
//
//  Created by 汤亮 on 15/10/6.
//  Copyright © 2015年 daqsoft. All rights reserved.
//

#import "UIBarButtonItem+Custom.h"

@implementation UIBarButtonItem (Custom)


+ (UIBarButtonItem *)itemWithIcon:(NSString *)icon highIcon:(NSString *)highIcon target:(id)target action:(SEL)action
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    if (icon) {
        [button setBackgroundImage:[UIImage imageNamed:icon] forState:UIControlStateNormal];
    }
    if (highIcon) {
        [button setBackgroundImage:[UIImage imageNamed:highIcon] forState:UIControlStateHighlighted];
    }
    button.frame = (CGRect){CGPointZero, button.currentBackgroundImage.size};
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return [[UIBarButtonItem alloc] initWithCustomView:button];
}
@end
