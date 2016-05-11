//
//  ZKADViewController.m
//  CYmiangzhu
//
//  Created by 汤亮 on 15/10/21.
//  Copyright © 2015年 WangXiaoLa. All rights reserved.
//

#import "ZKADViewController.h"
#import "ZKcarrierViewController.h"
#import "ZKAppDelegate.h"
#import "ZKADDetailViewController.h"
#import "ZKAdvertisement.h"

@interface ZKADViewController()
@property (nonatomic, strong) NSTimer *timer;
@property (weak, nonatomic) IBOutlet UIImageView *adImageView;

@property (nonatomic, strong)ZKAdvertisement *advertisement;
@property (nonatomic, assign) long second;
@end

@implementation ZKADViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //禁用滑动返回
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
    
    [self.navigationBarView removeFromSuperview];
    
    //取出本地保存的广告图片
//    self.adImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.adImageView.image = [ZKUtil fetchImage:@"advertisement"];
    
    //取出本地存储的活动数据模型
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"advertisement.data"]];
    self.advertisement = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
    
}

/**
 *  定时器懒加载
 *
 *  @return 返回定时器
 */
- (NSTimer *)timer
{
    if (_timer == nil) {
        
        _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(fireTime) userInfo:nil repeats:YES];
    }
    return _timer;
}

/**
 *  定时器每隔一秒调用此方法
 */
- (void)fireTime
{
    self.second++;
    
    if (self.second == 3) {
        [self enterToHome];
    }
    
}

/**
 *  进入广告详情
 */
- (IBAction)enterAD {
    
    [self.timer invalidate];
    self.timer = nil;
    
    ZKADDetailViewController *web = [[ZKADDetailViewController alloc] init];
    
    NSString *url = nil;
    if ([self.advertisement.name rangeOfString:@"?"].location != NSNotFound) {
        url = [self.advertisement.adAddress stringByAppendingString:[NSString stringWithFormat:@"&z_pagetitle=%@", self.advertisement.name]];
    }else{
        url = [self.advertisement.adAddress stringByAppendingString:[NSString stringWithFormat:@"?z_pagetitle=%@", self.advertisement.name]];
    }
    web.webToUrl = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [self.navigationController pushViewController:web animated:YES];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    self.second = 0;
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];

}

/**
 *  点击进入主页
 */
- (IBAction)enterHom {
    
    [self enterToHome];
}

/**
 *  进入主页
 */
- (void)enterToHome
{
    [self.timer invalidate];
    self.timer = nil;
    
    ZKcarrierViewController *hom =[[ZKcarrierViewController alloc]init];
    UINavigationController *nav =[[UINavigationController alloc]initWithRootViewController:hom];
    nav.navigationBarHidden =YES;
    [APPDELEGATE window].rootViewController =nav;

}




@end
