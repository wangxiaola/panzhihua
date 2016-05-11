//
//  ZKmyTableViewCell.m
//  CYmiangzhu
//
//  Created by Daqsoft-Mac on 15/8/14.
//  Copyright (c) 2015年 WangXiaoLa. All rights reserved.
//

#import "ZKmyTableViewCell.h"

@implementation ZKmyTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

-(void)updata:(ZKmyList*)p;
{

    NSString *name ;
    
    if (strIsEmpty(p.info)==1) {
        name =@"";
    }else{
        
        name =p.info;
    }
    self.ritLabel.text =name;
    

}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
