//
//  ZKDetailNearView.h
//  CYmiangzhu
//
//  Created by 汤亮 on 16/1/7.
//  Copyright © 2016年 WangXiaoLa. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^NearRecommendBlock)();

@interface ZKDetailNearView : UIView
@property (nonatomic, copy) NearRecommendBlock nearRecommendBlock;
+ (instancetype)detailNearView;
@end
