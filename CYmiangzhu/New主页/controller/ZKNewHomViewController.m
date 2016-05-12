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
#import "ZKNewHomeButtonTableViewCell.h"
#import "ZKNewHomeMode.h"
#import "MJRefresh.h"

static  NSString *homeIndentifierOne=@"homeCellOne";
static  NSString *homeIndentifierTow=@"homeCellTwo";

@interface ZKNewHomViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) YYSearchBar *searchBar;
@property (nonatomic, strong) ZKNewHomeHeaderView *headerView;
@property (nonatomic, strong) UITableView *homeTableView;
@property (nonatomic, strong) UIButton *navigationView;
@property (nonatomic, assign) int page;
@property (nonatomic, weak) UIImageView *errDataView;
/**
 *  标示
 */
@property (nonatomic,strong)NSString *Identifier;
/**
 *  数据
 */

@property (nonatomic, strong) NSMutableArray<ZKNewHomeMode*> *homeListData;

@end

@implementation ZKNewHomViewController

- (YYSearchBar *)searchBar
{
    if (!_searchBar) {
        
        _searchBar = [[YYSearchBar alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth-80, 60)];
        _searchBar.backgroundColor = [UIColor clearColor];
        _searchBar.placeString = @"酒店/宾馆";
        _searchBar.userInteractionEnabled = YES;
    }
    
    return _searchBar;
    
}

- (NSMutableArray<ZKNewHomeMode *> *)homeListData
{

    if (!_homeListData) {
        
        _homeListData = [NSMutableArray arrayWithCapacity:0];
    }
    return _homeListData;
}
- (UITableView *)homeTableView
{
    
    if (!_homeTableView) {
        
        _homeTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, self.view.frame.size.height) style:UITableViewStylePlain];
        _homeTableView.backgroundColor = YJCorl(249, 249, 249);
        //去掉plain样式下多余的分割线
        _homeTableView.tableFooterView = [[UIView alloc] init];
        //设置分割线左边无边距，默认是15
        _homeTableView.separatorInset = UIEdgeInsetsZero;
        
        _homeTableView.estimatedRowHeight=200; //预估行高 可以提高性能
        _homeTableView.delegate =self;
        _homeTableView.dataSource = self;
        _homeTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        
        
        [_homeTableView registerNib:[UINib nibWithNibName:@"ZKNewHomeButtonTableViewCell" bundle:nil] forCellReuseIdentifier:ZKNewHomeButtonTableViewCellID];
        
        _homeTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
        _homeTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
        
    }
    
    return _homeTableView;
    
}
- (ZKNewHomeHeaderView *)headerView
{
    
    if (!_headerView) {
        
        _headerView = [[ZKNewHomeHeaderView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, 700/3)];
        _headerView.controller = self;
        
    }
    
    return _headerView;
    
}

- (UIImageView *)errDataView
{
    
    if (_errDataView == nil) {
        UIImageView *emptyDataView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"errData"]];
        emptyDataView.center = CGPointMake(self.view.center.x, self.view.center.y +32);
        emptyDataView.userInteractionEnabled =YES;
        [self.view addSubview:emptyDataView];
        self.errDataView = emptyDataView;
        UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(loadNewData)];
        [emptyDataView addGestureRecognizer:tapGr];
        
    }
    return _errDataView;
}



-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBarTintColor:CYBColorGreen];
    self.navigationController.navigationBarHidden = NO;
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.Identifier = @"ZKNewHomViewController";
    [self initView];
    
}

- (void)initView
{
    
    
    
    self.navigationView = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 0)];
    self.navigationView.backgroundColor = [UIColor clearColor];
    [self.navigationView addTarget:self action:@selector(viewTapped) forControlEvents:UIControlEventTouchUpInside];
    
    [self.navigationView addSubview:self.searchBar];
    self.searchBar.center = self.navigationView.center;
    self.navigationItem.titleView = self.navigationView ;
    
    [self.view addSubview:self.homeTableView];
    self.homeTableView.tableHeaderView = self.headerView;
    
    [self.homeListData addObject:[ZKNewHomeMode new]];
    
    
