//
//  ZKSceneStatusCell.h
//  CYmiangzhu
//
//  Created by 汤亮 on 15/9/1.
//  Copyright (c) 2015年 WangXiaoLa. All rights reserved.
//

#import <UIKit/UIKit.h>

#define ZKSceneStatusBgMaxColor RGBCOLOR(253, 132, 66)
#define ZKSceneStatusBgNormalColor RGBCOLOR(51, 202, 172)

@class ZKSceneStatus;
@interface ZKSceneStatusCell : UICollectionViewCell


@property (nonatomic, strong) ZKSceneStatus *status;
@end
