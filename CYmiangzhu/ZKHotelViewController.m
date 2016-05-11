//
//  ZKHotelViewController.m
//  CYmiangzhu
//
//  Created by 汤亮 on 15/12/10.
//  Copyright © 2015年 WangXiaoLa. All rights reserved.
//

#import "ZKHotelViewController.h"
#import "ZKFoodTableViewCell.h"
#import "ZKscenicSpotList.h"
#import "ZKHotelDetailViewController.h"
@interface ZKHotelViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation ZKHotelViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.、、
    
   self.searchName = @"景区地名/酒店";
    
    NSArray *dataArray = @[
                           @{@"name":@"酒店类型",@"code":@""},
                           @{@"name":@"不限",@"code":@""},
                           @{@"name":@"三星级",@"code":@"hotelStarLevel_3"},
                           @{@"name":@"四星级",@"code":@"hotelStarLevel_4"},
                           @{@"name":@"五星级",@"code":@"hotelStarLevel_5"},
                           @{@"name":@"经济型",@"code":@"hotelType_3"},
                           @{@"name":@"公寓型",@"code":@"hotelType_6"},
                           @{@"name":@"主题酒店",@"code":@"hotelStarLevel_6"},
                           ];
    self.chooseData =@[dataArray];
    
    [self addTJXZ];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.Identifier = @"ZKHotelViewController";
    self.typecode = @"hotel";
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
    cell.cellType = ZKListCellTypeHotel;
    if (self.listData.count>0) {
     cell.listModel = self.listData[indexPath.row];
    }

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 88;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZKscenicSpotList *model = self.listData[indexPath.row];
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"SourceDetail" bundle:nil];
    ZKHotelDetailViewController *vc = [sb instantiateInitialViewController];
    vc.hotelModel = model;
    [self.navigationController pushViewController:vc animated:YES];
    
    //NSString *str = [NSString stringWithFormat:@"desc_hotel.aspx?z_isheadback=true&id=%@&z_pagetitle=%@&type=%@",model.ID, model.name, self.typecode];
    //[self jumpToWebUrl:webUrl(str)];
}


@end
