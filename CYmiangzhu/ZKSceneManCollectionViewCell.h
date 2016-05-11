//
//  ZKSceneManCollectionViewCell.h
//  CYmiangzhu
//
//  Created by 王小腊 on 16/2/23.
//  Copyright © 2016年 WangXiaoLa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZKSceneStatus.h"
#import "CYmiangzhu-Swift.h"

@interface ZKSceneManCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet RatingBar *ratingBar;
@property (weak, nonatomic) IBOutlet UILabel *sceneNameLabel;

@property (nonatomic, strong) ZKSceneStatus *status;
@end
