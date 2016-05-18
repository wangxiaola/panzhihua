//
//  JKBaseTableViewController.m
//  CYmiangzhu
//
//  Created by 王小腊 on 16/5/11.
//  Copyright © 2016年 WangXiaoLa. All rights reserved.
//

#import "ZKNewBaseTableViewController.h"
#import "ZKErrorView.h"
#import "MJRefreshHeader.h"
#import "MJRefreshBackFooter.h"

@interface ZKNewBaseTableViewController ()
/* 无数据时显示的图片 */
@property (nonatomic, weak) ZKErrorView *errorView;
/* 当前页码 */
@property (nonatomic, assign) NSInteger page;
@end

@implementation ZKNewBaseTableViewController

- (NSMutableArray *)models {
    if (_models == nil) {
        _models = [NSMutableArray arrayWithCapacity:0];
    }
    return _models;
}

- (NSMutableDictionary *)params
{
    if (_params == nil) {
        _params = [NSMutableDictionary dictionary];
    }
    return _params;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (self.title) {
        
        [[BaiduMobStat defaultStat] pageviewStartWithName:[NSString stringWithFormat:@"%@",self.title]];
    }
    
}

-(void)viewDidDisappear:(BOOL)animated
{
    
    [super viewDidDisappear:animated];
    
    
    if (self.title) {
        
        [[BaiduMobStat defaultStat] pageviewEndWithName:[NSString stringWithFormat:@"%@",self.title]];
    }
    
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupProperties];
    [self setupTableView];
    [self setupRefreshControl];
    [self setupErrorView];
//    [self readCacheData];
}

- (void)setupProperties
{
    // 默认需要上拉和下拉刷新
    self.needsPullDownRefreshing = YES;
    self.needsPullUpRefreshing = YES;
    // 初始第一页
    self.page = 1;
    // 请求路径
    self.URLString = @"";
}

- (void)setupTableView
{
    self.tableView.backgroundColor = YJCorl(249, 249, 249);
    //去掉plain样式下多余的分割线
    if (self.tableView.style == UITableViewStylePlain) {
        self.tableView.tableFooterView = [[UIView alloc] init];
    }
}

- (void)setupRefreshControl
{
    __weak typeof(self)wSelf = self;
    
    //是否集成上拉刷新操作
    if (self.isNeedsPullDownRefreshing) {
        self.tableView.mj_header = [MJRefreshHeader headerWithRefreshingBlock:^{
            if (self.isNeedsPullUpRefreshing) {
                wSelf.params[@"page"] = @(wSelf.page = 1);
            }
            [wSelf loadData];
        }];
    }
    //是否集成上拉刷新操作
    if (self.isNeedsPullUpRefreshing) {
        self.tableView.mj_footer = [MJRefreshFooter footerWithRefreshingBlock:^{
            wSelf.params[@"page"] = @(++wSelf.page);
            [wSelf loadData];
        }];
    }
}

- (void)setupErrorView
{
    ZKErrorView *errView = [[ZKErrorView alloc] init];
    __weak typeof(self)wSelf = self;
    errView.reloadBlock = ^{ [wSelf.tableView.mj_header beginRefreshing]; };
    errView.hidden = YES;
    [self.tableView addSubview:errView];
    self.errorView = errView;
    
    [errView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(wSelf.tableView);
        make.centerY.equalTo(wSelf.tableView).with.offset(-44);
        make.width.and.height.mas_equalTo(150);
    }];
}

- (void)readCacheData
{
    if (self.cacheFilename) {
        //有缓存时读取缓存数据
        NSMutableArray *cacheModels = [NSKeyedUnarchiver unarchiveObjectWithFile:[kDocumentPath stringByAppendingPathComponent:self.cacheFilename]];
        //缓存数据不为空时展示缓存数据
        if (cacheModels) {
            self.models = cacheModels;
            [self.tableView reloadData];
        }
    }
    //列表无数据时请求数据
    if (self.models.count == 0) {
        if (self.isNeedsPullDownRefreshing) {
            [self.tableView.mj_header beginRefreshing];
        }else {
            [self loadData];
        }
    }
}

- (void)loadData
{

    [ZKHttp Post:self.URLString params:self.params success:^(id responseObj) {
        
        if ([responseObj[@"errcode"] isEqualToString:@"00000"]) {
            [self dealWithSuccess:responseObj];
        }else {
            [self dealWithError:responseObj[@"errmsg"]];
        }
        
    } failure:^(NSError *error) {
        
           [self dealWithFailure:error];

    }];

    
}

- (void)dealWithError:(NSString *)errmsg
{
    //提示错误
    [SVProgressHUD showErrorWithStatus:errmsg];
    //停止刷新
    [self endRefreshingWithDataTotalCount:-1];
    //页面回减
    if (self.page > 1) {
        self.page--;
    }
    //根据数据个数决定显示提示状态
    [self showPromptStatus];
}

- (void)dealWithFailure:(NSError *)error
{
    //提示网络错误
    [SVProgressHUD showErrorWithStatus:@"请检查网络"];
    //根据上拉或者下拉情况停止刷新
    [self endRefreshingWithDataTotalCount:-1];
    //控制请求数据页码
    if (self.page > 1) {
        self.page--;
    }
    //根据数据个数决定显示提示状态
    [self showPromptStatus];
}

- (void)dealWithSuccess:(id)responseObject
{
    //根据上拉或者下拉情况处理请求到的最新数据
    NSMutableArray *dataArray = [self.modelsType objectArrayWithKeyValuesArray:responseObject[@"data"][@"root"]] ? : @[].mutableCopy;
    [self dealWithLatestDataArray:dataArray];
    //根据上拉或者下拉情况停止刷新
    id total = responseObject[@"data"][@"total"];
    [self endRefreshingWithDataTotalCount:total ? [total integerValue] : -1];
    //控制请求数据页码
    if (dataArray.count == 0 && self.page > 1) {
        self.page--;
    }
    //根据数据个数决定显示提示状态
    [self showPromptStatus];
}

- (void)dealWithLatestDataArray:(NSMutableArray *)dataArray
{
    if (self.page == 1) {
        //下拉刷新时覆盖数据
        self.models = dataArray;
        //self.cacheFilename有值时表示需要缓存，否则无缓存
        if (self.cacheFilename) {
            [NSKeyedArchiver archiveRootObject:dataArray toFile:[kDocumentPath stringByAppendingPathComponent:self.cacheFilename]];
        }
    }else {
        //上拉刷新时累加数据
        [self.models addObjectsFromArray:dataArray];
    }
    //数据处理后刷新表格
    [self.tableView reloadData];
}

- (void)showPromptStatus
{
    //根据数据个数判断是否要显示提示没有数据的图片
    self.errorView.hidden = self.models.count > 0;
    //根据数据个数判断是否要显示尾部刷新控件
    self.tableView.mj_footer.hidden = self.models.count == 0;
}

- (void)endRefreshingWithDataTotalCount:(NSInteger)dataTotalCount
{
    // 停止头部刷新
    [self.tableView.mj_header endRefreshing];
    // 第一页时重置尾部刷新状态
    if (self.page == 1) {
        [self.tableView.mj_footer resetNoMoreData];
    }
    // 如果数据个数达到总数则尾部显示已经加载完毕，否则直接停止刷新
    if (self.models.count == dataTotalCount) {
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    }else {
        [self.tableView.mj_footer endRefreshing];
    }
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.models.count;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
}

@end
