//
//  ZKSeasonCollectionViewCell.h
//  CYmiangzhu
//
//  Created by 王小腊 on 16/3/30.
//  Copyright © 2016年 WangXiaoLa. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZKSeasonMode;

@interface ZKSeasonCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *namelael;

@property (nonatomic, strong) ZKSeasonMode *listModel;

@end
