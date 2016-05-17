//
//  ZKEventQueryListThreeCell.m
//  CYmiangzhu
//
//  Created by 王小腊 on 16/5/17.
//  Copyright © 2016年 WangXiaoLa. All rights reserved.
//

NSString *const ZKEventQueryListThreeCellID = @"ZKEventQueryListThreeCellID";

#import "ZKEventQueryListThreeCell.h"
#import "ZKEventQueryDetailsMode.h"

@implementation ZKEventQueryListThreeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)updata:(ZKEventQueryDetailsMode*)list select:(NSInteger)index;
{

    if (index == 0)
    {
        
        self.lefImageView.image = [UIImage imageNamed:@"NewData_selec"];
        self.dateLabel.textColor = [UIColor orangeColor];
        self.stateLabel.textColor = [UIColor orangeColor];
        self.linView.layer.opacity = 0;
    }
    else
    {
        self.lefImageView.image = [UIImage imageNamed:@"NewData_nom"];
        self.dateLabel.textColor = [UIColor grayColor];
        self.stateLabel.textColor = [UIColor grayColor];
          self.linView.layer.opacity = 1;
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
