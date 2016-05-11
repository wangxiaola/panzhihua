//
//  ZKSceneryTicketViewController.m
//  CYmiangzhu
//
//  Created by 汤亮 on 15/12/9.
//  Copyright © 2015年 WangXiaoLa. All rights reserved.
//

#import "ZKSceneryTicketViewController.h"
#import "MJRefresh.h"
#import "ZKSceneryTicketCell.h"
#import "ZKSceneryTicketModel.h"
#import "ZKticketListViewController.h"

@interface ZKSceneryTicketViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray<ZKSceneryTicketModel *> *sceneryTicketModels;

@property (nonatomic, assign) int page;

@property (nonatomic, weak) UIImageView *emptyDataView;
@end

@implementation ZKSceneryTicketViewController

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

- (NSMutableArray<ZKSceneryTicketModel *> *)sceneryTicketModels
{
    if (_sceneryTicketModels == nil) {
        _sceneryTicketModels = [NSMutableArray array];
    }
    return _sceneryTicketModels;
}


-(id)init
{
    self =[super init];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.titeLabel.text = @"景区门票";
    [self setupTableView];
    [self readDataFromSandBox];
}

- (void)readDataFromSandBox
{
    NSMutableArray *cacheModels = [NSKeyedUnarchiver unarchiveObjectWithFile:[kDocumentPath stringByAppendingPathComponent:@"ScneryTicket.data"]];
    
    if (cacheModels == nil || cacheModels.count == 0) {
        [self.tableView.mj_header beginRefreshing];
    }else {
        self.sceneryTicketModels = cacheModels;
        [self.tableView reloadData];
    }
}

- (void)setupTableView
{
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, navigationHeghit, self.view.bounds.size.width, self.view.bounds.size.height - navigationHeghit) ];
    tableView.backgroundColor = YJCorl(231, 231, 231);
    //去掉plain样式下多余的分割线
    tableView.tableFooterView = [[UIView alloc] init];
    //设置分割线左边无边距，默认是15
    tableView.separatorInset = UIEdgeInsetsZero;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.rowHeight = 180;
    tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    
    [tableView registerNib:[UINib nibWithNibName:@"ZKSceneryTicketCell" bundle:nil] forCellReuseIdentifier:ZKSceneryTicketCellID];
    
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
    params[@"method"] = @"resoureList";
    params[@"type"] = @"scenery";
    params[@"rows"] = @"10";
    params[@"page"] = [NSString stringWithFormat:@"%d", self.page];
    [ZKHttp Post:@"" params:params success:^(id responseObj) {
        
        NSMutableArray<ZKSceneryTicketModel *> *dataArray = [ZKSceneryTicketModel objectArrayWithKeyValuesArray:responseObj[@"rows"]];
            
            [self dealWithDataArray:dataArray];
            [self endRefreshAccordingTotalCount:[responseObj[@"total"] intValue]];
            
            if (dataArray.count == 0 && self.page > 1) {
                self.page--;
            }
            [self.tableView reloadData];
  
              //根据数据个数判断是否要显示提示没有数据的图片
        self.emptyDataView.hidden = self.sceneryTicketModels.count > 0;
        
    } failure:^(NSError *error) {
        
        [self endRefreshAccordingTotalCount:-1];
        //当前页码减1，当请求第一页的数据时，保持页码为1不变，跳过if语句
        if (self.page > 1) {
            self.page--;
        }
        //提示
        [SVProgressHUD showErrorWithStatus:@"请检查网络"];
        //根据数据个数判断是否要显示提示没有数据的图片
        self.emptyDataView.hidden = self.sceneryTicketModels.count > 0;
        
    }];
}

- (void)endRefreshAccordingTotalCount:(int)totalCount
{
    [self.tableView.mj_header endRefreshing];
    if (totalCount != -1 && self.sceneryTicketModels.count == totalCount) {
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    }else {
        [self.tableView.mj_footer endRefreshing];
    }
}

- (void)dealWithDataArray:(NSMutableArray *)dataArray
{
    //第一页的时候覆盖并缓存数据，其他页的时候累加数据
    if (self.page == 1) {
        
        self.sceneryTicketModels = dataArray;
        [NSKeyedArchiver archiveRootObject:dataArray toFile:[kDocumentPath stringByAppendingPathComponent:@"ScneryTicket.data"]];
    }else {
        [self.sceneryTicketModels addObjectsFromArray:dataArray];
    }
    
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return self.sceneryTicketModels.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZKSceneryTicketCell *cell = [tableView dequeueReusableCellWithIdentifier:ZKSceneryTicketCellID];
    cell.sceneryTicketModel = self.sceneryTicketModels[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 180.0 + 5.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZKSceneryTicketModel *model = self.sceneryTicketModels[indexPath.row];
    
    ZKticketListViewController *vc =[[ZKticketListViewController alloc]init];
    [vc updata:model.ID name:model.name];
    [self.navigationController pushViewController:vc animated:YES];


}

@end
