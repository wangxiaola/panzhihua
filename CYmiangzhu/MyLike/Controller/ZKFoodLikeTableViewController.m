//
//  ZKFoodLikeTableViewController.m
//  CYmiangzhu
//
//  Created by 汤亮 on 15/12/11.
//  Copyright © 2015年 WangXiaoLa. All rights reserved.
//

#import "ZKFoodLikeTableViewController.h"

@interface ZKFoodLikeTableViewController ()

@end

@implementation ZKFoodLikeTableViewController

- (void)supplementToParams:(NSMutableDictionary *)params cacheFilename:(NSString **)cacheFilename
{
    params[@"type"] = @"dining";
    *cacheFilename = @"ZKFoodLikeTableViewController.data";
}


@end
