//
//  ZKMyNotesViewController.m
//  CYmiangzhu
//
//  Created by 汤亮 on 15/12/16.
//  Copyright © 2015年 WangXiaoLa. All rights reserved.
//  我的游记

#import "ZKMyNotesViewController.h"
#import "ZKWriteNotesViewController.h"
#import "ZKStrategyModel.h"
#import "ZKStrategyCell.h"
#import "MJRefresh.h"

@interface ZKMyNotesViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, weak) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray<ZKStrategyModel *> *strategyModels;

@property (nonatomic, assign) int page;

@property (nonatomic, weak) UIImageView *emptyDataView;
@end

@implementation ZKMyNotesViewController

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

- (NSMutableArray<ZKStrategyModel *> *)strategyModels
{
    if (_strategyModels== nil) {
        _strategyModels = [NSMutableArray array];
    }
    return _strategyModels;
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
    self.titeLabel.text = @"我的游记";
    self.rittBarButtonItem =[[UIButton alloc]initWithFrame:CGRectMake(kDeviceWidth-2-40, 20, 40, 40)];
    self.rittBarButtonItem.backgroundColor =[UIColor clearColor];
    self.rittBarButtonItem.titleLabel.textColor =[UIColor whiteColor];
    self.rittBarButtonItem.titleLabel.font =[UIFont systemFontOfSize:12];
    self.rittBarButtonItem.titleLabel.font =[UIFont boldSystemFontOfSize:12];
    [self.rittBarButtonItem setImage:[UIImage imageNamed:@"my_cell_4"] forState:UIControlStateNormal];
    [self.rittBarButtonItem addTarget:self action:@selector(writeTravelNote) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationBarView addSubview: self.rittBarButtonItem];
}

- (void)writeTravelNote
{
    UIStoryboard *myYoujiSB = [UIStoryboard storyboardWithName:@"MyYouji" bundle:nil];
    ZKWriteNotesViewController *writeNoteVc = [myYoujiSB instantiateInitialViewController];
    __weak typeof(self) weakSelf = self;
    writeNoteVc.succeedUploadCallback = ^{
        [weakSelf.tableView.mj_header beginRefreshing];
    };
    [self.navigationController pushViewController:writeNoteVc animated:YES];
}

- (void)readDataFromSandBox
{
    NSMutableArray *cacheModels = [NSKeyedUnarchiver unarchiveObjectWithFile:[kDocumentPath stringByAppendingPathComponent:@"TravelStrategy.data"]];
    
    if (cacheModels == nil || cacheModels.count == 0) {
        [self.tableView.mj_header beginRefreshing];
    }else {
        self.strategyModels = cacheModels;
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
    
    [tableView registerNib:[UINib nibWithNibName:@"ZKStrategyCell" bundle:nil] forCellReuseIdentifier:ZKStrategyCellID];
    
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
    params[@"method"] = @"strategylist";
    params[@"rows"] = @"20";
    params[@"page"] = [NSString stringWithFormat:@"%d", self.page];
    [ZKHttp Post:@"" params:params success:^(id responseObj) {
        
        NSMutableArray<ZKStrategyModel *> *dataArray = [ZKStrategyModel objectArrayWithKeyValuesArray:responseObj[@"rows"]];
        
        if (dataArray.count>0) {
            
            [self dealWithDataArray:dataArray];
            [self endRefreshAccordingTotalCount:[responseObj[@"total"] intValue]];
            
            if (dataArray.count == 0 && self.page > 1) {
                self.page--;
            }
            [self.tableView reloadData];
  
        }else{
        
         [self.tableView.mj_header endRefreshing];
        }
               //根据数据个数判断是否要显示提示没有数据的图片
        self.emptyDataView.hidden = self.strategyModels.count > 0;
        
    } failure:^(NSError *error) {
        
        [self endRefreshAccordingTotalCount:-1];
        //当前页码减1，当请求第一页的数据时，保持页码为1不变，跳过if语句
        if (self.page > 1) {
            self.page--;
        }
        //提示
        [SVProgressHUD showErrorWithStatus:@"请检查网络"];
        //根据数据个数判断是否要显示提示没有数据的图片
        self.emptyDataView.hidden = self.strategyModels.count > 0;
        
    }];
}

- (void)endRefreshAccordingTotalCount:(int)totalCount
{
    [self.tableView.mj_header endRefreshing];
    if (totalCount != -1 && self.strategyModels.count == totalCount) {
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    }else {
        [self.tableView.mj_footer endRefreshing];
    }
}

- (void)dealWithDataArray:(NSMutableArray *)dataArray
{
    //第一页的时候覆盖并缓存数据，其他页的时候累加数据
    if (self.page == 1) {
        self.strategyModels = dataArray;
        [NSKeyedArchiver archiveRootObject:dataArray toFile:[kDocumentPath stringByAppendingPathComponent:@"TravelStrategy.data"]];
        
    }else {
        [self.strategyModels addObjectsFromArray:dataArray];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return self.strategyModels.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZKStrategyCell *cell = [tableView dequeueReusableCellWithIdentifier:ZKStrategyCellID];
    cell.strategyModel = self.strategyModels[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 180.0 + 5.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZKStrategyModel *model = self.strategyModels[indexPath.row];
    
    NSString *str = [NSString stringWithFormat:@"desc_youji.aspx?z_isheadback=true&id=%@&z_pagetitle=%@", model.ID, model.title];
    [self jumpToWebUrl:webUrl(str)];
}

- (void)jumpToWebUrl:(NSString *)webUrl
{
    ZKBasicViewController *web = [[ZKBasicViewController alloc] init];
    web.webToUrl = [webUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    web.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:web animated:YES];
}


@end
