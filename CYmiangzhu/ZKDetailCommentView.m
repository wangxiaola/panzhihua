//
//  ZKDetailCommentView.m
//  CYmiangzhu
//
//  Created by 汤亮 on 16/1/8.
//  Copyright © 2016年 WangXiaoLa. All rights reserved.
//

#import "ZKDetailCommentView.h"
//#import "CYmiangzhu-Swift.h"
#import "ZKscenicSpotList.h"

@interface ZKDetailCommentView()
@property (nonatomic, weak) UIView *topLine;
//@property (nonatomic, weak) RatingBar *ratingBar;
@property (nonatomic, weak) UILabel *scoreLabel;
@property (nonatomic, weak) UIButton *commentButton;
@property (nonatomic, weak) UIView *bottomLine;
@end

@implementation ZKDetailCommentView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        UIView *topLine = [[UIView alloc] init];
        topLine.backgroundColor = [UIColor colorWithRed:200/255.0 green:200/255.0 blue:200/255.0 alpha:0.7];
        [self addSubview:topLine];
        self.topLine = topLine;
        
//        RatingBar *ratingBar = [[RatingBar alloc] init];
//        ratingBar.isIndicator = YES;
//        ratingBar.numStars = 5;
//        ratingBar.ratingMax = 5;
//        [self addSubview:ratingBar];
//        self.ratingBar = ratingBar;
        
        UILabel *scoreLabel = [[UILabel alloc] init];
        scoreLabel.textAlignment = NSTextAlignmentLeft;
        scoreLabel.font = [UIFont systemFontOfSize:14];
        scoreLabel.textColor = [UIColor orangeColor];
        scoreLabel.text = @"评价";
        [self addSubview:scoreLabel];
        self.scoreLabel = scoreLabel;
        
        UIButton *commentButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [commentButton setImage:[UIImage imageNamed:@"my_cell_4"] forState:UIControlStateNormal];
        commentButton.imageView.contentMode = UIViewContentModeCenter;
        [commentButton addTarget:self action:@selector(comment) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:commentButton];
        self.commentButton = commentButton;
        
        UIView *bottomLine = [[UIView alloc] init];
        bottomLine.backgroundColor = [UIColor colorWithRed:200/255.0 green:200/255.0 blue:200/255.0 alpha:0.7];
        [self addSubview:bottomLine];
        self.bottomLine = bottomLine;
    }
    return self;
}

+ (instancetype)detailCommentView
{
    return [[ZKDetailCommentView alloc] init];
}

- (void)comment
{
    if (self.commentBlock) {
        self.commentBlock();
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.topLine.frame = CGRectMake(0, 0, self.bounds.size.width, 1);
 
    CGFloat commentButtonY = 0;
    CGFloat commentButtonW = 45;
    CGFloat commentButtonX = self.bounds.size.width - commentButtonW;
    CGFloat commentButtonH = commentButtonW;
    self.commentButton.frame = CGRectMake(commentButtonX, commentButtonY, commentButtonW, commentButtonH);
    self.scoreLabel.frame = CGRectMake(10, 15, 40, 20);
    self.bottomLine.frame = CGRectMake(0, self.bounds.size.height - 1, self.bounds.size.width, 1);
}

- (void)setHotelModel:(ZKscenicSpotList *)hotelModel
{
    _hotelModel = hotelModel;

    
}

@end
