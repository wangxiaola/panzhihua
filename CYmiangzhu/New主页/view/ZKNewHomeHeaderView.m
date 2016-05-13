//
//  ZKNewHomeHeaderView.m
//  CYmiangzhu
//
//  Created by 王小腊 on 16/5/11.
//  Copyright © 2016年 WangXiaoLa. All rights reserved.
//

#import "ZKNewHomeHeaderView.h"


@implementation ZKNewHomeHeaderView


@synthesize cycleScrollView;

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        [self initSuperViews];
    }

    return self;
}

- (NSMutableArray *)imageArray
{
    if (!_imageArray) {
        
        _imageArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _imageArray;
}

- (void)initSuperViews

{
    [self.imageArray addObject:[UIImage imageNamed:@"season_1.jpg"]];
    [self.imageArray addObject:[UIImage imageNamed:@"season_2.jpg"]];
    [self.imageArray addObject:[UIImage imageNamed:@"season_3.jpg"]];
    

    // 网络加载 --- 创建带标题的图片轮播器
     cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, self.frame.size.width, 450/3) delegate:self placeholderImage:[UIImage imageNamed:@"errData"]];
    cycleScrollView.autoScrollTimeInterval = 5;
    cycleScrollView.delegate = self;
    cycleScrollView.pageControlDotSize =CGSizeMake(5, 5);
    cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
    cycleScrollView.currentPageDotColor = [UIColor orangeColor]; // 自定义分页控件小圆标颜色
    cycleScrollView.pageDotColor = [UIColor whiteColor];
    [self addSubview:cycleScrollView];
    
    //         --- 模拟加载延迟
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        cycleScrollView.localizationImageNamesGroup = self.imageArray;
    });

    
    UIView *buttonView = [[UIView alloc]initWithFrame:CGRectMake(0,cycleScrollView.frame.size.height, kDeviceWidth, self.frame.size.height- cycleScrollView.frame.size.height)];
    [self addSubview:buttonView];
    
    float buttonW = kDeviceWidth/5;
    float buttonH = buttonView.frame.size.height;
    
    NSArray *imagePathArray = @[@"feilei_Image_11",@"feilei_Image_10",@"feilei_Image_12",@"feilei_Image_9",@"feilei_Image_8"];
    NSArray *strArray =
       @[@"特色美食",@"酒店住宿",@"景区门票",@"特色购物",@"休闲娱乐"];
    
    for (int i = 0; i<5; i++) {
        
        UIButton *bty = [UIButton buttonWithType:UIButtonTypeCustom];
        bty.backgroundColor = [UIColor whiteColor];
        [buttonView addSubview:bty];
        bty.frame = CGRectMake(buttonW*i, 0, buttonW, buttonH);
        
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 42, 42)];
        imageView.backgroundColor = [UIColor whiteColor];
        imageView.layer.masksToBounds = YES;
        imageView.layer.cornerRadius = 42/2;
        imageView.center = CGPointMake(buttonW/2, buttonH/2 - 10);
        imageView.image = [UIImage imageNamed:imagePathArray[i]];
        [bty addSubview:imageView];
        
        
        UILabel *bsLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, imageView.frame.origin.y+48, bty.frame.size.width, 18)];
        bsLabel.backgroundColor = [UIColor whiteColor];
        bsLabel.font = [UIFont systemFontOfSize:13];
        bsLabel.textColor = [UIColor grayColor];
        bsLabel.textAlignment = NSTextAlignmentCenter;
        bsLabel.text = [strArray objectAtIndex:i];
        [bty addSubview:bsLabel];

    }
    

}
#pragma mark SDCycleScrollViewDelegate

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index;
{


}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
