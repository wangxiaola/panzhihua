//
//  ZKDetailCommentView.m
//  CYmiangzhu
//
//  Created by 汤亮 on 16/1/8.
//  Copyright © 2016年 WangXiaoLa. All rights reserved.
//

#import "ZKPjHeaderView.h"
#import "CYmiangzhu-Swift.h"
#import "ZKscenicSpotList.h"

@interface ZKPjHeaderView()
@property (nonatomic, weak) UIView *topLine;
@property (nonatomic, weak) RatingBar *ratingBar;
@property (nonatomic, weak) UILabel *scoreLabel;
@property (nonatomic, weak) UIButton *commentButton;
@property (nonatomic, weak) UIView *bottomLine;
@end

@implementation ZKPjHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        UIView *topLine = [[UIView alloc] init];
        topLine.backgroundColor = [UIColor colorWithRed:200/255.0 green:200/255.0 blue:200/255.0 alpha:0.7];
        [self addSubview:topLine];
        self.topLine = topLine;
        
        RatingBar *ratingBar = [[RatingBar alloc] init];
        ratingBar.isIndicator = YES;
        ratingBar.numStars = 5;
        ratingBar.ratingMax = 5;
        ratingBar.rating = 4;
        [self addSubview:ratingBar];
        self.ratingBar = ratingBar;
        
        UILabel *scoreLabel = [[UILabel alloc] init];
        scoreLabel.textAlignment = NSTextAlignmentLeft;
        scoreLabel.font = [UIFont systemFontOfSize:14];
        scoreLabel.textColor = [UIColor orangeColor];
        scoreLabel.text = @"4.0分";
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
    self.ratingBar.frame = CGRectMake(5, 15, 100, 14);
    CGFloat commentButtonY = 0;
    CGFloat commentButtonW = 45;
    CGFloat commentButtonX = self.bounds.size.width - commentButtonW;
    CGFloat commentButtonH = commentButtonW;
    self.commentButton.frame = CGRectMake(commentButtonX, commentButtonY, commentButtonW, commentButtonH);
    self.scoreLabel.frame = CGRectMake(110, 12, 50, 20);
    self.bottomLine.frame = CGRectMake(0, self.bounds.size.height - 1, self.bounds.size.width, 1);
}


@end
