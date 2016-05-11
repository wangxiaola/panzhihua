//
//  ZKTransitionViewController.m
//  CYmiangzhu
//
//  Created by 汤亮 on 15/10/21.
//  Copyright © 2015年 WangXiaoLa. All rights reserved.
//

#import "ZKTransitionViewController.h"
#import "ZKADViewController.h"
#import "ZKcarrierViewController.h"
#import "ZKAppDelegate.h"
#import "ZKAdvertisement.h"

@interface ZKTransitionViewController ()

@end

@implementation ZKTransitionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    //检测网络是否可用
    __weak typeof(self) weakSelf = self;
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        
     if (status == AFNetworkReachabilityStatusUnknown || status == AFNetworkReachabilityStatusNotReachable) {
         
           //无网直接跳转到主页面
           [weakSelf chooseRootViewControllerWithSuccess:NO];
         
        }else{
            
            [weakSelf chooseRootViewControllerWithSuccess:NO];
           //有网发送请求
//           [weakSelf post];
        }
    }];
    
}

- (void)post
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"method"] = @"base";
    
    [ZKHttp Post:@"" params:params success:^(id responseObj) {
        //json转模型
        ZKAdvertisement *adnew = [ZKAdvertisement objectWithKeyValues:responseObj];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
        NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"advertisement.data"]];
        
        //取出之前保存的模型
        ZKAdvertisement *adold = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
        //保存新模型
        [NSKeyedArchiver archiveRootObject:adnew toFile:filePath];
        
        //如果两个活动id不相等才去下载图片并保存，否则直接在下一个页面加载本地图片
        if (![adold.ID isEqualToString:adnew.ID]) {
            NSData *adImageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", imageUrlPrefix, adnew.indexImages]]];
            
            [ZKUtil setPhotoToPath:adImageData isName:@"advertisement"];
        }
        
        
        
        //请求成功选择页面
        [self chooseRootViewControllerWithSuccess:YES];
        
    } failure:^(NSError *error) {
        
        
        
        //请求失败选择页面
        [self chooseRootViewControllerWithSuccess:NO];
        
    }];

}

- (void)chooseRootViewControllerWithSuccess:(BOOL)success
{
    if (success) {
        
        ZKADViewController *adVC = [[ZKADViewController alloc] init];
        UINavigationController *nav =[[UINavigationController alloc]initWithRootViewController:adVC];
        nav.navigationBarHidden =YES;
        [APPDELEGATE window].rootViewController =nav;
        
    }else{
    
        ZKcarrierViewController *hom =[[ZKcarrierViewController alloc]init];
        UINavigationController *nav =[[UINavigationController alloc]initWithRootViewController:hom];
        nav.navigationBarHidden =YES;
        [APPDELEGATE window].rootViewController =nav;
    }


}



@end
