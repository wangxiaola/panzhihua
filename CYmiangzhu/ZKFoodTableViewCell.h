//
//  ZKFoodTableViewCell.h
//  CYmiangzhu
//
//  Created by 王小腊 on 15/12/10.
//  Copyright © 2015年 WangXiaoLa. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZKscenicSpotList, ZKLikeModel;

typedef enum {
    ZKListCellTypeHotel,
    ZKListCellTypeFood
} ZKListCellType;

extern NSString *const  ZKFoodTableViewCellID;

@interface ZKFoodTableViewCell : UITableViewCell

@property (nonatomic, strong) ZKscenicSpotList *listModel;
@property (nonatomic, strong) ZKLikeModel *likeModel;
@property (nonatomic, assign) ZKListCellType cellType;


@end
