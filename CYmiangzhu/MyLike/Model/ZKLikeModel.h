//
//  ZKLikeModel.h
//  CYmiangzhu
//
//  Created by 汤亮 on 15/12/11.
//  Copyright © 2015年 WangXiaoLa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZKLikeModel : NSObject

@property (nonatomic, copy) NSString *address;//地址
@property (nonatomic, assign) CGFloat exponent;//指数
@property (nonatomic, copy) NSString *ID;//景区id
@property (nonatomic, copy) NSString *info;//内容
@property (nonatomic, copy) NSString *addtime;//添加时间
@property (nonatomic, copy) NSString *type;//资源类型
@property (nonatomic, copy) NSString *dataname;//资源名称
@property (nonatomic, copy) NSString *dataid;//资源id
@property (nonatomic, copy) NSString *logosmall;//图片url
@property (nonatomic, copy) NSString *name;//用户姓名
@property (nonatomic, copy) NSString *price;
@property (nonatomic, copy) NSString *phone;
@property (nonatomic, copy) NSString *praise;


@property (nonatomic, assign) double x;
@property (nonatomic, assign) double y;

@property (nonatomic, copy) NSString *distance;
@end
