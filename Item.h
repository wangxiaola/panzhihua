//
//  Item.h
//  CustomMKAnnotationView
//
//  Created by JianYe on 14-2-8.
//  Copyright (c) 2014年 Jian-Ye. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Item : NSObject

@property (nonatomic,copy)NSNumber *latitude;
@property (nonatomic,copy)NSNumber *longitude;
@property (nonatomic,copy)NSString *title;
@property (nonatomic,copy)NSString *subtitle;
@property (nonatomic,copy)NSString *imageUrl;
@property (nonatomic,copy)NSString *phone;
@property (nonatomic,copy)NSString *name;

//@property (nonatomic,assign)NSInteger index;

@property (nonatomic,copy)NSString *tp;
/**
 *  是什么数据 1是加载数据 2是搜素数据 3是我的位置
 */
@property (nonatomic,assign)NSInteger  poop;


- (id)initWithDictionary:(NSDictionary *)dictionary anntp:(NSString*)t;

-(id)initWithDictionary:(NSDictionary *)dictionary;

@end