//
//  ZKContainerLikeViewController.h
//  CYmiangzhu
//
//  Created by 汤亮 on 15/12/11.
//  Copyright © 2015年 WangXiaoLa. All rights reserved.
//

#import "ZKSuperViewController.h"

typedef enum {
   ZKLikeTypeCollection = 0,
   ZKLikeTypeShare
} ZKLikeType;

@interface ZKContainerLikeViewController : ZKSuperViewController

@property (nonatomic, assign) ZKLikeType likeType;

@end
