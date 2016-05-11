//
//  ZKCityGroup.m
//  CYmiangzhu
//
//  Created by Daqsoft-Mac on 15/10/10.
//  Copyright © 2015年 WangXiaoLa. All rights reserved.
//

#import "ZKCityGroup.h"
#import "ZKCity.h"
@implementation ZKCityGroup

+ (NSDictionary *)objectClassInArray
{
    return @{@"cities" : [ZKCity class]};
}

@end
