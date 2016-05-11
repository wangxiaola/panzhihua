//
//  ZKDetailNearView.m
//  CYmiangzhu
//
//  Created by 汤亮 on 16/1/7.
//  Copyright © 2016年 WangXiaoLa. All rights reserved.
//

#import "ZKDetailNearView.h"
@interface ZKDetailNearView()

@end

@implementation ZKDetailNearView

+ (instancetype)detailNearView
{
    ZKDetailNearView *detailNearView = [[[NSBundle mainBundle] loadNibNamed:@"ZKDetailNearView" owner:nil options:nil] firstObject];
    return detailNearView;
}

- (IBAction)nearRecommend {
    if (self.nearRecommendBlock) {
        self.nearRecommendBlock();
    }
}

@end
