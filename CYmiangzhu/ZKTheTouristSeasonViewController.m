//
//  ZKTheTouristSeasonViewController.m
//  CYmiangzhu
//
//  Created by Daqsoft-Mac on 15/8/18.
//  Copyright (c) 2015年 WangXiaoLa. All rights reserved.
//

#import "ZKTheTouristSeasonViewController.h"
#import "ZKBasicViewController.h"
#import "SDCycleScrollView.h"

@interface ZKTheTouristSeasonViewController ()<SDCycleScrollViewDelegate>
{

    SDCycleScrollView *cycleScrollView;
}

@end

@implementation ZKTheTouristSeasonViewController

-(id)init;
{
    self =[super init];
    if (self) {
        
        self.hidesBottomBarWhenPushed =YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.leftBarButtonItem removeFromSuperview];
    
    
    NSMutableArray *imageArray =[NSMutableArray arrayWithCapacity:0];
    
    for (int i =0; i<4; i++) {
        
        UIImage*img =[UIImage imageNamed:[NSString stringWithFormat:@"season_%d.jpg",i]];
        [imageArray addObject:img];
 
    }
    
    // 网络加载 --- 创建带标题的图片轮播器

    cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) shouldInfiniteLoop:YES imageNamesGroup:imageArray];
    cycleScrollView.backgroundColor =[UIColor whiteColor];
    cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
    cycleScrollView.delegate = self;
    cycleScrollView.pageControlDotSize =CGSizeMake(5, 5);
    cycleScrollView.currentPageDotColor = [UIColor orangeColor]; // 自定义分页控件小圆标颜色
    cycleScrollView.pageDotColor = [UIColor whiteColor];
    [self.view addSubview:cycleScrollView];

    cycleScrollView.autoScrollTimeInterval =imageArray.count;
    
    
    self.leftBarButtonItem = [[UIButton alloc]initWithFrame:CGRectMake(2, 20, buttonItemWidth, buttonItemWidth)];
    [self.leftBarButtonItem setImage:[UIImage imageNamed:@"backimage_white"] forState:UIControlStateNormal];
    self.leftBarButtonItem.backgroundColor =[UIColor clearColor];
    [self.leftBarButtonItem addTarget:self action:@selector(pcback) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view  addSubview:self.leftBarButtonItem];
    
}

#pragma mark 点击事件
-(void)pcback
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - SDCycleScrollViewDelegate

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
//    ZKBasicViewController *html =[[ZKBasicViewController alloc]init];
//    NSString *str = webUrl(@"piclist.aspx?z_pagetitle=旅游季节");
//    html.webToUrl = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [self.navigationController pushViewController:[NSClassFromString(@"ZKSeasonViewController") alloc] animated:YES];
    
}


@end
