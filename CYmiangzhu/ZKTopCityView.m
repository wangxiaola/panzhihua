//
//  ZKTopCityView.m
//  CYmiangzhu
//
//  Created by Daqsoft-Mac on 15/10/10.
//  Copyright © 2015年 WangXiaoLa. All rights reserved.
//

#import "ZKTopCityView.h"
#import "ZKCityGroup.h"

@interface ZKTopCityView()
@property (nonatomic, weak) UILabel *localLabel;
@property (nonatomic, weak) UIButton *localButton;

@property (nonatomic, weak) UILabel *hotCityLabel;
@property (nonatomic, weak) UIView *hotCityView;

@property (nonatomic, weak) UIView *lineView;

@property (nonatomic, weak) UIButton *selectedButton;
@end

@implementation ZKTopCityView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        UILabel *localLabel = [[UILabel alloc] init];
        localLabel.font = SYSTEMFONT(13);
        localLabel.textColor = [UIColor grayColor];
        localLabel.text = @"定位";
        localLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:localLabel];
        self.localLabel = localLabel;
        
        UIButton *localButton = [UIButton buttonWithType:UIButtonTypeCustom];
        localButton.titleLabel.font = SYSTEMFONT(13);
        [localButton setTitleColor:YJCorl(51, 202, 171) forState:UIControlStateNormal];
        [localButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        localButton.layer.cornerRadius = 3;
        localButton.layer.masksToBounds = YES;
        [localButton addTarget:self action:@selector(citySelected:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:localButton];
        self.localButton = localButton;
        
        UILabel *hotCityLabel = [[UILabel alloc] init];
        hotCityLabel.textColor = [UIColor grayColor];
        hotCityLabel.font = SYSTEMFONT(13);
        hotCityLabel.text = @"热门城市";
        hotCityLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:hotCityLabel];
        self.hotCityLabel = hotCityLabel;
        
        UIView *hotCityView = [[UIView alloc] init];
        hotCityView.backgroundColor = [UIColor clearColor];
        [self addSubview:hotCityView];
        self.hotCityView = hotCityView;
        
        
        for (int i = 0; i < 15; i++) {
            
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.titleLabel.font = SYSTEMFONT(13);
            [button setTitleColor:YJCorl(51, 202, 171) forState:UIControlStateNormal];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
            button.layer.cornerRadius = 3;
            button.layer.masksToBounds = YES;
            [button addTarget:self action:@selector(citySelected:) forControlEvents:UIControlEventTouchUpInside];
            [self.hotCityView addSubview:button];
        }
        
        
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:lineView];
        self.lineView = lineView;
        
    }
    return self;
}


- (void)setCityGroup:(ZKCityGroup *)cityGroup
{
    _cityGroup = cityGroup;
    
    [self.localButton setTitle:@"成都" forState:UIControlStateNormal];
    
    //    self.hotCityView.cityGroup = self.cityGroup;
    
    for (int i = 0; i < 15; i++) {
        
        UIButton *button = self.hotCityView.subviews[i];
        
        [button setTitle:cityGroup.cities[i] forState:UIControlStateNormal];
    }
    
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat localLabelX = 20;
    CGFloat localLabelY = 8;
    CGFloat localLabelW = 150;
    CGFloat localLabelH = 21;
    self.localLabel.frame = CGRectMake(localLabelX, localLabelY, localLabelW, localLabelH);
    
    CGFloat localButtonX = localLabelX;
    CGFloat localButtonY = CGRectGetMaxY(self.localLabel.frame) + 8;
    CGFloat localButtonW = (self.frame.size.width - 70) / 5;
    CGFloat localButtonH = localLabelH;
    self.localButton.frame = CGRectMake(localButtonX, localButtonY, localButtonW, localButtonH);
    
    CGFloat hotCityLabelX = localLabelX;
    CGFloat hotCityLabelY = CGRectGetMaxY(self.localButton.frame) + 8;
    CGFloat hotCityLabelW = localLabelW;
    CGFloat hotCityLabelH = 21;
    self.hotCityLabel.frame = CGRectMake(hotCityLabelX, hotCityLabelY, hotCityLabelW, hotCityLabelH);
    
    
    CGFloat hotCityViewX = 15;
    CGFloat hotCityViewY = CGRectGetMaxY(self.hotCityLabel.frame) + 3;
    CGFloat hotCityViewW = self.frame.size.width- 40;
    CGFloat hotCityViewH = 80;
    self.hotCityView.frame = CGRectMake(hotCityViewX, hotCityViewY, hotCityViewW, hotCityViewH);
    
    CGFloat margin = 5;
    int rows = 3;
    int rays = 5;
    CGFloat w = (self.hotCityView.frame.size.width - (rays + 1) * margin) / rays;
    CGFloat h = (self.hotCityView.frame.size.height - (rows + 1) * margin) / rows;
    
    for (int i = 0; i < 15; i++) {
        
        UIButton *button = self.hotCityView.subviews[i];
        
        int row = i / rays;
        int ray = i % rays;
        CGFloat x = (margin + w) * ray + margin;
        
        CGFloat y = (margin + h) * row + margin;
        
        button.frame = CGRectMake(x, y, w, h);
    }
    
    CGFloat lineViewX = 0;
    CGFloat lineViewW = self.frame.size.width;
    CGFloat lineViewH = 0.5;
    CGFloat lineViewY = self.frame.size.height- lineViewH;
    self.lineView.frame = CGRectMake(lineViewX, lineViewY, lineViewW, lineViewH);
}

- (void)citySelected:(UIButton *)button
{
    self.selectedButton.selected = NO;
    self.selectedButton.backgroundColor = [UIColor whiteColor];
    button.selected = YES;
    button.backgroundColor = YJCorl(51, 202, 171);
    self.selectedButton = button;

    if ([self.delegate respondsToSelector:@selector(topCityView:didSelectedCity:)]) {
        [self.delegate topCityView:self didSelectedCity:button.titleLabel.text];
    }
}

@end
