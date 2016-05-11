//
//  ZKSceneStatusNumberCell.m
//  CYmiangzhu
//
//  Created by 汤亮 on 15/9/1.
//  Copyright (c) 2015年 WangXiaoLa. All rights reserved.
//

#import "ZKSceneStatusNumberCell.h"
#import "ZKSceneStatus.h"

@interface ZKSceneStatusNumberCell()
@property (weak, nonatomic) IBOutlet UILabel *peopleNumberLabel;

@end

@implementation ZKSceneStatusNumberCell

//@synthesize status = _status;

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.peopleNumberLabel.textColor = ZKSceneStatusBgNormalColor;
    
}

- (void)setStatus:(ZKSceneStatus *)status
{
    [super setStatus:status];
    
    CGFloat ratio = (CGFloat)status.result / (CGFloat)status.maxpeople;
    
    if (ratio >= 0.8) {
        self.peopleNumberLabel.textColor = ZKSceneStatusBgMaxColor;
    }else{
        self.peopleNumberLabel.textColor = ZKSceneStatusBgNormalColor;
    }
    
    self.peopleNumberLabel.text = [NSString stringWithFormat:@"%d/%d", status.result, status.maxpeople];
}

@end
