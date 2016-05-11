//
//  ZKGlobalSearchViewController.m
//  CYmiangzhu
//
//  Created by 王小腊 on 16/3/28.
//  Copyright © 2016年 WangXiaoLa. All rights reserved.
//

#import "ZKGlobalSearchViewController.h"
#import "MJRefresh.h"
#import "YYSearchBar.h"
#import "ZKGlobalSearchMode.h"
#import "ZKGlobalSearchTableViewCell.h"
#import "ZKscenicSpotList.h"

#import "ZKHotelDetailViewController.h" //酒店住宿
#import "ZKGoodsDetailsViewController.h" //特色美食
#import "ZKCharacteristicsViewController.h" //特色购物
#import "ZKentertainmentViewController.h" //休闲娱乐
#import "ZKticketListViewController.h" //景区门票



@interface ZKGlobalSearchViewController ()<UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, assign) int page;

@property (nonatomic,retain)UITableView *tableView;
@property (nonatomic, weak) UIImageView *errDataView;
/**
 *  标示
 */
@property (nonatomic,strong)NSString *Identifier;

@property (strong, nonatomic) YYSearchBar *searchBar;
/**
 *  搜索默认名
 */
@property (strong, nonatomic) NSString *searchName;

/**
 *  数据
 */

@property (nonatomic, strong) NSMutableArray<ZKGlobalSearchMode*> *listData;

@end

@implementation ZKGlobalSearchViewController

-(id)init
{
    self = [super init];
    
    if (self) {
        
        self.hidesBottomBarWhenPushed = YES;
    }
    
    return self;

}

- (NSMutableArray<ZKGlobalSearchMode *> *)listData
{
    if (_listData == nil) {
        
        _listData = [NSMutableArray array];
        
    }
    return _listData;
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


- (YYSearchBar *)searchBar
{
    if (_searchBar == nil) {
        
        _searchBar = [[YYSearchBar alloc] initWithFrame:CGRectMake(0, 0.0f, self.navigationBarView.frame.size.width-100, 60.0f)];
        _searchBar.center =CGPointMake(self.navigationBarView.frame.size.width/2, self.navigationBarView.frame.size.height/2+5);
        _searchBar.backgroundColor = [UIColor clearColor];
        _searchBar.delegate = self;
        
    }
    return _searchBar;
    
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationBarView addSubview:self.searchBar];

    [[BaiduMobStat defaultStat] logEvent:@"btn_search" eventLabel:@"搜索"];
     self.searchBar.placeString = @"全局搜索";
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, navigationHeghit, self.view.bounds.size.width, self.view.bounds.size.height - navigationHeghit) style:UITableViewStylePlain];
    _tableView.backgroundColor = YJCorl(231, 231, 231);
    //去掉plain样式下多余的分割线
    _tableView.tableFooterView = [[UIView alloc] init];
    //设置分割线左边无边距，默认是15
    _tableView.separatorInset = UIEdgeInsetsZero;
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    _tableView.estimatedRowHeight=90; //预估行高 可以提高性能
    _tableView.rowHeight = 90;
    [self.view addSubview:_tableView];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"ZKGlobalSearchTableViewCell" bundle:nil] forCellReuseIdentifier:ZKGlobalSearchCellID];
    
    self.errDataView.hidden = NO;
}

#pragma mark  数据请求

-(NSMutableDictionary*)dataList:(NSInteger)index data:(NSMutableDictionary*)list;

{
    NSString *key = nil;
    
    if (_searchBar.text.length ==0) {
        
        key = @"";
    }else{
        
        key =_searchBar.text;
    }

    [list setObject:@"search" forKey:@"method"];

    [list setObject:[NSNumber numberWithInteger:index] forKey:@"page"];
    [list setObject:@"20" forKey:@"rows"];
    [list setObject:key forKey:@"keyword"];
    
    NSLog( @"参数  ＝  %@\n",list);
    return list;
    
}
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


