//
//  ZKNewBaseViewController.m
//  CYTemplate
//
//  Created by 王小腊 on 16/5/11.
//  Copyright © 2016年 王小腊. All rights reserved.
//

#import "ZKNewBaseViewController.h"

@interface ZKNewBaseViewController ()

@end

@implementation ZKNewBaseViewController

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (self.title) {
        
        [[BaiduMobStat defaultStat] pageviewStartWithName:[NSString stringWithFormat:@"%@",self.title]];
    }
    
}

-(void)viewDidDisappear:(BOOL)animated
{
    
    [super viewDidDisappear:animated];
    
    
    if (self.title) {
        
        [[BaiduMobStat defaultStat] pageviewEndWithName:[NSString stringWithFormat:@"%@",self.title]];
    }
    
    
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view setBackgroundColor:YJCorl(249,249, 249)];
//    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithIcon:@"nav_scan" highIcon:@"nav_scan_high" target:self action:@selector(gosweep)];
//    
//    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithIcon:@"nav_calendar" highIcon:@"nav_calendar_high" target:self action:@selector(gofill)];
//    
//    self.navigationItem.titleView = self.searchBar;

    
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
