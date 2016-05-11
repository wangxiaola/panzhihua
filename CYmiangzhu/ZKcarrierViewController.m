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
    //初始化全局appearance
    [self initAppearance];

    // Do any additional setup after loading the view.
}


-(void)initAppearance{
    
    [[UITabBarItem appearance] setTitleTextAttributes:@{ NSForegroundColorAttributeName : CYBColorGreen} forState:UIControlStateSelected];
    
    [[UINavigationBar appearance] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, nil]];
    //搜索取消字体颜色
    [[UIBarButtonItem appearanceWhenContainedIn:[UISearchBar class], nil] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor],NSForegroundColorAttributeName,[UIColor grayColor],NSShadowAttributeName,[NSValue valueWithUIOffset:UIOffsetMake(0, 0)],NSShadowAttributeName,nil] forState:UIControlStateNormal];
    [[UIBarButtonItem appearanceWhenContainedIn:[UISearchBar class], nil] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor],NSForegroundColorAttributeName,[UIColor grayColor],NSShadowAttributeName,[NSValue valueWithUIOffset:UIOffsetMake(0, 0)],NSShadowAttributeName,nil] forState:UIControlStateHighlighted];
    
    
}

-(void)goMainTab{
    [UIApplication sharedApplication].statusBarHidden = NO;
    //init tab
    
    self.tabBarController = [[UITabBarController alloc] init];
    self.tabBarController.delegate = self;
    self.tabBarController.tabBar.contentMode = UIViewContentModeScaleAspectFill;
    NSMutableArray *controllers = [NSMutableArray array];
    
  ZKNewHomViewController *homeViewController=[[ZKNewHomViewController alloc]init];
    homeViewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"主页" image:[[UIImage imageNamed:@"f01"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:@"f_01"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    homeViewController.tabBarItem.titlePositionAdjustment =UIOffsetMake(0, -0.8);
    ZKNavigationController*homeNav=[[ZKNavigationController alloc]initWithRootViewController:homeViewController];
    [controllers addObject:homeNav];
    
    ZKsecrtMapViewController *near=[[ZKsecrtMapViewController alloc]init];
    UINavigationController*recommendNav=[[UINavigationController alloc]initWithRootViewController:near];
    near.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"地图" image:[[UIImage imageNamed:@"f02"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:@"f_02"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    near.tabBarItem.titlePositionAdjustment =UIOffsetMake(0, -0.8);
    [recommendNav setNavigationBarHidden:YES animated:NO];
    [controllers addObject:recommendNav];
    
   ZKsrdzViewController *class=[[ZKsrdzViewController alloc]init];
    
    class.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"私人定制" image:[[UIImage imageNamed:@"f03"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:@"f_03"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    UINavigationController*journeyNav=[[UINavigationController alloc]initWithRootViewController:class];
    
   class.tabBarItem.titlePositionAdjustment =UIOffsetMake(0, -0.8);
    [journeyNav setNavigationBarHidden:YES animated:NO];
    [controllers addObject:journeyNav];

 
    ZKCallPoliceViewController *callVc=[[ZKCallPoliceViewController alloc]init];
    
    callVc.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"一键报警" image:[[UIImage imageNamed:@"f03"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:@"f_03"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    ZKNavigationController*callNav=[[ZKNavigationController alloc]initWithRootViewController:callVc];
    
    callVc.tabBarItem.titlePositionAdjustment =UIOffsetMake(0, -0.8);
    [controllers addObject:callNav];
    
    
   ZKmyListViewController *mylist =[[ZKmyListViewController alloc]init];
    
    mylist.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"我的" image:[[UIImage imageNamed:@"f04"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:@"f_04"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    UINavigationController*nearbyNav=[[UINavigationController alloc]initWithRootViewController:mylist];
    
    mylist.tabBarItem.titlePositionAdjustment =UIOffsetMake(0, -0.8);
    [nearbyNav setNavigationBarHidden:YES animated:NO];
    [controllers addObject:nearbyNav];
    

    self.tabBarController.viewControllers = controllers;
    self.tabBarController.customizableViewControllers = controllers;
    self.tabBarController.tabBar.selectionIndicatorImage = [[UIImage alloc] init];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self.navigationController pushViewController: self.tabBarController animated:NO];
    self.tabBarController.hidesBottomBarWhenPushed =YES;


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
