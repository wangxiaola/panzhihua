//
//  ZKEventQueryViewController.m
//  CYmiangzhu
//
//  Created by 王小腊 on 16/5/17.
//  Copyright © 2016年 WangXiaoLa. All rights reserved.
//

#import "ZKEventQueryViewController.h"
#import "ZKMainTypeView.h"
#import "ZKEventQueryStateView.h"

@interface ZKEventQueryViewController ()<ZKMainTypeViewDelegate,UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *eqScroollview;
@property (nonatomic, strong) ZKMainTypeView *chooseView;

@end

@implementation ZKEventQueryViewController


- (ZKMainTypeView *)chooseView
{
    if (!_chooseView) {
        
        _chooseView =[[ZKMainTypeView alloc]initFrame:CGRectMake(0, 64, kDeviceWidth, 34) filters:@[@"全部事件",@"已处理",@"已接收",@"上报中"]];
        _chooseView.delegate =self;
        
    }
    
    return _chooseView;
    
}

- (UIScrollView *)eqScroollview
{
    
    if (!_eqScroollview) {
        
        _eqScroollview =[[UIScrollView alloc]initWithFrame:CGRectMake(0, 34+64 , kDeviceWidth,self.view.frame.size.height -34-64)];
        _eqScroollview.delegate =self;
        _eqScroollview.pagingEnabled =YES;
        _eqScroollview.contentOffset =CGPointMake(0, 0);
        _eqScroollview.contentSize =CGSizeMake(kDeviceWidth*4,self.view.frame.size.height - 34 -64);
        _eqScroollview.backgroundColor = [UIColor whiteColor];
        _eqScroollview.showsHorizontalScrollIndicator =NO;
        
    }
    
    return _eqScroollview;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"事件查询";
    
    [self.view addSubview:self.chooseView];
    [self.view addSubview:self.eqScroollview];
    
      self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithIcon:@"backimage" highIcon:@"backimage" target:self action:@selector(goBack)];
    
    for (int i = 0; i<4; i++) {
        
        ZKEventQueryStateView *sateView = [[ZKEventQueryStateView alloc] initWithFrame:CGRectMake(kDeviceWidth*i, 0, kDeviceWidth, self.eqScroollview.frame.size.height) viewState:i];
        sateView.controller = self;
        [self.eqScroollview addSubview:sateView];
    }
    
    if (self.eqIndex > 0) {
        
        [self selectedView];
    }
    
    if (self.isAddButton == YES) {
        
        [self addRitButton];
    }
}


/**
 *  初始化选中
 *
 *  @param index 
 */
- (void)selectedView;
{

   [self.chooseView selectToIndex:self.eqIndex];
   self.eqScroollview.contentOffset = CGPointMake(kDeviceWidth*self.eqIndex, 0);
}

- (void)addRitButton;
{

    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithIcon:@"NewAdd" highIcon:@"NewAdd" target:self action:@selector(addQuery)];
    
}
#pragma mark  -----ZKMainHuaTiaoViewDelegate---
-(void)selectTypeIndex:(NSInteger)index;
{

    NSLog(@" ===== %d",index);
   [self.eqScroollview setContentOffset:CGPointMake(kDeviceWidth*index, 0) animated:YES];
    
}

#pragma mark scrollViewDelegate

//减速结束   停止
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    
    int num = scrollView.contentOffset.x / self.view.frame.size.width ;
    [self.chooseView selectToIndex:num];
    
}

#pragma mark 添加
- (void)addQuery
{
    [self.navigationController pushViewController:[NSClassFromString(@"ZKCallPoliceViewController") new] animated:YES];
}
- (void)goBack
{

    if (self.isAddButton == YES) {
        
        [self dismissViewControllerAnimated:NO completion:^{
            
        }];
    }
    else
    {
    
        [self.navigationController popViewControllerAnimated:YES];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
