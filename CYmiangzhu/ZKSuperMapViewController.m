//
//  ZKSuperMapViewController.m
//  sixianghu
//
//  Created by Daqsoft-Mac on 15/5/21.
//  Copyright (c) 2015年 WangXiaoLa. All rights reserved.
//

#import "ZKSuperMapViewController.h"

@interface ZKSuperMapViewController ()

@end

@implementation ZKSuperMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.titeLabel.text =@"超级地图";
    
    [self.leftBarButtonItem removeFromSuperview];

    NSLog(@"%f %f %@",_Latitude,_Longitude,_endAddr);
    
    // Do any additional setup after loading the view.
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
