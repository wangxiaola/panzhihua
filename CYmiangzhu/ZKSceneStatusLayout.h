//
//  ZKSceneStatusLayout.h
//  CYmiangzhu
//
//  Created by 汤亮 on 15/9/1.
//  Copyright (c) 2015年 WangXiaoLa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZKSceneStatusLayout : UICollectionViewFlowLayout

// 两个cell之间的行间距，cell与边界的间距
@property (nonatomic, assign) CGFloat maxItemRowSpace;

// 列数
@property (nonatomic, assign) int colums;
@end
