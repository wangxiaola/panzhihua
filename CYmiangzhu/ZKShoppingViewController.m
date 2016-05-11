//
//  ZKShoppingViewController.m
//  CYmiangzhu
//
//  Created by 汤亮 on 15/12/10.
//  Copyright © 2015年 WangXiaoLa. All rights reserved.
//

#import "ZKShoppingViewController.h"
#import "ZKscenicSpotList.h"
#import "ZKAddressCell.h"
#import "ZKCharacteristicsViewController.h"
@interface ZKShoppingViewController ()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation ZKShoppingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.searchName = @"商家名/特产名";
    NSArray *dataArray = @[
                           @{@"name":@"购物类型",@"code":@""},
                           @{@"name":@"不限",@"code":@""},
                           @{@"name":@"百货公司",@"code":@"shoppingType7"},
                           @{@"name":@"超级市场",@"code":@"shoppingType2"},
                           @{@"name":@"购物商场",@"code":@"shoppingType25"},
                           @{@"name":@"购物休闲广场",@"code":@"shoppingType6"},
                           @{@"name":@"旅游纪念品商店",@"code":@"shoppingType12"},
                           @{@"name":@"旅游商品商店",@"code":@"shoppingType26"},
                           @{@"name":@"四川特产商店",@"code":@"shoppingType27"},
                           @{@"name":@"特色商品商店",@"code":@"shoppingType10"},
                           @{@"name":@"土特产、药材商店",@"code":@"shoppingType3"},
                           @{@"name":@"综合性购物商场",@"code":@"shoppingType8"},
                           @{@"name":@"其他",@"code":@"shoppingType4"},
                           ];
    self.chooseData =@[dataArray];
    
    [self addTJXZ];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.Identifier = @"ZKShoppingViewController";
    self.typecode = @"shopping";
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
    
    ZKCharacteristicsViewController *vc =[[ZKCharacteristicsViewController alloc]init];
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
