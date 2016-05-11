//
//  ZKComplaintsListViewController.m
//  CYmiangzhu
//
//  Created by 王小腊 on 15/12/18.
//  Copyright © 2015年 WangXiaoLa. All rights reserved.
//

#import "ZKComplaintsListViewController.h"
#import "ZKComplaintsListMode.h"
#import "ZKComplaintsListCell.h"
#import "MJRefresh.h"
#import "ZKComplaintsViewController.h"

@interface ZKComplaintsListViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (retain, nonatomic)  UITableView *tableview;

@property (strong, nonatomic) NSMutableArray<ZKComplaintsListMode *> *listData;

@property (nonatomic, assign) int page;

@property (nonatomic, weak) UIView *tousuView;

@end

@implementation ZKComplaintsListViewController
-(instancetype)init
{
    self =[super init ];
    if (self) {
        
        self.hidesBottomBarWhenPushed =YES;
    }
    return self;
}

- (NSMutableArray<ZKComplaintsListMode *> *)listData
{
    if (_listData== nil) {
        _listData = [NSMutableArray array];
    }
    return _listData;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupNav];
    [self initView];
}

- (void)setupNav
{
    self.titeLabel.text =@"我的投诉";
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

#pragma mark 初始化视图
-(void)initView
{

    _tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, navigationHeghit, self.view.bounds.size.width, self.view.bounds.size.height - navigationHeghit ) style:UITableViewStylePlain];
    _tableview.separatorStyle = NO;
    _tableview.backgroundColor = YJCorl(231, 231, 231);
    _tableview.dataSource =self;
    _tableview.delegate =self;
    //去掉plain样式下多余的分割线
    _tableview.tableFooterView = [[UIView alloc] init];
    //设置分割线左边无边距，默认是15
    _tableview.separatorInset = UIEdgeInsetsZero;
    _tableview.estimatedRowHeight=10; //预估行高 可以提高性能
    _tableview.rowHeight = 100;
    _tableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    _tableview.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    [_tableview registerNib:[UINib nibWithNibName:@"ZKComplaintsListCell" bundle:nil] forCellReuseIdentifier:ZKComplaintsListCellID];
    [self.view addSubview:_tableview];
    
    UIView *fotview =[[UIView alloc]initWithFrame:CGRectMake(0, kDeviceHeight-60, kDeviceWidth, 60)];
    fotview.backgroundColor =[UIColor clearColor];
    [self.view addSubview:fotview];
    
    UIButton *tsBtton =[[UIButton alloc]initWithFrame:CGRectMake(20,15, kDeviceWidth-40, 30)];
    tsBtton.layer.masksToBounds =YES;
    tsBtton.layer.cornerRadius =8;
    tsBtton.backgroundColor =YJCorl(48, 192, 163);
    [tsBtton setTitle:@"写投诉" forState:0];
    tsBtton.titleLabel.font =[UIFont systemFontOfSize:14];
    [tsBtton setTitleColor:[UIColor whiteColor] forState:0];
    [tsBtton addTarget:self action:@selector(xtsbuttonClick) forControlEvents:UIControlEventTouchUpInside];
    [fotview addSubview:tsBtton];
    self.tousuView = fotview;
    
    self.page =1;
    [self readDataFromSandBox];
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

- (void)updateTousuFrame
{
    if (self.listData.count * 110 >= kDeviceHeight-navigationHeghit) {
        
        [UIView animateWithDuration:0.35 animations:^{
            
            self.tableview.tableFooterView = nil;
            self.tableview.frame =CGRectMake(0, navigationHeghit, kDeviceWidth, TabelHeghit-60);
            self.tousuView.frame = CGRectMake(0, self.view.frame.size.height - 60, kDeviceWidth, 60);
            [self.view addSubview:self.tousuView];
        }];

    }else {
        
        [UIView animateWithDuration:0.35 animations:^{
            
            self.tableview.frame =CGRectMake(0, navigationHeghit, kDeviceWidth, TabelHeghit);
            self.tableview.tableFooterView =self.tousuView;
        }];
    }
}

