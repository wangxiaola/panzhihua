//
//  ZKLiveInPZHViewController.m
//  CYmiangzhu
//
//  Created by 汤亮 on 15/12/25.
//  Copyright © 2015年 WangXiaoLa. All rights reserved.
//  康养在攀枝花

#import "ZKLiveInPZHViewController.h"
#import "ZKLiveInPZHHtmlViewController.h"
#import "ZKcarrierViewController.h"

@interface ZKLiveInPZHViewController ()
@property (nonatomic, strong) NSTimer *timer;
@end

@implementation ZKLiveInPZHViewController

- (NSTimer *)timer
{
    if (_timer == nil) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(fireTime) userInfo:nil repeats:YES];
    }
    return _timer;
}

- (void)fireTime
{
    ZKcarrierViewController *hom =[[ZKcarrierViewController alloc]init];
    UINavigationController *nav =[[UINavigationController alloc]initWithRootViewController:hom];
    nav.navigationBarHidden =YES;
    [[UIApplication sharedApplication].delegate window].rootViewController = nav;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationBarView.hidden = YES;
    
    UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    bgImageView.image = [UIImage imageNamed:@"kangyang_bg.jpg"];
    [self.view addSubview:bgImageView];
    
    UIButton *jumpButton = [UIButton buttonWithType:UIButtonTypeCustom];
    jumpButton.bounds = CGRectMake(0, 0, 135, 30);
    jumpButton.center = CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height - 50);
    jumpButton.layer.cornerRadius = 15;
    jumpButton.layer.masksToBounds = YES;
    jumpButton.clipsToBounds = YES;
    [jumpButton setBackgroundColor:[UIColor orangeColor]];
    jumpButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    jumpButton.titleLabel.font = [UIFont systemFontOfSize:13];
    [jumpButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [jumpButton setTitle:@"开启康养之旅" forState:UIControlStateNormal];
    [jumpButton addTarget:self action:@selector(jumpToKangyang) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:jumpButton];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.timer invalidate];
    self.timer = nil;
}

- (void)jumpToKangyang
{
    //desc_health.aspx?z_pagetitle=康养在攀枝花
    ZKLiveInPZHHtmlViewController *kangyangHtmlVC = [[ZKLiveInPZHHtmlViewController alloc] init];
    kangyangHtmlVC.banSwipeToReturn = YES;
    [self.navigationController pushViewController:kangyangHtmlVC animated:YES];
}

@end
