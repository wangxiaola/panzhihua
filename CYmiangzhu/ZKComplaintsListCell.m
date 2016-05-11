//
//  ZKComplaintsListCell.m
//  CYmiangzhu
//
//  Created by 王小腊 on 15/12/18.
//  Copyright © 2015年 WangXiaoLa. All rights reserved.
//

#import "ZKComplaintsListCell.h"
#import "ZKComplaintsListMode.h"
NSString *const  ZKComplaintsListCellID =@"ZKComplaintsListCellID";
@interface ZKComplaintsListCell()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineHeight;

@end
@implementation ZKComplaintsListCell

- (void)awakeFromNib {
    self.lineHeight.constant = 0.5;
}
-(void)setListMode:(ZKComplaintsListMode *)listMode
{
    _listMode = listMode;
    self.name.text = [NSString stringWithFormat:@"%@ ( %@ ) ",listMode.dataname,listMode.complaintType];
    self.timer.text = listMode.addtime;
    self.infor.text = listMode.content;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
