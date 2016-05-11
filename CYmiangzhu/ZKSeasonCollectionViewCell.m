//
//  ZKSeasonCollectionViewCell.m
//  CYmiangzhu
//
//  Created by 王小腊 on 16/3/30.
//  Copyright © 2016年 WangXiaoLa. All rights reserved.
//

#import "ZKSeasonCollectionViewCell.h"
#import "ZKSeasonMode.h"
@implementation ZKSeasonCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.namelael.layer.masksToBounds = YES;
    self.namelael.layer.borderWidth = 0.2;
    self.layer.borderColor = viewsBackCorl.CGColor;
}


- (void)setListModel:(ZKSeasonMode *)listModel

{
//    [ZKUtil UIimageView:self.imageView NSSting:[NSString stringWithFormat:@"%@%@", imageUrlPrefix, listModel.lurl]];
    self.namelael.text = listModel.title;
}

@end
