//
//  ZKmyOrderViewController.h
//  CYmiangzhu
//
//  Created by 王小腊 on 15/12/11.
//  Copyright © 2015年 WangXiaoLa. All rights reserved.
//

#import "ZKSuperViewController.h"
/**
 *  我的订单
 */
@interface ZKmyOrderViewController : ZKSuperViewController
/**
 *  跳转到那个状态view
 *
 *  @param index 0(未付款)  1(未消费)  2(已完成)  3(退款单)
 */
@property(nonatomic,assign) NSInteger index;

@end