//    [self LoadTheCached];
    
}
#pragma mark 数据请求
/****  请求方式  ******/
- (void)loadNewData
{
    self.page = 1;
    if (_errDataView) {
        [_errDataView removeFromSuperview];
        _errDataView = nil;
    }
    [self postData];
}


- (void)loadMoreData
{
    self.page++;
    [self postData];
}


-(NSMutableDictionary*)dataList:(NSInteger)index data:(NSMutableDictionary*)list;

{
    
    [list setObject:[NSNumber numberWithInteger:index] forKey:@"page"];
    [list setObject:@"15" forKey:@"rows"];
    [list setObject:@"line" forKey:@"method"];
    NSLog( @"参数  ＝  %@\n",list);
    return list;
    
}

-(void)postData;
{
    NSMutableDictionary *pic = [NSMutableDictionary dictionary];
    [ZKHttp Post:@"" params:[self  dataList:self.page data:pic] success:^(id responseObj) {
        
        NSLog(@" \n post = %@ \n ",responseObj);
        
        NSMutableArray<ZKNewHomeMode *> *dataArray = [ZKNewHomeMode objectArrayWithKeyValuesArray:responseObj[@"rows"]];
        
        
        [self dealWithDataArray:dataArray];
        [self endRefreshAccordingTotalCount:[responseObj[@"total"] intValue]];
        
        if (dataArray.count == 0 && self.page > 1) {
            self.page--;
        }
        
        [self.homeTableView reloadData];
        
        //根据数据个数判断是否要显示提示没有数据的图片
        self.errDataView.hidden = self.homeListData.count > 0;
        
    } failure:^(NSError *error) {
        
        [self endRefreshAccordingTotalCount:-1];
        //当前页码减1，当请求第一页的数据时，保持页码为1不变，跳过if语句
        if (self.page > 1) {
            self.page--;
        }
        //提示
        [SVProgressHUD showErrorWithStatus:@"网络连接错误！"];
        //根据数据个数判断是否要显示提示没有数据的图片
        self.errDataView.hidden = self.homeListData.count > 0;
        
    }];
    
}

//去缓存
- (void)LoadTheCached
{
    self.page = 1;
    NSMutableArray *cacheModels = [NSKeyedUnarchiver unarchiveObjectWithFile:[kDocumentPath stringByAppendingPathComponent:self.Identifier]];
    if (cacheModels == nil || cacheModels.count == 0) {
        [self.homeTableView.mj_header beginRefreshing];
    }else {
        self.homeListData = cacheModels;
        [self.homeTableView reloadData];
    }
}

- (void)endRefreshAccordingTotalCount:(int)totalCount
{
    if (self.page == 1) {
        [self.homeTableView.mj_header endRefreshing];
        [self.homeTableView.mj_footer resetNoMoreData];
    }else {
        
        if (totalCount != -1 && self.homeListData.count == totalCount) {
            [self.homeTableView.mj_footer endRefreshingWithNoMoreData];
        }else {
            [self.homeTableView.mj_footer endRefreshing];
        }
    }
}

- (void)dealWithDataArray:(NSMutableArray *)dataArray
{
    //第一页的时候覆盖并缓存数据，其他页的时候累加数据
    if (self.page == 1) {
        self.homeListData = dataArray;
        [NSKeyedArchiver archiveRootObject:dataArray toFile:[kDocumentPath stringByAppendingPathComponent:self.Identifier]];
    }else {
        [self.homeListData addObjectsFromArray:dataArray];
    }
    
    
}

