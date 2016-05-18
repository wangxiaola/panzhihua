//
//  ZKScenicTableViewController.h
//  CYmiangzhu
//
//  Created by 王小腊 on 16/5/18.
//  Copyright © 2016年 WangXiaoLa. All rights reserved.
//

/**
 *  景区类型
 */
typedef NS_ENUM(NSInteger,ZKScenicType) {
    /**
     *  食物
     */
    ZKScenicFood = 0,
    /**
     *  酒店
     */
    ZKScenicHotel,
    /**
     *  门票
     */
    ZKScenicTicket,
    /**
     *  购物
     */
    ZKScenicShop,
    /**
     *  娱乐
     */
    ZKScenicRecreation
};

#import "ZKNewBaseTableViewController.h"
/**
 *  景区
 */
@interface ZKScenicTableViewController : ZKNewBaseTableViewController

@property (nonatomic) ZKScenicType scenicType;

@end
