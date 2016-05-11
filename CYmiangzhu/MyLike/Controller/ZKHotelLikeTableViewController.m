//
//  ZKHotelLikeViewController.m
//  CYmiangzhu
//
//  Created by 汤亮 on 15/12/11.
//  Copyright © 2015年 WangXiaoLa. All rights reserved.
//

#import "ZKHotelLikeTableViewController.h"

@interface ZKHotelLikeTableViewController ()

@end

@implementation ZKHotelLikeTableViewController

- (void)supplementToParams:(NSMutableDictionary *)params cacheFilename:(NSString **)cacheFilename
{
    params[@"type"] = @"hotel";
    *cacheFilename = @"ZKHotelLikeTableViewController.data";
}

@end
