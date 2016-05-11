//
//  ZKRecreationViewController.m
//  CYmiangzhu
//
//  Created by 汤亮 on 15/12/10.
//  Copyright © 2015年 WangXiaoLa. All rights reserved.
//

#import "ZKRecreationViewController.h"
#import "ZKscenicSpotList.h"
#import "ZKAddressCell.h"
#import "ZKentertainmentViewController.h"
@interface ZKRecreationViewController ()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation ZKRecreationViewController


- (void)viewDidLoad {
    [super viewDidLoad];
      self.searchName = @"商家名/地名";
    NSArray *dataArray = @[
                           @{@"name":@"娱乐类型",@"code":@""},
                           @{@"name":@"不限",@"code":@""},
                           @{@"name":@"茶馆/茶楼",@"code":@"entertainmentType3"},
                           @{@"name":@"电影院",@"code":@"entertainmentType6"},
                           @{@"name":@"固定演出场所",@"code":@"entertainmentType18"},
                           @{@"name":@"酒吧/KTV",@"code":@"entertainmentType12"},
                           @{@"name":@"俱乐部/会所/夜总会",@"code":@"entertainmentType15"},
                           @{@"name":@"康乐类娱乐场所",@"code":@"entertainmentType1"},
                           @{@"name":@"休闲场所",@"code":@"entertainmentType24"},
                           @{@"name":@"游乐园(场)",@"code":@"entertainmentType19"},
                           @{@"name":@"其他",@"code":@"entertainmentType9"},
                           ];
    self.chooseData =@[dataArray];
    
    [self addTJXZ];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.Identifier = @"ZKRecreationViewController";
    self.typecode = @"recreation";
    [self.tableView registerNib:[UINib nibWithNibName:@"ZKAddressCell" bundle:nil] forCellReuseIdentifier:ZKAddressCellID];
    [self LoadTheCached];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.listData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZKAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:ZKAddressCellID];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.listModel = self.listData[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 88;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZKscenicSpotList *model = self.listData[indexPath.row];
    
    ZKentertainmentViewController *vc =[[ZKentertainmentViewController alloc]init];
    [vc updata:model.ID type:self.typecode  name:model.name];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)jumpToWebUrl:(NSString *)webUrl
{
    ZKBasicViewController *web = [[ZKBasicViewController alloc] init];
    web.webToUrl = [webUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    web.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:web animated:YES];
}

@end
