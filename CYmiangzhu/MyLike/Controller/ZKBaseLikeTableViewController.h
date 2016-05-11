//
//  ZKBaseLikeTableViewController.h
//  CYmiangzhu
//
//  Created by 汤亮 on 15/12/11.
//  Copyright © 2015年 WangXiaoLa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZKContainerLikeViewController.h"
@class ZKLikeModel;

@interface ZKBaseLikeTableViewController : UITableViewController

@property (nonatomic, strong) NSMutableArray<ZKLikeModel *> *likeModels;

@property (nonatomic, assign) ZKLikeType likeType;

- (void)supplementToParams:(NSMutableDictionary *)params cacheFilename:(NSString **)cacheFilename;
@end
