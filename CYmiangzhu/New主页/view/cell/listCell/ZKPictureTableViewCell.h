//
//  ZKPictureTableViewCell.h
//  CYmiangzhu
//
//  Created by 小腊 on 16/5/15.
//  Copyright © 2016年 WangXiaoLa. All rights reserved.
//
extern NSString *const ZKPictureCellID;

#import <UIKit/UIKit.h>
//图片基地cell
@interface ZKPictureTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *image_0;
@property (weak, nonatomic) IBOutlet UIImageView *image_1;
@property (weak, nonatomic) IBOutlet UIImageView *iamge_2;
@property (weak, nonatomic) IBOutlet UIImageView *image_3;
@property (weak, nonatomic) IBOutlet UILabel *label_0;
@property (weak, nonatomic) IBOutlet UILabel *label_1;
@property (weak, nonatomic) IBOutlet UILabel *label_2;
@property (weak, nonatomic) IBOutlet UILabel *label_3;

@end
