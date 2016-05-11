//
//  ZKInformationViewController.m
//  CYmiangzhu
//
//  Created by 汤亮 on 15/12/16.
//  Copyright © 2015年 WangXiaoLa. All rights reserved.
//

#import "ZKInformationViewController.h"
#import "ZKInformationModel.h"
#import "ZKInformationCell.h"
#import "MJRefresh.h"
#import "YYSearchBar.h"

@interface ZKInformationViewController () <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>

@property (nonatomic, weak) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray<ZKInformationModel *> *informationModels;

@property (nonatomic, assign) int page;

@property (nonatomic, weak) UIImageView *emptyDataView;

@property (nonatomic, weak) YYSearchBar *searchBar;

@property (nonatomic, copy) NSString *searchKey;

@end

@implementation ZKInformationViewController

-(id)init
{
    self =[super init];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (UIImageView *)emptyDataView
{
    if (_emptyDataView == nil) {
        UIImageView *emptyDataView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"errData"]];
        emptyDataView.center = CGPointMake(self.tableView.center.x, self.tableView.center.y - 32);
        [self.tableView addSubview:emptyDataView];
        self.emptyDataView = emptyDataView;
    }
    return _emptyDataView;
}

- (NSMutableArray<ZKInformationModel *> *)informationModels
{
    if (_informationModels == nil) {
        _informationModels = [NSMutableArray array];
    }
    return _informationModels;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupNavBar];
    [self setupTableView];
    [self readDataFromSandBox];
}

- (void)setupNavBar
{
    YYSearchBar *searchBar = [[YYSearchBar alloc] initWithFrame:CGRectMake(0, 0.0f, self.navigationBarView.frame.size.width-100, 60.0f)];
    searchBar.center =CGPointMake(self.navigationBarView.frame.size.width/2, self.navigationBarView.frame.size.height/2+5);
    searchBar.placeString = @"活动/旅游资讯";
    searchBar.keyboardType = UIKeyboardTypeDefault;
    searchBar.backgroundColor = [UIColor clearColor];
    searchBar.delegate = self;
    [self.navigationBarView addSubview:searchBar];
    self.searchBar = searchBar;
    self.searchKey = @"";
}

- (void)readDataFromSandBox
{
    NSMutableArray *cacheModels = [NSKeyedUnarchiver unarchiveObjectWithFile:[kDocumentPath stringByAppendingPathComponent:@"TravelInformation.data"]];
    
    if (cacheModels == nil || cacheModels.count == 0) {
        [self.tableView.mj_header beginRefreshing];
    }else {
        self.informationModels = cacheModels;
        [self.tableView reloadData];
    }
}

- (void)setupTableView
{
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, navigationHeghit, self.view.bounds.size.width, self.view.bounds.size.height - navigationHeghit) style:UITableViewStylePlain];
    tableView.backgroundColor = YJCorl(231, 231, 231);
    //去掉plain样式下多余的分割线
    tableView.tableFooterView = [[UIView alloc] init];
    //设置分割线左边无边距，默认是15
    tableView.separatorInset = UIEdgeInsetsZero;
    tableView.delegate = self;
    tableView.dataSource = self;
    
    tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    [tableView registerNib:[UINib nibWithNibName:@"ZKInformationCell" bundle:nil] forCellReuseIdentifier:ZKInformationCellID];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
}

- (void)loadNewData
{
    self.page = 1;
    [self loadData];
}

- (void)loadMoreData
{
    self.page++;
    [self loadData];
}

- (void)loadData
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"method"] = @"articleList";
    params[@"rows"] = @"20";
    params[@"page"] = [NSString stringWithFormat:@"%d", self.page];
    params[@"key"] = self.searchKey;
    [ZKHttp Post:@"" params:params success:^(id responseObj) {
        
        NSMutableArray<ZKInformationModel *> *dataArray = [ZKInformationModel objectArrayWithKeyValuesArray:responseObj[@"rows"]];

            [self dealWithDataArray:dataArray];
            [self endRefreshAccordingTotalCount:[responseObj[@"total"] intValue]];
            
            if (dataArray.count == 0 && self.page > 1) {
                self.page--;
            }
            [self.tableView reloadData];
       
        //根据数据个数判断是否要显示提示没有数据的图片
        self.emptyDataView.hidden = self.informationModels.count > 0;
        
    } failure:^(NSError *error) {
        
        [self endRefreshAccordingTotalCount:-1];
        //当前页码减1，当请求第一页的数据时，保持页码为1不变，跳过if语句
        if (self.page > 1) {
            self.page--;
        }
        //提示
        [SVProgressHUD showErrorWithStatus:@"请检查网络"];
        //根据数据个数判断是否要显示提示没有数据的图片
        self.emptyDataView.hidden = self.informationModels.count > 0;
        
    }];
    
}

- (void)endRefreshAccordingTotalCount:(int)totalCount
{
    [self.tableView.mj_header endRefreshing];
    if (totalCount != -1 && self.informationModels.count == totalCount) {
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    }else {
        [self.tableView.mj_footer endRefreshing];
    }
}

- (void)dealWithDataArray:(NSMutableArray *)dataArray
{
    //第一页的时候覆盖并缓存数据，其他页的时候累加数据
    if (self.page == 1) {
        self.informationModels = dataArray;
        if ([self.searchKey isEqualToString:@""]) {
            [NSKeyedArchiver archiveRootObject:dataArray toFile:[kDocumentPath stringByAppendingPathComponent:@"TravelInformation.data"]];
        }
    }else {
        [self.informationModels addObjectsFromArray:dataArray];
    }
    
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return self.informationModels.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZKInformationCell *cell = [tableView dequeueReusableCellWithIdentifier:ZKInformationCellID];
    cell.informationModel = self.informationModels[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 88;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ZKInformationModel *model = self.informationModels[indexPath.row];
    //http://192.168.2.35:8045/desc_news.aspx?z_isheadback=true&id=100282595&z_pagetitle=美轮美奂的攀枝花，一座让人流连忘返的城市
    NSString *str = [NSString stringWithFormat:@"desc_news.aspx?z_isheadback=true&id=%@&z_pagetitle=%@", model.ID, model.title];
    [self jumpToWebUrl:webUrl(str)];
}

- (void)jumpToWebUrl:(NSString *)webUrl
{
    ZKBasicViewController *web = [[ZKBasicViewController alloc] init];
    web.webToUrl = [webUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    web.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:web animated:YES];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    self.searchKey = searchBar.text;
    if (![self.tableView.mj_header isRefreshing]) {
        [self.tableView.mj_header beginRefreshing];
    }
    [searchBar resignFirstResponder];
    
    [[BaiduMobStat defaultStat] logEvent:@"search_news" eventLabel:@"分类-资讯"];
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.searchBar resignFirstResponder];
    
}

@end
