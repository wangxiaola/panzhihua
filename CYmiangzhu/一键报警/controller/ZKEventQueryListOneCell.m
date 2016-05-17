//
//  ZKEventQueryListOneCell.m
//  CYmiangzhu
//
//  Created by 王小腊 on 16/5/17.
//  Copyright © 2016年 WangXiaoLa. All rights reserved.
//

NSString *const ZKEventQueryListOneCellID = @"ZKEventQueryListOneCellID";
#import "ZKEventQueryListOneCell.h"
#import "ZKEventQueryDetailsMode.h"

@implementation ZKEventQueryListOneCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)setList:(ZKEventQueryDetailsMode *)list
{

}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
