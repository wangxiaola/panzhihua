//
//  ZKSceneryLikeViewController.m
//  CYmiangzhu
//
//  Created by 汤亮 on 15/12/11.
//  Copyright © 2015年 WangXiaoLa. All rights reserved.
//

#import "ZKSceneryLikeTableViewController.h"

@interface ZKSceneryLikeTableViewController ()

@end

@implementation ZKSceneryLikeTableViewController

- (void)supplementToParams:(NSMutableDictionary *)params cacheFilename:(NSString **)cacheFilename
{
    params[@"type"] = @"scenery";
    *cacheFilename = @"ZKSceneryLikeTableViewController.data";
}

@end
