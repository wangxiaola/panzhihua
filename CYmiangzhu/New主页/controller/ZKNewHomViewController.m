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

@interface ZKNewHomViewController ()<UISearchBarDelegate>

@property (nonatomic, strong) YYSearchBar *searchBar;
@property (nonatomic, strong) ZKNewHomeHeaderView *headerView;
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
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationController.navigationBar setBarTintColor:CYBColorGreen];
    [self initView];
    
}

- (void)initView
{
    self.navigationItem.titleView = self.searchBar;



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
