//
//  ZKWellcomeJTTableViewCell.m
//  CYmiangzhu
//
//  Created by 王小腊 on 16/5/13.
//  Copyright © 2016年 WangXiaoLa. All rights reserved.
//

NSString *const ZKWellcomeJTTableViewCellID = @"ZKWellcomeJTTableViewCellID";

#import "ZKWellcomeJTTableViewCell.h"
#import "ZKWellcomeJTMode.h"

@interface ZKWellcomeJTTableViewCell ()

@end

@implementation ZKWellcomeJTTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];

}

- (void)setDataList:(ZKWellcomeJTMode *)dataList
{

    NSString *str = @"66";
    NSString *pjStr = [NSString stringWithFormat:@"¥%@人均",str];
    
    NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:pjStr];
    
    [AttributedStr addAttribute:NSFontAttributeName
     
                          value:[UIFont systemFontOfSize:16.0]
     
                          range:NSMakeRange(0, str.length+1)];
        
    self.inforlabel.attributedText = AttributedStr;
    

}
- (IBAction)click:(id)sender {
    
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
