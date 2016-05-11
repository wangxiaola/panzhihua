//
//  ZKSceneManCollectionViewCell.m
//  CYmiangzhu
//
//  Created by 王小腊 on 16/2/23.
//  Copyright © 2016年 WangXiaoLa. All rights reserved.
//

#import "ZKSceneManCollectionViewCell.h"

@implementation ZKSceneManCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setStatus:(ZKSceneStatus *)status
{
    
    
    CGFloat ratio = (CGFloat)status.result * 5 / (CGFloat)status.maxpeople;
    
    [self.ratingBar setRating:ratio];
    
    
    self.sceneNameLabel.text = status.name;
    
    
}
@end
