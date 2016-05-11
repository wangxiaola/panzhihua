//
//  ZKmyOrderViewController.m
//  CYmiangzhu
//
//  Created by 王小腊 on 15/12/11.
//  Copyright © 2015年 WangXiaoLa. All rights reserved.
//

#import "ZKmyOrderViewController.h"
#import "ZKMainTypeView.h"
#import "ZKordeConterView.h"

@interface ZKmyOrderViewController ()<ZKMainTypeViewDelegate,UIScrollViewDelegate>

{
    UIScrollView *scroollview;
    ZKMainTypeView *chooseView;
    ZKordeConterView *views;
    BOOL isviews;
}
@end

@implementation ZKmyOrderViewController

-(void)viewWillAppear:(BOOL)animated

{
    if (isviews ==YES) {
        
        [views updata];
    }
}

-(id)init
{

    self = [super init];
    if (self) {
        
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupNav];
    [self initView];
    isviews =YES;
    
    if (self.index) {
        
        scroollview.contentOffset = CGPointMake(scroollview.frame.size.width*self.index, 0);
        [chooseView selectToIndex:self.index];
    }
    
}

- (void)setupNav
{
    self.titeLabel.text = @"我的订单";
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

-(void)initView
{
    self.view.backgroundColor =YJCorl(249, 249, 249);
    chooseView =[[ZKMainTypeView alloc]initFrame:CGRectMake(0, navigationHeghit, kDeviceWidth, 34) filters:@[@"未付款",@"未消费",@"已完成",@"退款单"]];
    chooseView.delegate =self;
    [self.view addSubview:chooseView];

    scroollview =[[UIScrollView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(chooseView.frame)+1.5 , kDeviceWidth, TabelHeghit -34-8)];
    scroollview.delegate =self;
    scroollview.pagingEnabled =YES;
    scroollview.contentOffset =CGPointMake(0, 0);
    scroollview.contentSize =CGSizeMake(kDeviceWidth*4, scroollview.frame.size.height);
    scroollview.showsHorizontalScrollIndicator =NO;
    [self.view addSubview:scroollview];
    
    NSArray *typeArray =@[@"0",@"1",@"2",@"3"];
    for (int i =0; i<4; i++) {
        
        views =[[ZKordeConterView alloc]initWithFrame:CGRectMake(kDeviceWidth*i, 0, kDeviceWidth, scroollview.frame.size.height) type:typeArray[i]];
        views.contess = self;
        [views chooseView:^(NSInteger p) {
            
            scroollview.contentOffset = CGPointMake(scroollview.frame.size.width*p, 0);
            [chooseView selectToIndex:p];
 
        }];
              
        [scroollview addSubview:views];

    }
}



#pragma mark  -----ZKMainHuaTiaoViewDelegate---
-(void)selectTypeIndex:(NSInteger)index;
{
    [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        scroollview.contentOffset = CGPointMake(scroollview.frame.size.width*index, 0);
    } completion:^(BOOL finished) {
    }];

}

#pragma mark scrollViewDelegate

//减速结束   停止
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    
    int num = scrollView.contentOffset.x / self.view.frame.size.width ;
    
    [chooseView selectToIndex:num];

}



@end
