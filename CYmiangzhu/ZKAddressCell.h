//
//  ZKAddressCell.h
//  CYmiangzhu
//
//  Created by 汤亮 on 15/12/10.
//  Copyright © 2015年 WangXiaoLa. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZKscenicSpotList, ZKLikeModel;

extern NSString *const ZKAddressCellID;

@interface ZKAddressCell : UITableViewCell

@property (nonatomic, strong) ZKscenicSpotList *listModel;

@property (nonatomic, strong) ZKLikeModel *likeModel;
@end
