//
//  ZKWellcomeViewController.m
//  CYmiangzhu
//
//  Created by 王小腊 on 16/5/13.
//  Copyright © 2016年 WangXiaoLa. All rights reserved.
//

#import "ZKWellcomeViewController.h"
#import "YYSearchBar.h"
#import "ZKMainTypeView.h"
#import "ZKWellcomeView.h"

@interface ZKWellcomeViewController ()<UISearchBarDelegate,ZKMainTypeViewDelegate,UIScrollViewDelegate,ZKWellcomeDelegate>

@property (nonatomic, strong) YYSearchBar *searchBar;
@property (nonatomic, strong) UIScrollView *scroollview;
@property (nonatomic, strong) ZKMainTypeView *chooseView;
@property (nonatomic, assign) NSInteger index;

@property (nonatomic, strong) ZKWellcomeView *jtView;
@property (nonatomic, strong) ZKWellcomeView *znView;
@end

@implementation ZKWellcomeViewController

- (YYSearchBar *)searchBar
{
    if (!_searchBar) {
        
        _searchBar = [[YYSearchBar alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth-100, 55)];
        _searchBar.backgroundColor = [UIColor clearColor];
        _searchBar.placeString = @"基地名称/康养指南";
        _searchBar.userInteractionEnabled = YES;
        _searchBar.delegate = self;
        _searchBar.returnKeyType = UIReturnKeySearch;
    }
    
    return _searchBar;
    
}
- (ZKMainTypeView *)chooseView
{
    if (!_chooseView) {
        
        _chooseView =[[ZKMainTypeView alloc]initFrame:CGRectMake(0, 64, kDeviceWidth, 34) filters:@[@"康养基地",@"康养指南"]];
        _chooseView.delegate =self;

    }
    
    return _chooseView;

}

- (UIScrollView *)scroollview
{

    if (!_scroollview) {
        
        _scroollview =[[UIScrollView alloc]initWithFrame:CGRectMake(0, 34+64 , kDeviceWidth,self.view.frame.size.height -34-64)];
        _scroollview.delegate =self;
        _scroollview.pagingEnabled =YES;
        _scroollview.contentOffset =CGPointMake(0, 0);
        _scroollview.contentSize =CGSizeMake(kDeviceWidth*2,self.view.frame.size.height - 34 -64);
        _scroollview.backgroundColor = [UIColor whiteColor];
        _scroollview.showsHorizontalScrollIndicator =NO;
        
    }
    
    return _scroollview;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initView];
}
#pragma mark 视图创建
- (void)initView
{
    self.index = 0;
    UIView *navigationView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 55)];
    navigationView.backgroundColor = [UIColor clearColor];
    [navigationView addSubview:self.searchBar];
    self.navigationItem.titleView = navigationView ;
    self.searchBar.center = CGPointMake(navigationView.centerX-55/2, navigationView.centerY);
    
    [self.view addSubview:self.chooseView];
    [self.view addSubview:self.scroollview];
    
    _jtView = [[ZKWellcomeView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, self.scroollview.frame.size.height) viewTyper:wellcomeViewJT];
    _jtView.controller = self;
    _jtView.delegate = self;
    [self.scroollview addSubview:_jtView];
    
    _znView = [[ZKWellcomeView alloc]initWithFrame:CGRectMake(kDeviceWidth,0 , kDeviceWidth, self.scroollview.frame.size.height) viewTyper:wellcomeViewZN];
    _znView.controller = self;
    _znView.delegate = self;
    [self.scroollview addSubview:_znView];
    
}





#pragma mark  -----ZKMainHuaTiaoViewDelegate---
-(void)selectTypeIndex:(NSInteger)index;
{
    self.index = index;
    [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.scroollview.contentOffset = CGPointMake(self.scroollview.frame.size.width*index, 0);
    } completion:^(BOOL finished) {
    }];
    
}

#pragma mark scrollViewDelegate

//减速结束   停止
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    
    int num = scrollView.contentOffset.x / self.view.frame.size.width ;
    self.index = num;
    [self.chooseView selectToIndex:num];
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.searchBar resignFirstResponder];
    
}

#pragma mark - searchBarDelegate
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    
  
    
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    if (self.index == 0)
    {
        
        [_jtView updata:searchBar.text];
    }
    else
    {
        [_znView updata:searchBar.text];
    }
    [searchBar resignFirstResponder];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
  [self.searchBar resignFirstResponder];

}
#pragma mark ZKWellcomeDelegate
- (void)scrollViewChange;
{

  [self.searchBar resignFirstResponder];
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
