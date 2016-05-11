//
//  WaterF.h
//  CollectionView
//
//  Created by d2space on 14-2-21.
//  Copyright (c) 2014年 D2space. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WaterFLayout.h"


@interface WaterF : UICollectionViewController 

@property (nonatomic,strong) NSMutableArray* imagesArr;
@property (nonatomic,strong) NSMutableArray* textsArr;
@property (nonatomic,assign) NSInteger sectionNum;
@property (nonatomic) NSInteger imagewidth;
@property (nonatomic) CGFloat textViewHeight;

@end
