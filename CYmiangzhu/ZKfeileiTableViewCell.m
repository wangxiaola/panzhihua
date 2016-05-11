//
//  ZKfeileiTableViewCell.m
//  CYmiangzhu
//
//  Created by Daqsoft-Mac on 15/8/13.
//  Copyright (c) 2015年 WangXiaoLa. All rights reserved.
//

#import "ZKfeileiTableViewCell.h"
#import "ZKCategory.h"
@implementation ZKfeileiTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)updata:(ZKCategory *)p;
{

//    NSString *name ;
//    
//    if (strIsEmpty(p.name)==1) {
//        name =@"未知";
//    }else{
//    
//        name =p.name;
//    }
//    self.nameLabel.text =name;
//    
//    NSString *infor ;
//    
//    if (strIsEmpty(p.name)==1) {
//        infor =@"未知";
//    }else{
//        
//        infor =p.infor;
//    }
    self.nameLabel.text = p.title;
    
    self.inforLabel.text = p.subtitle;
    
    self.lefImage.image =[UIImage imageNamed:[NSString stringWithFormat:@"feilei_Image_%@",p.index]];

}
@end
