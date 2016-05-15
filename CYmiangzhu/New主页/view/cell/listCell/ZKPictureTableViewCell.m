//
//  ZKPictureTableViewCell.m
//  CYmiangzhu
//
//  Created by 小腊 on 16/5/15.
//  Copyright © 2016年 WangXiaoLa. All rights reserved.
//

NSString *const ZKPictureCellID = @"ZKPictureCellID";
#import "ZKPictureTableViewCell.h"

@implementation ZKPictureTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self evLabel:self.label_0];
    [self evLabel:self.label_1];
    [self evLabel:self.label_2];
    [self evLabel:self.label_3];
    
}
- (void)evLabel:(UILabel*)label;
{
    label.layer.masksToBounds = YES;
    label.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    label.layer.cornerRadius = 10;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
