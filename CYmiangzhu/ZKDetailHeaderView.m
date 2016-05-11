//
//  ZKDetailHeaderView.m
//  CYmiangzhu
//
//  Created by 汤亮 on 16/1/7.
//  Copyright © 2016年 WangXiaoLa. All rights reserved.
//

#import "ZKDetailHeaderView.h"
#import "CYmiangzhu-Swift.h"
#import "ZKscenicSpotList.h"

@interface ZKDetailHeaderView()
@property (nonatomic, weak) UIImageView *showImageView;
@property (nonatomic, weak) UIView *blackBackView;
@property (nonatomic, weak) UILabel *nameLabel;
@property (nonatomic, weak) RatingBar *ratingBar;
@property (nonatomic, weak) UILabel *scoreLabel;
@end

@implementation ZKDetailHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        UIImageView *imageView =[[UIImageView alloc] init];
        imageView.backgroundColor = [UIColor clearColor];
        imageView.clipsToBounds = YES;
        [self addSubview:imageView];
        self.showImageView = imageView;
        
        UIView *blackBackView = [[UIView alloc] init];
        blackBackView.backgroundColor = [UIColor blackColor];
        blackBackView.alpha = 0.35;
        [self addSubview:blackBackView];
        self.blackBackView = blackBackView;
        
        UILabel *nameLabel = [[UILabel alloc] init];
        nameLabel.textAlignment = NSTextAlignmentLeft;
        nameLabel.font = [UIFont systemFontOfSize:12];
        nameLabel.textColor = [UIColor whiteColor];
        [self addSubview:nameLabel];
        self.nameLabel = nameLabel;
        
        RatingBar *ratingBar = [[RatingBar alloc] init];
        ratingBar.isIndicator = YES;
        ratingBar.numStars = 5;
        ratingBar.ratingMax = 5;
        [self addSubview:ratingBar];
        self.ratingBar = ratingBar;
        
        UILabel *scoreLabel = [[UILabel alloc] init];
        scoreLabel.textAlignment = NSTextAlignmentLeft;
        scoreLabel.font = [UIFont systemFontOfSize:12];
        scoreLabel.textColor = [UIColor orangeColor];
        [self addSubview:scoreLabel];
        self.scoreLabel = scoreLabel;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.showImageView.frame = self.bounds;
    
    CGFloat blackBackVieX = 0;
    CGFloat blackBackVieH = 44;
    CGFloat blackBackVieY = self.bounds.size.height - blackBackVieH;
    CGFloat blackBackVieW = self.bounds.size.width;
    self.blackBackView.frame = CGRectMake(blackBackVieX, blackBackVieY, blackBackVieW, blackBackVieH);
    
    CGFloat ratingBarX = 8;
    CGFloat ratingBarH = blackBackVieH / 2 - 10;
    CGFloat ratingBarY = self.bounds.size.height - ratingBarH - 5;
    CGFloat ratingBarW = 80;
    self.ratingBar.frame = CGRectMake(ratingBarX, ratingBarY, ratingBarW, ratingBarH);
    
    CGFloat scoreLabelX = CGRectGetMaxX(self.ratingBar.frame) + 5;
    CGFloat scoreLabelY = ratingBarY;
    CGFloat scoreLabelW = self.bounds.size.width- scoreLabelX;
    CGFloat scoreLabelH = ratingBarH;
    self.scoreLabel.frame = CGRectMake(scoreLabelX, scoreLabelY, scoreLabelW, scoreLabelH);
    
    CGFloat nameLabelX = ratingBarX;
    CGFloat nameLabelH = blackBackVieH / 2;
    CGFloat nameLabelY = blackBackVieY + 5;
    CGFloat nameLabelW = self.bounds.size.width - nameLabelX;
    self.nameLabel.frame = CGRectMake(nameLabelX, nameLabelY, nameLabelW, nameLabelH);
}

- (void)setHotelModel:(ZKscenicSpotList *)hotelModel
{
    _hotelModel = hotelModel;
    [ZKUtil UIimageView:self.showImageView NSSting:[NSString stringWithFormat:@"%@%@", imageUrlPrefix, hotelModel.logosmall]];
    self.nameLabel.text = hotelModel.name;
    self.ratingBar.rating = hotelModel.exponent;
    self.scoreLabel.text = [NSString stringWithFormat:@"%.1f分", hotelModel.exponent];
}

@end
