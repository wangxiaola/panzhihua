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
#import "ZKInformationModel.h"
#import "ZKStrategyModel.h"
#import "MJRefresh.h"

static  NSString *homeIndentifierOne=@"homeCellOne";
static  NSString *homeIndentifierTow=@"homeCellTwo";

@interface ZKNewHomViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) YYSearchBar *searchBar;
@property (nonatomic, strong) ZKNewHomeHeaderView *headerView;
@property (nonatomic, strong) UITableView *homeTableView;
@property (nonatomic, strong) UIButton *navigationView;
@property (nonatomic, assign) NSInteger pag;
/**
 *  数据
 */

@property (nonatomic, strong) NSMutableArray<ZKInformationModel*> *homeListData;
@property (nonatomic, strong) NSMutableArray<ZKStrategyModel *> *strategyModels;

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

- (NSMutableArray<ZKStrategyModel *> *)strategyModels
{
    if (_strategyModels== nil) {
        _strategyModels = [NSMutableArray array];
    }
    return _strategyModels;
}


- (NSMutableArray<ZKInformationModel *> *)homeListData
{
    
    if (!_homeListData) {
        
        _homeListData = [NSMutableArray arrayWithCapacity:0];
    }
    return _homeListData;
}
- (UITableView *)homeTableView
{
    
    if (!_homeTableView) {
        
        _homeTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _homeTableView.backgroundColor = YJCorl(249, 249, 249);
        //去掉plain样式下多余的分割线
        _homeTableView.tableFooterView = [[UIView alloc] init];
        //设置分割线左边无边距，默认是15
        _homeTableView.separatorInset = UIEdgeInsetsZero;
        
        _homeTableView.estimatedRowHeight = cellHeight; //预估行高 可以提高性能
        _homeTableView.delegate =self;
        _homeTableView.dataSource = self;
        _homeTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        
        _homeTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(contenPost)];
        
        [_homeTableView registerNib:[UINib nibWithNibName:@"ZKNewHomeButtonTableViewCell" bundle:nil] forCellReuseIdentifier:ZKNewHomeButtonTableViewCellID];
        
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
    
    [self loadNewOne];
    [self loadNewTow];
    
}
#pragma mark 数据请求

- (void)contenPost
{
    self.pag = 0;
    [SVProgressHUD showWithStatus:@"加载中..."];
    [self loadNewOne];
    [self loadNewTow];
}
/****  请求方式  ******/
- (void)loadNewOne
{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"method"] = @"articleList";
    params[@"rows"] = @"2";
    params[@"page"] = @1;
    
    [ZKHttp Post:@"" params:params success:^(id responseObj) {
        
        [self dismms];
        
        self.homeListData = [ZKInformationModel objectArrayWithKeyValuesArray:responseObj[@"rows"]];
        [self.homeTableView reloadData];
        
        NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:1];
        [self.homeTableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
        
        
    } failure:^(NSError *error) {
        
      [self errdismms];
    }];
    
    
}


- (void)loadNewTow
{

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"method"] = @"strategylist";
    params[@"rows"] = @"2";
    params[@"page"] = @1;
    [ZKHttp Post:@"" params:params success:^(id responseObj) {
        [self dismms];
        self.strategyModels = [ZKStrategyModel objectArrayWithKeyValuesArray:responseObj[@"rows"]];
        NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:2];
        [self.homeTableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
        
        
    } failure:^(NSError *error) {
        
        [self errdismms];
        
    }];
    
    
}
- (void)errdismms
{
    if (self.pag >0) {
        self.pag = 0;
        [SVProgressHUD dismissWithError:@"网络错误"];
        [self.homeTableView.mj_header endRefreshing];
    }

}
- (void)dismms
{

    self.pag ++;
    if (self.pag == 2) {
        self.pag = 0;
        [SVProgressHUD dismissWithSuccess:@"加载完毕"];
        [self.homeTableView.mj_header endRefreshing];
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
            
            return cell;
        }else{
            
            ZKNewHomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:homeIndentifierTow];
            
            if (cell == nil) {
                
                cell = [[ZKNewHomeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:homeIndentifierTow SuperViews:homecellTow];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            
            
            return cell;
        }
        
    }
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 1)
    {
        
        ZKInformationModel *model = self.homeListData[indexPath.row];
        
        NSString *str = [NSString stringWithFormat:@"desc_news.aspx?z_isheadback=true&id=%@&z_pagetitle=%@", model.ID, model.title];
        [self jumpToWebUrl:webUrl(str)];
        
    }
    else if (indexPath.section == 2)
    {
        
        ZKStrategyModel *model = self.strategyModels[indexPath.row];
        
        NSString *str = [NSString stringWithFormat:@"desc_youji.aspx?z_isheadback=true&id=%@&z_pagetitle=%@", model.ID, model.title];
        [self jumpToWebUrl:webUrl(str)];
        
    }
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (section == 0)
    {
        
        return 1;
    }
    else if (section == 1)
    {
        
        return self.homeListData.count;
    }
    else if (section == 2)
    {
        
        return self.strategyModels.count;
    }
    else{
        
        return 0;
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    if (indexPath.section  == 1)
    {
        
        ZKNewHomeTableViewCell *homeCell =(ZKNewHomeTableViewCell*)cell;
        
        homeCell.dataOne = self.homeListData[indexPath.row];
        
    }
    else if (indexPath.section == 2)
    {
        
        ZKNewHomeTableViewCell *homeCell =(ZKNewHomeTableViewCell*)cell;
        
        homeCell.dataTow = self.strategyModels[indexPath.row];
        
        
    }
    
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 8;
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 0)
    {
        
        return 100;
    }
    else
    {
        
        return cellHeight;
    }
    
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    return section == 0 ?8:36;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    if (section == 0)
    {
        
        return nil;
        
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
        
        
        NSString *str = section == 2 ? @"优惠资讯":@"旅游攻略";
        NSString *imagePath = section == 2 ? @"homeYHZX":@"homeLV";
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
    if (sender.tag == 1)
    {
        
        /*** 旅游攻略 ***/
        [[BaiduMobStat defaultStat] logEvent:@"home_go_strategy" eventLabel:@"首页-攻略 "];
        self.navigationController.navigationBarHidden = YES;
        [self.navigationController pushViewController:[[NSClassFromString(@"ZKStrategyViewController") alloc]init] animated:YES];
        
        
    }
    else
    {
        /*** 旅游资讯 ***/
        [self.navigationController pushViewController:[[NSClassFromString(@"ZKInformationViewController") alloc]init] animated:YES];
        self.navigationController.navigationBarHidden = YES;
        [[BaiduMobStat defaultStat] logEvent:@"home_go_news" eventLabel:@"首页-资讯"];
        
        
    }
}

- (void)jumpToWebUrl:(NSString *)webUrl
{
    ZKBasicViewController *web = [[ZKBasicViewController alloc] init];
    web.webToUrl = [webUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    web.hidesBottomBarWhenPushed = YES;
    self.navigationController.navigationBarHidden = YES;
    [self.navigationController pushViewController:web animated:YES];
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
