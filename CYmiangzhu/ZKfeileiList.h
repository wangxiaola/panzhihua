//
//  ZKfeileiList.h
//  CYmiangzhu
//
//  Created by Daqsoft-Mac on 15/8/13.
//  Copyright (c) 2015年 WangXiaoLa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZKfeileiList : NSObject

@property(nonatomic,strong)NSString *name;

@property(nonatomic,strong)NSString *infor;

@property(nonatomic,assign)NSInteger index;

-(id)initNSdict:(NSDictionary*)list;

@end
