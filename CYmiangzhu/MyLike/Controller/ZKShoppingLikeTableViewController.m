//
//  ZKShoppingTableViewController.m
//  CYmiangzhu
//
//  Created by 汤亮 on 15/12/11.
//  Copyright © 2015年 WangXiaoLa. All rights reserved.
//

#import "ZKShoppingLikeTableViewController.h"

@interface ZKShoppingLikeTableViewController ()

@end

@implementation ZKShoppingLikeTableViewController

- (void)supplementToParams:(NSMutableDictionary *)params cacheFilename:(NSString **)cacheFilename
{
    params[@"type"] = @"shopping";
    *cacheFilename = @"ZKShoppingLikeTableViewController.data";
}

@end
