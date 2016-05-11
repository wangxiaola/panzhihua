//
//  ZKclassificationViewController.m
//  CYmiangzhu
//
//  Created by Daqsoft-Mac on 15/8/11.
//  Copyright (c) 2015年 WangXiaoLa. All rights reserved.
//

#import "ZKclassificationViewController.h"
#import "YYSearchBar.h"
#import "ZKfeileiList.h"
#import "ZKfeileiTableViewCell.h"
#import "ZKCategoryTool.h"
#import "ZKCategory.h"
#import "ZKBasicViewController.h"
#import "ZKAdvertisement.h"

#define IMAGEHEIGHT     125.0f

@interface ZKclassificationViewController ()<UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate>

{
    
    YYSearchBar *_searchBar;
    
    UITableView *_tabelView;
    
    NSArray *dataArray;
    
    UIImageView *_zoomImageView;
    
    UIButton *headBUtton;
    
}

@property (nonatomic, strong) ZKAdvertisement *advertisement;
@end

@implementation ZKclassificationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.leftBarButtonItem removeFromSuperview];
    [self.titeLabel removeFromSuperview];
    dataArray = [NSMutableArray arrayWithCapacity:0];
    
    //取出本地存储的活动数据模型
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"advertisement.data"]];
    self.advertisement = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
    
    [self initView];
    
    dataArray = [ZKCategoryTool categories];
    
    [[BaiduMobStat defaultStat] logEvent:@"search_key" eventLabel:@"分类-全局搜索"];
    
}

-(void)initView
{
    
    _searchBar = [[YYSearchBar alloc] initWithFrame:CGRectMake(0, 0.0f, self.navigationBarView.frame.size.width-100, 60.0f)];
    _searchBar.center =CGPointMake(self.navigationBarView.frame.size.width/2, self.navigationBarView.frame.size.height/2+5);
    _searchBar.placeString = @"景点地名/酒店";
    _searchBar.backgroundColor = [UIColor clearColor];
    _searchBar.delegate = self;
    [self.navigationBarView addSubview:_searchBar];
    
    _tabelView =[[UITableView alloc]initWithFrame:CGRectMake(0, navigationHeghit, self.view.frame.size.width, TabelHeghit-self.tabBarController.tabBar.frame.size.height)];
    _tabelView.separatorStyle=UITableViewCellSeparatorStyleNone;
    _tabelView.showsVerticalScrollIndicator =NO;
    _tabelView.delegate =self;
    _tabelView.dataSource =self;
    
    [self.view addSubview:_tabelView];
    
    
    
    if (self.advertisement.topimages != nil) {
        _tabelView.contentInset = UIEdgeInsetsMake(IMAGEHEIGHT, 0, 0, 0);
        //添加头部
        _zoomImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, -IMAGEHEIGHT, self.view.frame.size.width, IMAGEHEIGHT)];
        [ZKUtil UIimageView:_zoomImageView NSSting:[NSString stringWithFormat:@"%@%@", imageUrlPrefix, self.advertisement.topimages] duImage:@"zz"];
        
        //        _zoomImageView.contentMode = UIViewContentModeScaleAspectFill;
        [_tabelView addSubview:_zoomImageView];
        
        headBUtton =[[UIButton alloc]initWithFrame:CGRectMake(0, navHeight, kDeviceWidth, IMAGEHEIGHT)];
        headBUtton.backgroundColor =[UIColor clearColor];
        [headBUtton addTarget:self action:@selector(tapAD) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:headBUtton];
        
        
    }
    
    
    UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    tapGr.cancelsTouchesInView =NO;
    [self.view addGestureRecognizer:tapGr];
    
}


- (void)tapAD
{
    ZKBasicViewController *web = [[ZKBasicViewController alloc] init];
    
    NSString *url = nil;
    if ([self.advertisement.name rangeOfString:@"?"].location != NSNotFound) {
        url = [self.advertisement.adAddress stringByAppendingString:[NSString stringWithFormat:@"&z_pagetitle=%@", self.advertisement.name]];
    }else{
        url = [self.advertisement.adAddress stringByAppendingString:[NSString stringWithFormat:@"?z_pagetitle=%@", self.advertisement.name]];
    }
    web.webToUrl = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [self.navigationController pushViewController:web animated:YES];
}



#pragma mark _searchBar

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    
 [self.navigationController pushViewController:[[NSClassFromString(@"ZKGlobalSearchViewController") alloc] init] animated:YES];
    
    return NO;
}


-(void)viewTapped:(UITapGestureRecognizer*)tapGr{
    
    [_searchBar   resignFirstResponder];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar;

{
    
    [_searchBar   resignFirstResponder];
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    
    [_searchBar   resignFirstResponder];
}

- (void)jumpToWebUrl:(NSString *)webUrl
{
    ZKBasicViewController *web = [[ZKBasicViewController alloc] init];
    web.webToUrl = webUrl;
    web.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:web animated:YES];
}

#pragma mark table代理

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    
    float pc =-_tabelView.contentOffset.y;
    
    headBUtton.frame =CGRectMake(0, navHeight,kDeviceWidth, pc);
    
    CGFloat y = scrollView.contentOffset.y; //如果有导航控制器，这里应该加上导航控制器的高度64
    if (y< -IMAGEHEIGHT) {
        CGRect frame = _zoomImageView.frame;
        frame.origin.y = y;
        frame.size.height = -y;
        _zoomImageView.frame = frame;
    }
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    
    return dataArray.count;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    ZKfeileiTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"ZKfeileiTableViewCell" owner:nil options:nil];
        cell = [array lastObject];
        
        UIView *lin =[[UIView alloc]initWithFrame:CGRectMake(5, 59, self.view.frame.size.width-5, 0.4)];
        lin.backgroundColor =TabelBackCorl;
        [cell addSubview:lin];
        
    }
    
    if (dataArray.count>0) {
        
        [cell updata:[dataArray objectAtIndex:indexPath.row]];
        
    }
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ZKCategory *category = dataArray[indexPath.row];
    
    
    NSString *webUrl = category.webUrl;
    NSString *controller = category.controller;
    
    
    if (webUrl.length == 0 && controller.length ==0) {
        [self.view makeToast:@"暂未开放" duration:1 position:nil];
        return;
    }
    
    if (webUrl.length == 0 && controller.length > 0) {
        
        Class controllClass = NSClassFromString(controller);
        
        UIViewController *vc = [[controllClass alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    if (webUrl.length>0 && controller.length == 0) {
        
        webUrl = [webUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        if (indexPath.row == 7) {
            [self jumpToWebUrl:webUrl1(webUrl)];
            return;
        }
        
        [self jumpToWebUrl:webUrl(webUrl)];
    }
    
}





@end
