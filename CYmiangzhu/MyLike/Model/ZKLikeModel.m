//
//  ZKLikeModel.m
//  CYmiangzhu
//
//  Created by 汤亮 on 15/12/11.
//  Copyright © 2015年 WangXiaoLa. All rights reserved.
//

#import "ZKLikeModel.h"
#import <CoreLocation/CoreLocation.h>

@implementation ZKLikeModel

MJCodingImplementation
+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"ID": @"id"};
}

- (NSString *)distance
{
    NSString *currentX = [ZKUtil ToTakeTheKey:@"Longitude"];
    NSString *currentY = [ZKUtil ToTakeTheKey:@"Latitude"];
    if (currentX != nil && currentY != nil && self.x > 0 && self.y > 0) {
        double x1 = currentX.doubleValue;
        double y1 = currentY.doubleValue;
        double x2 = self.x;
        double y2 = self.y;
        
        CLLocation *loc1 = [[CLLocation alloc] initWithLatitude:y1 longitude:x1];
        CLLocation *loc2 = [[CLLocation alloc] initWithLatitude:y2 longitude:x2];
        
        double distance = [loc1 distanceFromLocation:loc2];
        
        return [NSString stringWithFormat:@"%.1f",distance / 1000];
    }else {
        
        return nil;
    }
}

+ (NSArray *)ignoredCodingPropertyNames
{
    return @[@"distance"];
}

@end
