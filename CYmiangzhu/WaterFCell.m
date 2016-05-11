//
//  WaterFCell.m
//  CollectionView
//
//  Created by d2space on 14-2-26.
//  Copyright (c) 2014年 D2space. All rights reserved.
//

#import "WaterFCell.h"

@implementation WaterFCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor =[UIColor whiteColor];
        [self setup];
    }
    return self;
}
#pragma mark - Setup
- (void)setup
{
    [self setupView];
    [self setupTextView];
}

- (void)setupView
{
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,0,0)];

    self.imageView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.imageView];
}

- (void)setupTextView
{
    self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,0,0,0)];
    self.nameLabel.numberOfLines = 0;
    self.nameLabel.textAlignment = NSTextAlignmentCenter;
    self.nameLabel.font = [UIFont systemFontOfSize:13];
    self.nameLabel.layer.masksToBounds = YES;
    self.nameLabel.layer.borderColor = [UIColor grayColor].CGColor;
    self.nameLabel.layer.borderWidth = 0.4;
    self.nameLabel.textColor = [UIColor grayColor];
    self.nameLabel.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.nameLabel];
}

//#pragma mark - Configure
//- (void)configureCellWithIndexPath:(NSIndexPath *)indexPath
//{
//    self.textView.text = [NSString stringWithFormat:@"Cell %ld", (long)(indexPath.row + 1)];
//}

@end
