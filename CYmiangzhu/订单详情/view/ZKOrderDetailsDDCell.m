//
//  ZKOrderDetailsDDCell.m
//  CYmiangzhu
//
//  Created by 王小腊 on 16/5/17.
//  Copyright © 2016年 WangXiaoLa. All rights reserved.
//

NSString *const ZKOrderDetailsDDCellID =@"ZKOrderDetailsDDCellID";

#import "ZKOrderDetailsDDCell.h"
#import "ZKPopImageView.h"
@implementation ZKOrderDetailsDDCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)ewmButton:(id)sender {

    ZKPopImageView *pop = [[ZKPopImageView alloc] initImage:[UIImage imageNamed:@"QQ_TL"]];
    [pop show];

}

@end
