//
//  ViewControllerOneCell.m
//  trasitionpractice
//
//  Created by YouLoft_MacMini on 15/11/23.
//  Copyright © 2015年 YouLoft_MacMini. All rights reserved.
//

#import "XWMagicMoveCell.h"
#import "ZKTripMode.h"
#import "ZK720ScenicMode.h"

@implementation XWMagicMoveCell

-(void)setListModel:(ZKTripMode *)listModel
{
    _listModel = listModel;
    self.nameLabel.backgroundColor =[UIColor colorWithWhite:0 alpha:0.5];;
    self.nameLabel.text =listModel.name;
    self.imageView.layer.masksToBounds =YES;
    self.imageView.layer.cornerRadius =6;
    [ZKUtil UIimageView:self.imageView NSSting:[NSString stringWithFormat:@"%@%@", imageUrlPrefix, [listModel.image stringByReplacingOccurrencesOfString:@"app/" withString:@""]]];
}

-(void)setListmode:(ZK720ScenicMode *)listmode
{
    _listmode = listmode;
    self.nameLabel.backgroundColor =[UIColor colorWithWhite:0 alpha:0.5];;
    self.nameLabel.text =listmode.name;
    self.imageView.layer.masksToBounds =YES;
    self.imageView.layer.cornerRadius =6;
    [ZKUtil UIimageView:self.imageView NSSting:[NSString stringWithFormat:@"%@%@", imageUrlPrefix, listmode.logosmall]];
}
@end
