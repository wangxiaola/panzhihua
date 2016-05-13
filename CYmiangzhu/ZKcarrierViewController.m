//
//  ZKHomViewController.m
//  CYmiangzhu
//
//  Created by Daqsoft-Mac on 15/8/11.
//  Copyright (c) 2015年 WangXiaoLa. All rights reserved.
//


//A better version of NSLog#define NSLog(format, ...) do { \

//A better version of NSLog



#import "ZKcarrierViewController.h"
#import "ZKNavigationController.h"

#import "ZKNewHomViewController.h"
#import "ZKsecrtMapViewController.h"
#import "ZKsrdzViewController.h"
#import "ZKCallPoliceViewController.h"
#import "ZKmyListViewController.h"


@interface ZKcarrierViewController ()

@end

@implementation ZKcarrierViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //构造主界面
    [self goMainTab];


    // Do any additional setup after loading the view.
}



-(void)goMainTab{
    [UIApplication sharedApplication].statusBarHidden = NO;
    //init tab
    
    self.tabBarController = [[UITabBarController alloc] init];
    self.tabBarController.delegate = self;
    self.tabBarController.tabBar.contentMode = UIViewContentModeScaleAspectFill;
    NSMutableArray *controllers = [NSMutableArray array];
    
    ZKNewHomViewController *homeViewController=[[ZKNewHomViewController alloc]init];
    homeViewController.tabBarItem.title = @"主页";
    homeViewController.tabBarItem.image = [[UIImage imageNamed:@"f01"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    homeViewController.tabBarItem.selectedImage = [[UIImage imageNamed:@"f_01"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    homeViewController.tabBarItem.titlePositionAdjustment =UIOffsetMake(0, -0.8);
 

    ZKNavigationController*homeNav=[[ZKNavigationController alloc]initWithRootViewController:homeViewController];
    [controllers addObject:homeNav];
    
    ZKsecrtMapViewController *near=[[ZKsecrtMapViewController alloc]init];
    
    near.tabBarItem.title = @"地图";
    near.tabBarItem.image = [[UIImage imageNamed:@"f02"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    near.tabBarItem.selectedImage = [[UIImage imageNamed:@"f_02"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    near.tabBarItem.titlePositionAdjustment =UIOffsetMake(0, -0.8);
    
    UINavigationController*recommendNav=[[UINavigationController alloc]initWithRootViewController:near];
    [recommendNav setNavigationBarHidden:YES animated:NO];
    [controllers addObject:recommendNav];
    
   ZKsrdzViewController *class=[[ZKsrdzViewController alloc]init];
    
    class.tabBarItem.title = @"私人定制";
    class.tabBarItem.image = [[UIImage imageNamed:@"f03"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    class.tabBarItem.selectedImage = [[UIImage imageNamed:@"f_05"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    class.tabBarItem.titlePositionAdjustment =UIOffsetMake(0, -0.8);

    UINavigationController*journeyNav=[[UINavigationController alloc]initWithRootViewController:class];
    
    [journeyNav setNavigationBarHidden:YES animated:NO];
    [controllers addObject:journeyNav];

 
    ZKCallPoliceViewController *callVc=[[ZKCallPoliceViewController alloc]init];
    
    callVc.tabBarItem.title = @"事件查询";
    callVc.tabBarItem.image = [[UIImage imageNamed:@"f06"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    callVc.tabBarItem.selectedImage = [[UIImage imageNamed:@"f_06"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    callVc.tabBarItem.titlePositionAdjustment =UIOffsetMake(0, -0.8);
    
    ZKNavigationController*callNav=[[ZKNavigationController alloc]initWithRootViewController:callVc];
    [controllers addObject:callNav];
    
    
   ZKmyListViewController *mylist =[[ZKmyListViewController alloc]init];
    
    mylist.tabBarItem.title = @"我的";
    mylist.tabBarItem.image = [[UIImage imageNamed:@"f04"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    mylist.tabBarItem.selectedImage = [[UIImage imageNamed:@"f_04"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    mylist.tabBarItem.titlePositionAdjustment =UIOffsetMake(0, -0.8);
    
    UINavigationController*nearbyNav=[[UINavigationController alloc]initWithRootViewController:mylist];
    [nearbyNav setNavigationBarHidden:YES animated:NO];
    [controllers addObject:nearbyNav];
    

    self.tabBarController.viewControllers = controllers;
    self.tabBarController.customizableViewControllers = controllers;
    self.tabBarController.tabBar.selectionIndicatorImage = [[UIImage alloc] init];
    
    self.tabBarController.hidesBottomBarWhenPushed =YES;
    [UIApplication sharedApplication].keyWindow.rootViewController = self.tabBarController;

}

-(void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{

    if (tabBarController.selectedIndex ==0) {
        
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
