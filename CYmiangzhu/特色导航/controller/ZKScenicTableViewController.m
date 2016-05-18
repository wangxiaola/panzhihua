//
//  ZKScenicTableViewController.m
//  CYmiangzhu
//
//  Created by 王小腊 on 16/5/18.
//  Copyright © 2016年 WangXiaoLa. All rights reserved.
//

#import "ZKScenicTableViewController.h"
#import "ZKSelectListView.h"
#import "UIBarButtonItem+Custom.h"

@interface ZKScenicTableViewController ()

@property (nonatomic, strong) NSString *typer;
@property (nonatomic, strong) ZKSelectListView *selecView;
@end

@implementation ZKScenicTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithIcon:@"feature_Map" highIcon:nil target:self action:@selector(mapClick)];
    [self uploadView];
}
- (void)uploadView;
{
    switch (self.scenicType) {
            
        case ZKScenicFood:
            self.typer = @"";
            [self titleView:@"特色食物"];
            break;
        case ZKScenicHotel:
            self.typer = @"";
            [self titleView:@"酒店住宿"];
            break;
        case ZKScenicTicket:
            self.typer = @"";
            [self titleView:@"景区门票"];
            break;
        case ZKScenicShop:
            self.typer = @"";
            [self titleView:@"特色购物"];
            break;
        case ZKScenicRecreation:
            self.typer = @"";
            [self titleView:@"休闲娱乐"];
            break;
        default:
            break;
    }

}
// 头部文字
- (void)titleView:(NSString*)title;
{
    UIButton *titleButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 50)];
    
    [titleButton setImage:[UIImage imageNamed:@"feature_x_H"] forState:UIControlStateNormal];
    [titleButton setImage:[UIImage imageNamed:@"feature_x_D"] forState:UIControlStateHighlighted];
    titleButton.titleLabel.font = [UIFont systemFontOfSize:18];
    [titleButton setImageEdgeInsets:UIEdgeInsetsMake(0,90, 0, 0)];
    [titleButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 5)];
    [titleButton setTitle:title forState:UIControlStateNormal];
    [titleButton setTitleColor:CYBColorGreen forState:UIControlStateNormal];
    [titleButton addTarget:self action:@selector(titleClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.titleView = titleButton;
    
    NSArray *array;
    //请求门票标签
    if (self.scenicType == ZKScenicTicket)
    {
        
        array = [self addHeaerLabel];
    }

    ZKSelectListView *headerView = [[ZKSelectListView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 10+26+30) mpArray:array];
    self.tableView.tableHeaderView = headerView;
    
}

/**
 *  加载门票标签
 *
 *  @return 数组
 */
- (NSArray*)addHeaerLabel;
{

    return @[@"不限",@"消暑",@"深刻",@"让我感觉",@"主题公园",@"吃饭的地方"];
}
#pragma mark 点击事件
- (void)titleClick
{

}
- (void)mapClick
{


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
