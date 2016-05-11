//
//  ZKSceneryTicketCell.m
//  CYmiangzhu
//
//  Created by 汤亮 on 15/12/9.
//  Copyright © 2015年 WangXiaoLa. All rights reserved.
//

#import "ZKSceneryTicketCell.h"
#import "ZKSceneryTicketModel.h"

NSString *const ZKSceneryTicketCellID = @"ZKSceneryTicketCellID";

@interface ZKSceneryTicketCell()
@property (weak, nonatomic) IBOutlet UIImageView *senceryImageView;
@property (weak, nonatomic) IBOutlet UIView *shadowView;
@property (weak, nonatomic) IBOutlet UILabel *shadowTitleLabel;

@property (weak, nonatomic) IBOutlet UIButton *collectCountButton;
@property (weak, nonatomic) IBOutlet UIButton *shareCountButton;
@property (weak, nonatomic) IBOutlet UIButton *commentCountButton;

@end

@implementation ZKSceneryTicketCell

- (void)awakeFromNib {
    [super awakeFromNib];
    CAGradientLayer *gradient = [[CAGradientLayer alloc] init];
    gradient.frame = self.shadowView.bounds;
    gradient.startPoint = CGPointMake(0, 1);
    gradient.endPoint = CGPointMake(0, 0);
    gradient.colors = @[(id)(RGBACOLOR(20, 30, 30, 0.85).CGColor), (id)([UIColor clearColor].CGColor)];
    [self.shadowView.layer insertSublayer:gradient atIndex:0];
}

- (void)setSceneryTicketModel:(ZKSceneryTicketModel *)sceneryTicketModel
{
    _sceneryTicketModel = sceneryTicketModel;
    
    [ZKUtil UIimageView:self.senceryImageView NSSting:[NSString stringWithFormat:@"%@%@", imageUrlPrefix, sceneryTicketModel.logosmall]];
    self.shadowTitleLabel.text = sceneryTicketModel.name;
    [self.collectCountButton setTitle:sceneryTicketModel.collection forState:UIControlStateNormal];
    [self.shareCountButton setTitle:sceneryTicketModel.sharecount forState:UIControlStateNormal];
    [self.commentCountButton setTitle:sceneryTicketModel.commentcount forState:UIControlStateNormal];
}

- (void)setFrame:(CGRect)frame
{
    frame.size.height -= 5;
    [super setFrame:frame];
}

@end
