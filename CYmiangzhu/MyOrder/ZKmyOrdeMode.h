//
//  ZKmyOrdeMode.h
//  CYmiangzhu
//
//  Created by 王小腊 on 15/12/11.
//  Copyright © 2015年 WangXiaoLa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZKmyOrdeMode : NSObject


@property (nonatomic, copy) NSString *buyDate;//购买时间
@property (nonatomic, copy) NSString *payDate;//付款时间
@property (nonatomic, copy) NSString *csize;//
@property (nonatomic, copy) NSString *dname;//订单创建员
@property (nonatomic, copy) NSString *endtime;// 结束时间
@property (nonatomic, copy) NSString *holettuitime;//酒店退房时间
@property (nonatomic, copy) NSString *hotelstarttime;//hotelstarttime
@property (nonatomic, copy) NSString *ID;//订单唯一ID
@property (nonatomic, copy) NSString *outid;//外部ID
@property (nonatomic, copy) NSDictionary *img;// 图片url
@property (nonatomic, copy) NSString *isComment;//
@property (nonatomic, copy) NSString *memo;//购买备注
@property (nonatomic, copy) NSString *name;//
@property (nonatomic, copy) NSString *oid;//
@property (nonatomic, copy) NSString *orderCode;//订单唯一编号
@property (nonatomic, copy) NSString *payState;//付款状态（0 未支付 1支付）
@property (nonatomic, copy) NSString *pid;//
@property (nonatomic, copy) NSString *price;//
@property (nonatomic, copy) NSString *rsize;//
@property (nonatomic, copy) NSString *size;// 个数
@property (nonatomic, copy) NSString *starttime;//
@property (nonatomic, copy) NSString *refundSize;
@property (nonatomic, copy) NSString *total;//购买总价
@property (nonatomic, copy) NSString *truename;//购买者姓名
@property (nonatomic, copy) NSString *type;//
@property (nonatomic, copy) NSString *validConsumeSize;


@end
