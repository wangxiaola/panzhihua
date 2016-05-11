//
//  ZKSceneStatusCell.m
//  CYmiangzhu
//
//  Created by 汤亮 on 15/9/1.
//  Copyright (c) 2015年 WangXiaoLa. All rights reserved.
//

#import "ZKSceneStatusCell.h"
#import "ZKSceneStatus.h"

@interface ZKSceneStatusCell()

@property (nonatomic, weak) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *sceneNameLabel;
@end

@implementation ZKSceneStatusCell

- (void)awakeFromNib
{
    self.bgView.backgroundColor = ZKSceneStatusBgNormalColor;
}

- (void)setStatus:(ZKSceneStatus *)status
{
    _status = status;
    
    
    CGFloat ratio = (CGFloat)status.result / (CGFloat)status.maxpeople;
    
    if (ratio >= 0.8) {
        self.bgView.backgroundColor = ZKSceneStatusBgMaxColor;
    }else{
        
        self.bgView.backgroundColor = ZKSceneStatusBgNormalColor;
    }
    
    self.sceneNameLabel.text = status.name;
}

@end
