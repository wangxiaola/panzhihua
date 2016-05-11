//
//  ZKStrategyModel.h
//  CYmiangzhu
//
//  Created by 汤亮 on 15/12/16.
//  Copyright © 2015年 WangXiaoLa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZKStrategyModel : NSObject
//{"id":100282077,"images":"sc_pzh2/upload/file/201512/15171957dbsi.jpg","addtime":1450171198689,"title":"攀枝花一日游","memberid":"159","photo":"","views":21,"name":""}
@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *images;
@property (nonatomic, copy) NSString *addtime;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *memberid;
@property (nonatomic, copy) NSString *photo;
@property (nonatomic, copy) NSString *views;
@property (nonatomic, copy) NSString *name;


@end
