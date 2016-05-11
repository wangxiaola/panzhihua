//
//  DQSuperViewController.m
//  ChangYouYiBin
//
//  Created by Daqsoft-Mac on 14/11/26.
//  Copyright (c) 2014年 StrongCoder. All rights reserved.
//

#import "ZKSuperViewController.h"
#import "ZKAppDelegate.h"

@interface ZKSuperViewController ()
{
    UIView *viewHT;
}
@end

@implementation ZKSuperViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor =YJCorl(249, 249, 249);
    
//    if (IS_IPHONE_5_SCREEN) {
//        
//        buttonItemWidth =25;
//        navHeight = 64.0f;
//    }else{
//        
//        navHeight = 44;
//        buttonItemWidth =44;
//    }
    
    self.navigationBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth,navHeight)];
    self.navigationBarView.backgroundColor = viewsBackCorl;
    [self.view addSubview:self.navigationBarView];
    self.navigationBarView.layer.borderColor =YJCorl(231, 231, 231).CGColor;
    self.navigationBarView.layer.borderWidth =0.4;
    
    self.leftBarButtonItem = [[UIButton alloc]initWithFrame:CGRectMake(2, 20, buttonItemWidth, buttonItemWidth)];
    [self.leftBarButtonItem setImage:[UIImage imageNamed:@"backimage"] forState:UIControlStateNormal];
    self.leftBarButtonItem.backgroundColor =[UIColor clearColor];
    [self.leftBarButtonItem addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
  
    
    self.titeLabel = [[UILabel alloc]initWithFrame:CGRectMake(40, 8, kDeviceWidth-80, navigationHeghit)];
    self.titeLabel.font =[UIFont systemFontOfSize:16];
    self.titeLabel.font =[UIFont boldSystemFontOfSize:16];
    self.titeLabel.textColor =CYBColorGreen;
    self.titeLabel.textAlignment =NSTextAlignmentCenter;
    self.titeLabel.backgroundColor =[UIColor clearColor];
    
    [self.navigationBarView  addSubview:self.titeLabel];
    [self.navigationBarView  addSubview:self.leftBarButtonItem];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, self.navigationBarView.frame.size.height-0.75, self.navigationBarView.frame.size.width, 0.5)];
    lineView.alpha = 0.5;
    lineView.backgroundColor = [UIColor lightGrayColor];
    [self.navigationBarView addSubview:lineView];
    
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
        
    }
}


-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (self.titeLabel.text) {
        
        [[BaiduMobStat defaultStat] pageviewStartWithName:[NSString stringWithFormat:@"%@",self.titeLabel.text]];
    }
    
}


- (void)sender
{

    if (self.titeLabel.text) {
        
        [[BaiduMobStat defaultStat] pageviewEndWithName:[NSString stringWithFormat:@"%@",self.titeLabel.text]];
    }
}
-(void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
