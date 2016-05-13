//
//  ZKWellcomeJTListViewController.m
//  CYmiangzhu
//
//  Created by 王小腊 on 16/5/13.
//  Copyright © 2016年 WangXiaoLa. All rights reserved.
//

#import "ZKWellcomeJTListViewController.h"
#import "ZKWellcomeJTMode.h"
@interface ZKWellcomeJTListViewController ()

@property (nonatomic, strong) ZKWellcomeJTMode *list;
@end

@implementation ZKWellcomeJTListViewController

- (instancetype)initData:(ZKWellcomeJTMode*)data;
{

    self = [super init];
    if (self) {
        
        self.list = data;
        
    }
    
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"康养基地详情";
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
