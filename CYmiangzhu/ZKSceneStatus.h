//
//  ZKSceneStatus.h
//  CYmiangzhu
//
//  Created by 汤亮 on 15/9/1.
//  Copyright (c) 2015年 WangXiaoLa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZKSceneStatus : NSObject


//景区人数
@property (nonatomic, assign) int result;

//景区代码
@property (nonatomic, copy) NSString *resourcecode;

//景区名称
@property (nonatomic, copy) NSString *name;

//景区最大人数
@property (nonatomic, assign) int maxpeople;

@end