#pragma mark table 代理

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    if (indexPath.section == 0)
    {
        
        ZKNewHomeButtonTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ZKNewHomeButtonTableViewCellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.controller = self;
        return cell;
        
    }else
    {
  

        if (indexPath.section == 1) {
            
            
            ZKNewHomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:homeIndentifierOne];
            
            if (cell == nil) {
                
                cell = [[ZKNewHomeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:homeIndentifierOne SuperViews:homecellOne];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            
            [cell setData:nil cellTyper:homecellOne];
            
            return cell;
        }else{
            
            ZKNewHomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:homeIndentifierTow];
            
            if (cell == nil) {
                
                cell = [[ZKNewHomeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:homeIndentifierTow SuperViews:homecellTow];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            
            [cell setData:nil cellTyper:homecellTow];
            
            return cell;
        }
   
    }
    
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return section == 0 ?1:2;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
//    if (indexPath.section  == 1) {
//        
//        ZKNewHomeTableViewCell *homeCell =(ZKNewHomeTableViewCell*)cell;
//        
//        [homeCell setData:nil cellTyper:homecellOne];
//        
//    }else if (indexPath.section == 2)
//    {
//    
//        ZKNewHomeTableViewCell *homeCell =(ZKNewHomeTableViewCell*)cell;
//        
//        [homeCell setData:nil cellTyper:homecellTow];
//        
//    }

    
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 8;

}

- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{

    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return indexPath.section == 0 ?100:cellHeight;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    return section == 0 ?8:36;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    if (section == 0)
    {
        
     return [UIView new];
        
    }else
    {
    
        static NSString *headerSectionID = @"HeaderFooterView";
        UITableViewHeaderFooterView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:headerSectionID];
        
        UIImageView *lefImageView;
        UILabel *lefLabel;
        
        if (headerView == nil)
        {
 
            headerView = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:headerSectionID];
            
            UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 36)];
            backView.backgroundColor = [UIColor whiteColor];
            [headerView addSubview:backView];
            
            UIImageView *ritImageView = [[UIImageView alloc]initWithFrame:CGRectZero];
            ritImageView.image = [UIImage imageNamed:@"jt_Xright"];
            [headerView addSubview:ritImageView];
            
            [ritImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.width.mas_equalTo(6);
                make.height.mas_equalTo(12);
                make.centerY.mas_equalTo(headerView.mas_centerY);
                make.right.mas_equalTo(headerView.mas_right).offset(-10);
            }];
            
            
            UIButton *buttonView = [UIButton buttonWithType:UIButtonTypeCustom];
            [buttonView setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            [buttonView setTitle:@"查看更多" forState:UIControlStateNormal];
            buttonView.titleLabel.font = [UIFont systemFontOfSize:13];
            buttonView.tag = section;
            [buttonView addTarget:self action:@selector(headerButton:) forControlEvents:UIControlEventTouchUpInside];
            [headerView addSubview:buttonView];
            
            [buttonView mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.width.mas_equalTo(60);
                make.height.mas_equalTo(20);
                make.centerY.mas_equalTo(headerView.mas_centerY);
                make.right.mas_equalTo(ritImageView.mas_left).offset(-8);
            }];
            
            lefImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
            [headerView addSubview:lefImageView];
            
            [lefImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.width.height.mas_equalTo(20);
                make.centerY.mas_equalTo(headerView.mas_centerY);
                make.left.mas_equalTo(headerView.mas_left).offset(8);
            }];
            
            
            lefLabel = [[UILabel alloc]initWithFrame:CGRectZero];
            lefLabel.font = [UIFont systemFontOfSize:13];
            lefLabel.textColor = [UIColor grayColor];
            [headerView addSubview:lefLabel];
            [lefLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(lefImageView.mas_right).offset(8);
                make.width.offset(70);
                make.centerY.mas_equalTo(headerView.mas_centerY);
            }];
           
            
            
        }
        
        NSString *str = section == 1 ? @"优惠资讯":@"旅游攻略";
        NSString *imagePath = section == 1 ? @"homeYHZX":@"homeLV";
        lefImageView.image = [UIImage imageNamed:imagePath];
        lefLabel.text = str;
        
        return headerView;
        
        
    }
    
}


#pragma mark 头部点击

-(void)viewTapped{
    
    self.navigationController.navigationBarHidden = YES;
    [self.navigationController pushViewController:[[NSClassFromString(@"ZKGlobalSearchViewController") alloc] init] animated:YES];
}

- (void)headerButton:(UIButton*)sender
{

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
