//
//  ZKNavigationController.m
//  guide
//
//  Created by 汤亮 on 15/10/6.
//  Copyright © 2015年 daqsoft. All rights reserved.
//

#import "ZKNavigationController.h"
#import "UIBarButtonItem+Custom.h"

@interface ZKNavigationController ()

@end

@implementation ZKNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //打开滑动返回
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.interactivePopGestureRecognizer.delegate = nil;
    }

}

+ (void)initialize
{
    UINavigationBar *bar = [UINavigationBar appearance];
    [bar setBarTintColor:[UIColor whiteColor]];
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSForegroundColorAttributeName] = [UIColor whiteColor];
    attrs[NSFontAttributeName] = [UIFont boldSystemFontOfSize:20];
    [bar setTitleTextAttributes:attrs];
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.viewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
        viewController.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithIcon:@"backimage" highIcon:nil target:self action:@selector(back)];
    }

    [super pushViewController:viewController animated:animated];
}

- (void)back
{
    [self popViewControllerAnimated:YES];
}

@end
