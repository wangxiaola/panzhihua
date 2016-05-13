//
//  ZKWellcomeZNTableViewCell.h
//  CYmiangzhu
//
//  Created by 王小腊 on 16/5/13.
//  Copyright © 2016年 WangXiaoLa. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *const  ZKWellcomeZNTableViewCellID;
@class ZKWellcomeZNMode;

@interface ZKWellcomeZNTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *photoImage;

@property (nonatomic, strong) ZKWellcomeZNMode *dataList;
@property (weak, nonatomic) IBOutlet UILabel *inforLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end
