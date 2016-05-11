//
//  ZKrecommenMode.h
//  CYmiangzhu
//
//  Created by Daqsoft-Mac on 15/8/12.
//  Copyright (c) 2015年 WangXiaoLa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZKrecommenMode : NSObject

@property(nonatomic,strong)NSString *url;

@property(nonatomic,strong)NSString *name;

@property(nonatomic,strong)NSString *logosmall;

@property(nonatomic, copy)NSString *ID;


-(id)init:(NSDictionary*)list;


@end
