//
//  ZKWellcomeZNTableViewCell.m
//  CYmiangzhu
//
//  Created by 王小腊 on 16/5/13.
//  Copyright © 2016年 WangXiaoLa. All rights reserved.
//

NSString *const ZKWellcomeZNTableViewCellID = @"ZKWellcomeZNTableViewCellID";

#import "ZKWellcomeZNTableViewCell.h"
#import "ZKWellcomeZNMode.h"
@implementation ZKWellcomeZNTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.photoImage.layer.masksToBounds = YES;
    self.photoImage.layer.cornerRadius = 4;
}

- (void)setDataList:(ZKWellcomeZNMode *)dataList
{

}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