#pragma mark  数据请求
- (void)loadData
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"method"] = @"myComplaints";
    params[@"rows"] = @"15";
    params[@"memberid"] = [ZKUserInfo sharedZKUserInfo].ID;
    params[@"page"] = [NSString stringWithFormat:@"%d", self.page];

    [ZKHttp Post:@"" params:params success:^(id responseObj) {
        
        NSLog( @" ---  %@",responseObj);
        
        NSMutableArray<ZKComplaintsListMode *> *dataArray = [ZKComplaintsListMode objectArrayWithKeyValuesArray:responseObj[@"rows"]];
        
        if (dataArray.count>0) {
            
            [self dealWithDataArray:dataArray];
            [self endRefreshAccordingTotalCount:[responseObj[@"total"] intValue]];
            
            if (dataArray.count == 0 && self.page > 1) {
                self.page--;
            }
            [self.tableview reloadData];
            
            [self updateTousuFrame];
        }else{
        
            [self.tableview.mj_header endRefreshing];
            
        }

        
    } failure:^(NSError *error) {
        
        [self endRefreshAccordingTotalCount:-1];
        //当前页码减1，当请求第一页的数据时，保持页码为1不变，跳过if语句
        if (self.page > 1) {
            self.page--;
        }
        //提示
        [SVProgressHUD showErrorWithStatus:@"请检查网络"];
        [self updateTousuFrame];
        
    }];
}


#pragma mark  数据处理
- (void)readDataFromSandBox
{

    [self.tableview.mj_header beginRefreshing];

}

- (void)endRefreshAccordingTotalCount:(int)totalCount
{
    [self.tableview.mj_header endRefreshing];
    if (totalCount != -1 && self.listData.count == totalCount) {
        [self.tableview.mj_footer endRefreshingWithNoMoreData];
    }else {
        [self.tableview.mj_footer endRefreshing];
    }
}

- (void)dealWithDataArray:(NSMutableArray *)dataArray
{
    //第一页的时候覆盖并缓存数据，其他页的时候累加数据
    if (self.page == 1) {
        self.listData = dataArray;
        
    }else {
        [self.listData addObjectsFromArray:dataArray];
    }
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  1;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    return self.listData.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ZKComplaintsListCell *cell = [tableView dequeueReusableCellWithIdentifier:ZKComplaintsListCellID];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.listMode = self.listData[indexPath.section];
    return cell;
}

//哪几行可以编辑
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return YES;
}


//继承该方法时,左右滑动会出现删除按钮(自定义按钮),点击按钮时的操作
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (editingStyle != UITableViewCellEditingStyleDelete) { return; }
    
    ZKComplaintsListMode *list =[self.listData objectAtIndex:indexPath.section];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"method"] = @"messageResouceDel";
    params[@"id"] = list.ID;
    params[@"memberid"] = [ZKUserInfo sharedZKUserInfo].ID;
    

    [ZKHttp Post:@"" params:params success:^(id responseObj) {
        
        [self.listData removeObjectAtIndex:indexPath.section];
        
        [tableView beginUpdates];
        
       [tableView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationLeft];
       [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]withRowAnimation:UITableViewRowAnimationLeft];
     
       [tableView endUpdates];
     
        
    } failure:^(NSError *error) {
  
        //提示
        [SVProgressHUD showErrorWithStatus:@"请检查网络"];
        
        
    }];
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    return UITableViewAutomaticDimension;
}
-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    return [[UIView alloc]init];
}

#pragma mark - UITableViewDelegate

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{

    return @"删除";
}

//当 tableview 为 editing 时,左侧按钮的 style
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    
    
    
}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

-(void)xtsbuttonClick
{
    ZKComplaintsViewController *tousuVc = [[ZKComplaintsViewController alloc] init];
    __weak typeof(self) weakSelf = self;
    tousuVc.succeedTousu = ^{
        [weakSelf.tableview.mj_header beginRefreshing];
    };
    [self.navigationController pushViewController:tousuVc animated:YES];
    
}


@end
