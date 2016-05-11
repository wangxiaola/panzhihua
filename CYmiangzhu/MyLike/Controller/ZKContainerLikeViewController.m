//
//  ZKContainerLikeViewController.m
//  CYmiangzhu
//
//  Created by 汤亮 on 15/12/11.
//  Copyright © 2015年 WangXiaoLa. All rights reserved.
//

#import "ZKContainerLikeViewController.h"
#import "ZKMainTypeView.h"
#import "ZKBaseLikeTableViewController.h"
#import "ZKHotelLikeTableViewController.h"
#import "ZKShoppingLikeTableViewController.h"
#import "ZKSceneryLikeTableViewController.h"
#import "ZKRecreationLikeTableViewController.h"
#import "ZKFoodLikeTableViewController.h"

static int kVcCount = 5;

@interface ZKContainerLikeViewController ()<ZKMainTypeViewDelegate,UIScrollViewDelegate>
@property (nonatomic, weak) ZKMainTypeView *segmentedView;

@property (nonatomic, weak) UIScrollView *backScrollView;
@end

@implementation ZKContainerLikeViewController

- (instancetype)init
{
    if (self = [super init]) {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNav];
    [self setupSegmentedView];
    [self setupVcs];
}

- (void)setupNav
{
    self.titeLabel.text = self.likeType == ZKLikeTypeCollection ? @"我的收藏" : @"我的分享";
    self.rittBarButtonItem =[[UIButton alloc]initWithFrame:CGRectMake(kDeviceWidth-2-40, 20, 40, 40)];
    self.rittBarButtonItem.backgroundColor =[UIColor clearColor];
    [self.rittBarButtonItem setImage:[UIImage imageNamed:@"hom"] forState:UIControlStateNormal];
    [self.rittBarButtonItem addTarget:self action:@selector(backToHome) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationBarView addSubview:self.rittBarButtonItem];
}

- (void)backToHome
{
    self.tabBarController.selectedIndex = 0;
    [self.navigationController popToRootViewControllerAnimated:NO];
}

- (void)setupSegmentedView
{
    ZKMainTypeView *seg = [[ZKMainTypeView alloc] initFrame:CGRectMake(0, navigationHeghit, self.view.bounds.size.width, 35) filters:@[@"景点", @"酒店", @"美食", @"购物", @"娱乐"]];
    seg.delegate = self;
    seg.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:seg];
    self.segmentedView = seg;
}

- (void)setupVcs
{
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    CGFloat scrollX = 0;
    CGFloat scrollY = CGRectGetMaxY(self.segmentedView.frame) + 1.5;
    CGFloat scrollW = self.view.bounds.size.width;
    CGFloat scrollH = self.view.bounds.size.height - scrollY;
    scrollView.frame = CGRectMake(scrollX, scrollY, scrollW, scrollH);
    scrollView.contentSize = CGSizeMake(kVcCount * scrollW, 0);
    scrollView.pagingEnabled = YES;
    scrollView.scrollEnabled = NO;
    scrollView.delegate =self;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:scrollView];
    self.backScrollView = scrollView;
    
    ZKSceneryLikeTableViewController *vc1 =[[ZKSceneryLikeTableViewController alloc] init];
    [self setupVc:vc1 atIndex:0];
    
    ZKHotelLikeTableViewController *vc2 = [[ZKHotelLikeTableViewController alloc] init];
    [self setupVc:vc2 atIndex:1];
    
    ZKFoodLikeTableViewController *vc3 = [[ZKFoodLikeTableViewController alloc] init];
    [self setupVc:vc3 atIndex:2];
    
    ZKShoppingLikeTableViewController *vc4 = [[ZKShoppingLikeTableViewController alloc] init];
    [self setupVc:vc4 atIndex:3];
    
    ZKRecreationLikeTableViewController *vc5 = [[ZKRecreationLikeTableViewController alloc] init];
    [self setupVc:vc5 atIndex:4];
}

#pragma mark - ZKMainTypeViewDelegate
- (void)selectTypeIndex:(NSInteger)index
{
    [self.backScrollView setContentOffset:CGPointMake(index * self.view.bounds.size.width, 0) animated:NO];
}

#pragma mark scrollViewDelegate

//减速结束   停止
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    
    int num = scrollView.contentOffset.x / self.view.frame.size.width ;
    
    [self.segmentedView selectToIndex:num];
    
}


- (void)setupVc:(ZKBaseLikeTableViewController *)vc atIndex:(NSInteger)index
{
    vc.likeType = self.likeType;
    vc.view.frame = CGRectMake(index * self.backScrollView.frame.size.width, 0, self.backScrollView.frame.size.width, self.backScrollView.frame.size.height);
    vc.view.backgroundColor = RGBCOLOR(231, 231, 231);
    
    [self.backScrollView addSubview:vc.view];
    [self addChildViewController:vc];
}

@end
