//
//  ZKscenicSpotList.h
//  CYmiangzhu
//
//  Created by 小腊 on 15/12/10.
//  Copyright © 2015年 WangXiaoLa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZKscenicSpotList : NSObject


@property (nonatomic, copy) NSString *address;//地址
@property (nonatomic, assign) CGFloat exponent;//指数
@property (nonatomic, copy) NSString *ID;//景区id
@property (nonatomic, copy) NSString *info;//内容
@property (nonatomic, copy) NSString *logosmall;//图片url
@property (nonatomic, copy) NSString *name;//景区名
@property (nonatomic, copy) NSString *phone;//电话
@property (nonatomic, copy) NSString *praise;//赞扬
@property (nonatomic, copy) NSString *price;//价格
@property (nonatomic, copy) NSString *resourcelevel;//景区等级
@property (nonatomic, copy) NSString *resourcelevelName;//
@property (nonatomic, copy) NSString *tags;//标签
@property (nonatomic, copy) NSString *views;//查看
@property (nonatomic, assign) double x;
@property (nonatomic, assign) double y;

@property (nonatomic, copy) NSString *distance;
@end
