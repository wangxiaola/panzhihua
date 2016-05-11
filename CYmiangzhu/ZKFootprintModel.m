//
//  ZKFootprintModel.m
//  CYmiangzhu
//
//  Created by 汤亮 on 15/12/17.
//  Copyright © 2015年 WangXiaoLa. All rights reserved.
//

#import "ZKFootprintModel.h"

@implementation ZKFootprintModel

MJCodingImplementation
+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"ID": @"id"};
}

+ (NSArray *)ignoredCodingPropertyNames
{
    return @[@"editing"];
}
@end
