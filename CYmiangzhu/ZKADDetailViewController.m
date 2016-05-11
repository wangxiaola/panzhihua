//
//  ZKADDetailViewController.m
//  CYmiangzhu
//
//  Created by 汤亮 on 15/10/21.
//  Copyright © 2015年 WangXiaoLa. All rights reserved.
//

#import "ZKADDetailViewController.h"
#import "ZKcarrierViewController.h"
#import "ZKAppDelegate.h"

@interface ZKADDetailViewController ()

@end

@implementation ZKADDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.leftBarButtonItem = [[UIButton alloc]initWithFrame:CGRectMake(2, 20, buttonItemWidth, buttonItemWidth)];
    [self.leftBarButtonItem setImage:[UIImage imageNamed:@"backimage"] forState:UIControlStateNormal];
    [self.leftBarButtonItem addTarget:self action:@selector(navback) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationBarView  addSubview:self.leftBarButtonItem];
}



- (void)navback
{
    ZKcarrierViewController *hom =[[ZKcarrierViewController alloc]init];
    UINavigationController *nav =[[UINavigationController alloc]initWithRootViewController:hom];
    nav.navigationBarHidden =YES;
    [APPDELEGATE window].rootViewController =nav;
    
}

@end
