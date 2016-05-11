//
//  ZKDetailHotelInfoView.m
//  CYmiangzhu
//
//  Created by 汤亮 on 16/1/8.
//  Copyright © 2016年 WangXiaoLa. All rights reserved.
//

#import "ZKDetailHotelInfoView.h"

@interface ZKDetailHotelInfoView()
@property (nonatomic, weak) UIView *topLine;
@property (nonatomic, weak) UIImageView *iconView;
@property (nonatomic, weak) UILabel *infoLabel;
@property (nonatomic, weak) UIView *bottomLine;
@end

@implementation ZKDetailHotelInfoView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        
        UIView *topLine = [[UIView alloc] init];
        topLine.backgroundColor = [UIColor colorWithRed:200/255.0 green:200/255.0 blue:200/255.0 alpha:0.7];
        [self addSubview:topLine];
        self.topLine = topLine;
        
        UIImageView *iconView = [[UIImageView alloc] init];
        iconView.image = [UIImage imageNamed:@"detail_info"];
        [self addSubview:iconView];
        self.iconView = iconView;
        
        UILabel *infoLabel = [[UILabel alloc] init];
        infoLabel.text = @"酒店介绍";
        infoLabel.font = [UIFont systemFontOfSize:13];
        [self addSubview:infoLabel];
        self.infoLabel = infoLabel;
        
        UIView *bottomLine = [[UIView alloc] init];
        bottomLine.backgroundColor = [UIColor colorWithRed:200/255.0 green:200/255.0 blue:200/255.0 alpha:0.7];
        [self addSubview:bottomLine];
        self.bottomLine = bottomLine;
    }
    return self;
}

+ (instancetype)detailHotelInfoView
{
    return [[ZKDetailHotelInfoView alloc] init];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.topLine.frame = CGRectMake(0, 0, self.bounds.size.width, 1);
    self.iconView.frame = CGRectMake(8, (self.bounds.size.height - 20) / 2, 20, 20);
    self.infoLabel.frame = CGRectMake(8 + 20 + 8, 0, self.bounds.size.width - 16, self.bounds.size.height);
    self.bottomLine.frame = CGRectMake(0, self.bounds.size.height - 1, self.bounds.size.width, 1);
}

@end