-(void)postData;
{
    [SVProgressHUD showWithStatus:@"搜索中..."];
    
    NSMutableDictionary *pic = [NSMutableDictionary dictionary];
    [ZKHttp Post:@"" params:[self  dataList:self.page data:pic] success:^(id responseObj) {
        
        NSLog(@" \n post = %@ \n ",responseObj);
        
        NSMutableArray<ZKGlobalSearchMode *> *dataArray = [ZKGlobalSearchMode objectArrayWithKeyValuesArray:responseObj[@"rows"]];
        
        
        [self dealWithDataArray:dataArray];
        [self endRefreshAccordingTotalCount:[responseObj[@"total"] intValue]];
        
        if (dataArray.count == 0 && self.page > 1) {
            self.page--;
        }
        [SVProgressHUD dismiss];
        
        [self.tableView reloadData];
        
        //根据数据个数判断是否要显示提示没有数据的图片
        self.errDataView.hidden = self.listData.count > 0;
        
    } failure:^(NSError *error) {
        
        [self endRefreshAccordingTotalCount:-1];
        
        //当前页码减1，当请求第一页的数据时，保持页码为1不变，跳过if语句
        if (self.page > 1) {
            self.page--;
        }
        //提示
        [SVProgressHUD dismissWithError:@"网络连接错误！"];
        //根据数据个数判断是否要显示提示没有数据的图片
        self.errDataView.hidden = self.listData.count > 0;
        
    }];
    
}



#pragma mark - searchBarDelegate
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    
    if (searchText.length == 0) {
        
        self.page = 1;
        [self.listData removeAllObjects];
        self.errDataView.hidden = NO;
        [self.tableView reloadData];

        [searchBar resignFirstResponder];
        
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.searchBar resignFirstResponder];
    
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    self.page = 1;
    [self postData];
    
    [searchBar resignFirstResponder];
}




#pragma mark 数据

- (void)endRefreshAccordingTotalCount:(int)totalCount
{
    if (self.page == 1) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer resetNoMoreData];
    }else {
        
        if (totalCount != -1 && self.listData.count == totalCount) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }else {
            [self.tableView.mj_footer endRefreshing];
        }
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



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.listData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
     ZKGlobalSearchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ZKGlobalSearchCellID];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (self.listData.count>0) {
        cell.listModel = self.listData[indexPath.row];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 88;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    
   ZKGlobalSearchMode *model =  self.listData[indexPath.row];
    
    NSString *type = model.type;

    if ([type isEqualToString:@"hotel"]) {
      // 酒店
        [SVProgressHUD showWithStatus:@"加载中..."];
        NSMutableDictionary *list = [NSMutableDictionary dictionary];
        
        [list setObject:model.type forKey:@"type"];
        [list setObject:@"resoureDetail" forKey:@"method"];
        [list setObject:model.ID forKey:@"id"];
        
        [ZKHttp Post:@"" params:list success:^(id responseObj) {
            
            NSLog(@" === %@",responseObj);
            [SVProgressHUD dismiss];
            ZKscenicSpotList *list = [ZKscenicSpotList objectWithKeyValues:responseObj];
            
            UIStoryboard *sb = [UIStoryboard storyboardWithName:@"SourceDetail" bundle:nil];
            ZKHotelDetailViewController *vc = [sb instantiateInitialViewController];
            vc.hotelModel =list;
            [self.navigationController pushViewController:vc animated:YES];
            
        } failure:^(NSError *error) {
            
            [SVProgressHUD dismissWithError:@"网络出错了!"];
            
        }];

        
    }else if ([type isEqualToString:@"scenery"]){
     // 门票
    
        ZKticketListViewController *vc =[[ZKticketListViewController alloc]init];
        [vc updata:model.ID name:model.name];
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if ([type isEqualToString:@"dining"]){
     // 美食
        ZKGoodsDetailsViewController *vc =[[ZKGoodsDetailsViewController alloc]init];
        [vc updata:model.ID type:type  name:model.name];
        [self.navigationController pushViewController:vc animated:YES];
        
    }
    else if ([type isEqualToString:@"recreation"]){
    // 娱乐
      
        ZKentertainmentViewController *vc =[[ZKentertainmentViewController alloc]init];
        [vc updata:model.ID type:type  name:model.name];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if ([type isEqualToString:@"shopping"]){
     // 购物
        ZKCharacteristicsViewController *vc =[[ZKCharacteristicsViewController alloc]init];
        [vc updata:model.ID type:type  name:model.name];
        [self.navigationController pushViewController:vc animated:YES];
    }

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
