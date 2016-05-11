//
//  ZKViewController.m
//  CYmiangzhu
//
//  Created by 王小腊 on 15/12/9.
//  Copyright © 2015年 WangXiaoLa. All rights reserved.
//

#import "ZKFoodViewController.h"
#import "ZKFoodTableViewCell.h"
#import "ZKscenicSpotList.h"
#import "ZKGoodsDetailsViewController.h"
@interface ZKFoodViewController ()<UITableViewDataSource,UITableViewDelegate>



@end

@implementation ZKFoodViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.searchName = @"商家名/地名";
    NSArray *oneArray = @[
                          @{@"name":@"餐饮类型",@"code":@"11"},
                          @{@"name":@"不限",@"code":@""},
                          @{@"name":@"川菜",@"code":@"diningtype_12"},
                          @{@"name":@"藏式菜",@"code":@"diningtype_03"},
                          @{@"name":@"火锅",@"code":@"diningtype_07"},
                          @{@"name":@"面馆",@"code":@"diningtype_08"},
                          @{@"name":@"名族风味",@"code":@"diningtype_10"},
                          @{@"name":@"清真菜餐馆",@"code":@"diningtype_04"},
                          @{@"name":@"外国菜餐馆",@"code":@"diningtype_05"},
                          @{@"name":@"小吃",@"code":@"diningtype_09"},
                          @{@"name":@"中国菜餐馆",@"code":@"diningtype_02"},];
    
    NSArray *twoArray =@[
                         @{@"name":@"菜系类型",@"code":@"11"},
                         @{@"name":@"不限",@"code":@""},
                         @{@"name":@"四川菜",@"code":@"providefood_1"},
                         @{@"name":@"安徽菜",@"code":@"providefood_7"},
                         @{@"name":@"北京菜",@"code":@"providefood_2"},
                         @{@"name":@"福建菜",@"code":@"providefood_8"},
                         @{@"name":@"广东菜",@"code":@"providefood_3"},
                         @{@"name":@"湖南菜",@"code":@"providefood_4"},
                         @{@"name":@"江苏菜",@"code":@"providefood_5"},
                         @{@"name":@"山东菜",@"code":@"providefood_6"},
                         @{@"name":@"上海菜",@"code":@"providefood_9"},
                         @{@"name":@"其他",@"code":@"providefood_12"},];
    
    self.chooseData = @[oneArray,twoArray];
    
    [self addTJXZ];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.Identifier = @"ZKFoodViewController";
    self.typecode = @"dining";
    [self.tableView registerNib:[UINib nibWithNibName:@"ZKFoodTableViewCell" bundle:nil] forCellReuseIdentifier:ZKFoodTableViewCellID];
    [self LoadTheCached];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.listData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZKFoodTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ZKFoodTableViewCellID];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.cellType = ZKListCellTypeFood;
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
    
    //NSString *str = [NSString stringWithFormat:@"desc_resource.aspx?z_isheadback=true&id=%@&z_pagetitle=%@&type=%@",model.ID, model.name, self.typecode];
    //[self jumpToWebUrl:webUrl(str)];
    
    ZKGoodsDetailsViewController *vc =[[ZKGoodsDetailsViewController alloc]init];
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
