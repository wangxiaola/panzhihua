//
//  ZKSceneStatusManCell.m
//  CYmiangzhu
//
//  Created by 汤亮 on 15/8/31.
//  Copyright (c) 2015年 WangXiaoLa. All rights reserved.
//

#import "ZKSceneStatusManCell.h"
#import "ZKSceneStatus.h"

#import "CYmiangzhu-Swift.h"
@interface ZKSceneStatusManCell()

@property (weak, nonatomic) IBOutlet RatingBar *ratingBar;

@end

@implementation ZKSceneStatusManCell

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)setStatus:(ZKSceneStatus *)status
{
    
    [super setStatus:status];
    
    CGFloat ratio = (CGFloat)status.result / (CGFloat)status.maxpeople;
    
    [self.ratingBar setRating:ratio];
    

    

}

@end
