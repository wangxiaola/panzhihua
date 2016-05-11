//
//  ViewControllerOneCell.h
//  trasitionpractice
//
//  Created by YouLoft_MacMini on 15/11/23.
//  Copyright © 2015年 YouLoft_MacMini. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZKTripMode;
@class ZK720ScenicMode;

@interface XWMagicMoveCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (nonatomic, strong) ZKTripMode *listModel;
@property (nonatomic,strong) ZK720ScenicMode *listmode;

@end
