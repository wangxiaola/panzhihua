//
//  ZKNewHomeHeaderView.h
//  CYmiangzhu
//
//  Created by 王小腊 on 16/5/11.
//  Copyright © 2016年 WangXiaoLa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDCycleScrollView.h"

@interface ZKNewHomeHeaderView : UIView<SDCycleScrollViewDelegate>

@property (nonatomic, weak) id controller;

@property (nonatomic, strong) SDCycleScrollView *cycleScrollView;

@property (nonatomic, strong) NSMutableArray *imageArray;

@end
