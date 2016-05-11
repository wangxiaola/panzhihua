//
//  ZKNewHomViewController.m
//  CYmiangzhu
//
//  Created by 王小腊 on 16/5/11.
//  Copyright © 2016年 WangXiaoLa. All rights reserved.
//

#import "ZKNewHomViewController.h"
#import "YYSearchBar.h"
#import "ZKNewHomeHeaderView.h"
#import "ZKNewHomeTableViewCell.h"

@interface ZKNewHomViewController ()<UISearchBarDelegate>

@property (nonatomic, strong) YYSearchBar *searchBar;
@property (nonatomic, strong) ZKNewHomeHeaderView *headerView;
@property (nonatomic, strong) UITableView *homeTableView;


@end

@implementation ZKNewHomViewController

- (YYSearchBar *)searchBar
{
    if (!_searchBar) {
        
        _searchBar = [[YYSearchBar alloc] initWithFrame:CGRectZero];
        _searchBar.backgroundColor = [UIColor clearColor];
        _searchBar.placeString = @"景点地名/酒店";
        _searchBar.delegate = self;

    }
    
    return _searchBar;

}
- (UITableView *)homeTableView
{

    if (!_homeTableView) {
        
        _homeTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, self.view.frame.size.height) style:UITableViewStylePlain];
        _homeTableView.backgroundColor = YJCorl(231, 231, 231);
        //去掉plain样式下多余的分割线
        _homeTableView.tableFooterView = [[UIView alloc] init];
        //设置分割线左边无边距，默认是15
        _homeTableView.separatorInset = UIEdgeInsetsZero;

        _homeTableView.estimatedRowHeight=200; //预估行高 可以提高性能
        _homeTableView.delegate =self;
        _homeTableView.dataSource = self;
        _homeTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
//        [_homeTableView registerClass: forCellReuseIdentifier:<#(nonnull NSString *)#>];

        
    }
    
    return _homeTableView;

}
- (ZKNewHomeHeaderView *)headerView
{

    if (!_headerView) {
        
        _headerView = [[ZKNewHomeHeaderView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, 800/3)];
        _headerView.conten = self;
        
    }
    
    return _headerView;

}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationController.navigationBar setBarTintColor:CYBColorGreen];
    [self initView];
    
}

- (void)initView
{
    self.navigationItem.titleView = self.searchBar;

    [self.view addSubview:self.homeTableView];
    self.homeTableView.tableHeaderView = self.headerView;
    

}

#pragma mark _searchBar

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    
    [self.navigationController pushViewController:[[NSClassFromString(@"ZKGlobalSearchViewController") alloc] init] animated:YES];
    
    return NO;
}


-(void)viewTapped:(UITapGestureRecognizer*)tapGr{
    
    [self.searchBar   resignFirstResponder];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar;

{
    
    [self.searchBar   resignFirstResponder];
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    
    [self.searchBar   resignFirstResponder];
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
