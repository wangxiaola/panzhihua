//
//  ZKOrder.h
//  CYmiangzhu
//
//  Created by 汤亮 on 15/9/29.
//  Copyright © 2015年 WangXiaoLa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZKOrder : NSObject
//商品名称
@property (nonatomic, copy)NSString *name;
//商品单价
@property (nonatomic, copy)NSString *price;
//订单总价
@property (nonatomic, copy)NSString *totalPrice;
//使用时间
@property (nonatomic, copy)NSString *usetime;
//商品id
@property (nonatomic, copy)NSString *productID;
//商品期限
@property (nonatomic, copy)NSString *qixian;
//房间类型（酒店）
@property (nonatomic, copy)NSString *whichroom;

//用户姓名
@property (nonatomic, copy)NSString *userName;
//用户身份证
@property (nonatomic, copy)NSString *userIDCard;
//用户电话
@property (nonatomic, copy)NSString *userPhone;

//入住时间（酒店）
@property (nonatomic, copy)NSString *enterLeave;
@property (nonatomic, copy)NSString *dayCount;
/**
 *  url  id
 */
@property (nonatomic, copy)NSString *payurl;
@property (nonatomic, strong)NSString *ordercode;

@end
