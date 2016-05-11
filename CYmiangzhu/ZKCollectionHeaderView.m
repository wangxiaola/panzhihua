//
//  ZKCollectionHeaderView.m
//  CYmiangzhu
//
//  Created by 汤亮 on 15/9/1.
//  Copyright (c) 2015年 WangXiaoLa. All rights reserved.
//

#import "ZKCollectionHeaderView.h"

@interface ZKCollectionHeaderView()
@property (weak, nonatomic) IBOutlet UILabel *peopleLabel;


@end

@implementation ZKCollectionHeaderView

+ (instancetype)collectionHeaderView
{

    return [[[NSBundle mainBundle] loadNibNamed:@"ZKCollectionHeaderView" owner:nil options:nil] firstObject];
}


- (void)awakeFromNib
{
    self.peopleLabel.textColor =  RGBCOLOR(51, 202, 172);
    self.timeLabel.textColor = RGBCOLOR(104, 104, 104);
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
