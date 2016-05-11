//
//  ZKProduction.h
//  CYmiangzhu
//
//  Created by 汤亮 on 15/9/29.
//  Copyright © 2015年 WangXiaoLa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZKProduction : NSObject
//TOTYPE=openhotelorder&pzh_name=攀枝花市二滩国家森林公园&pzh_price=160&pzh_usetime=&pzh_whichroom=100007918景区门票&pzh_productID=18&pzh_qixian=2015-10-01,2015-11-07
//商品名称
@property (nonatomic, copy)NSString *pzh_name;
//商品单价
@property (nonatomic, copy)NSString *pzh_price;
//使用时间
@property (nonatomic, copy)NSString *pzh_usetime;
//房间类型（酒店）
@property (nonatomic, copy)NSString *pzh_whichroom;
//商品id
@property (nonatomic, copy)NSString *pzh_productID;
//商品期限
@property (nonatomic, copy)NSString *pzh_qixian;
@end
