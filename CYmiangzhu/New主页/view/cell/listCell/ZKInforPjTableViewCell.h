//
//  ZKInforPjTableViewCell.h
//  CYmiangzhu
//
//  Created by 小腊 on 16/5/15.
//  Copyright © 2016年 WangXiaoLa. All rights reserved.
//

extern NSString *const ZKInforPjCellID;

#import <UIKit/UIKit.h>
#import "CYmiangzhu-Swift.h"

@interface ZKInforPjTableViewCell : UITableViewCell<UICollectionViewDataSource,UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *stateLabel;
@property (weak, nonatomic) IBOutlet UIImageView *pictureImageView;
@property (weak, nonatomic) IBOutlet UILabel *inforLabel;
@property (weak, nonatomic) IBOutlet RatingBar *ratingView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end
