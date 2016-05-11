//
//  ZKRecreationLikeTableViewController.m
//  CYmiangzhu
//
//  Created by 汤亮 on 15/12/11.
//  Copyright © 2015年 WangXiaoLa. All rights reserved.
//

#import "ZKRecreationLikeTableViewController.h"

@interface ZKRecreationLikeTableViewController ()

@end

@implementation ZKRecreationLikeTableViewController

- (void)supplementToParams:(NSMutableDictionary *)params cacheFilename:(NSString **)cacheFilename
{
    params[@"type"] = @"recreation";
    *cacheFilename = @"ZKRecreationLikeTableViewController.data";
}

@end
