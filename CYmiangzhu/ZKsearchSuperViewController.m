//
//  ZsearchKViewController.m
//  CYmiangzhu
//
//  Created by 王小腊 on 15/12/9.
//  Copyright © 2015年 WangXiaoLa. All rights reserved.
//

#import "ZKsearchSuperViewController.h"
#import "ZKchooseView.h"

@interface ZKsearchSuperViewController ()<UISearchBarDelegate>

@property (nonatomic,retain)ZKchooseView *headerView;
@property (nonatomic, assign) int page;
@property (nonatomic, assign) BOOL searchBool;

/**
 *  类型
 */
@property (nonatomic, strong)NSString *cuisine; //菜肴
@property (nonatomic, strong) NSString *ztype; //子类别

@end


@implementation ZKsearchSuperViewController



-(void)viewWillDisappear:(BOOL)animated
{
    [self.headerView dismm];
    
}

-(id)init
{
    self =[super init];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
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

-(void)setSearchName:(NSString *)searchName
{
    
    self.searchBar.placeString = searchName;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
   [self.navigationBarView addSubview:self.searchBar];
    

    
    self.cuisine = @"";
    self.ztype   = @"";
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, navigationHeghit+40, self.view.bounds.size.width, self.view.bounds.size.height - navigationHeghit -40) style:UITableViewStylePlain];
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

    
    if ([self.ztype isEqualToString:@"不限"]) {
        
        self.ztype = @"";
    }
    
    
    
    if ([self.typecode isEqualToString:@"dining"]) {
        
        if ([self.cuisine isEqualToString:@"不限"]) {
            
            self.cuisine = @"";
        }
        
        [list setObject:self.cuisine forKey:@"cuisine"];
    }
    
    [list setObject:@"resoureList" forKey:@"method"];
    [list setObject:self.typecode forKey:@"type"];
    if ([self.typecode isEqualToString:@"hotel"]) {
        [list setObject:self.ztype forKey:@"grade"];
    }else {
        [list setObject:self.ztype forKey:@"ztype"];
    }
    [list setObject:[NSNumber numberWithInteger:index] forKey:@"page"];
    [list setObject:@"15" forKey:@"rows"];
    [list setObject:key forKey:@"key"];
    
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
    self.searchBool = NO;
    [self postData];
}

- (void)indicatorViewData
{
    self.page = 1;
    self.searchBool = NO;
    [self postData];
    
}
-(void)postData;
{
    NSMutableDictionary *pic = [NSMutableDictionary dictionary];
    [ZKHttp Post:@"" params:[self  dataList:self.page data:pic] success:^(id responseObj) {

        NSLog(@" \n post = %@ \n ",responseObj);
        
        NSMutableArray<ZKscenicSpotList *> *dataArray = [ZKscenicSpotList objectArrayWithKeyValuesArray:responseObj[@"rows"]];

         
            [self dealWithDataArray:dataArray];
            [self endRefreshAccordingTotalCount:[responseObj[@"total"] intValue]];
        
            if (dataArray.count == 0 && self.page > 1) {
                self.page--;
            }
            
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
        [SVProgressHUD showErrorWithStatus:@"网络连接错误！"];
        //根据数据个数判断是否要显示提示没有数据的图片
        self.errDataView.hidden = self.listData.count > 0;

    }];
    
}



#pragma mark - searchBarDelegate
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{


}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.searchBar resignFirstResponder];
    
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    self.searchBool = YES;
    self.page = 1;
    [self postData];
    [[BaiduMobStat defaultStat] logEvent:[NSString stringWithFormat:@"search_%@",_typecode] eventLabel:@"分类-搜索 "];
    [searchBar resignFirstResponder];
}


#pragma mark -  tool
-(void)addTJXZ {

    self.headerView = [[ZKchooseView alloc]initWithFrame:CGRectMake(0, 64, kDeviceWidth, 40) titis:self.chooseData];
    self.headerView.clipsToBounds =YES;
    self.headerView.backgroundColor =[UIColor whiteColor];
    
    
    __weak typeof(self) weakSelf = self;
    [self.headerView  chooseKey:^(NSString *key, NSInteger index) {
        
        if (index == 1) {
            
            weakSelf.ztype = key;
            
        }else if (index == 0){
            weakSelf.cuisine = key;
        }
        
        NSLog(@"%@  ==  %ld",key,(long)index);
        [self loadNewData];
    }];
    [self.view addSubview:self.headerView];

}


//去缓存
- (void)LoadTheCached
{
    self.page = 1;
    NSMutableArray *cacheModels = [NSKeyedUnarchiver unarchiveObjectWithFile:[kDocumentPath stringByAppendingPathComponent:self.Identifier]];
    if (cacheModels == nil || cacheModels.count == 0) {
        [self.tableView.mj_header beginRefreshing];
    }else {
        self.listData = cacheModels;
        [self.tableView reloadData];
    }
}


- (NSMutableArray<ZKscenicSpotList *> *)listData
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
        if ([self.ztype isEqualToString:@""] && [self.cuisine isEqualToString:@""]&&self.searchBool == NO) {
            [NSKeyedArchiver archiveRootObject:dataArray toFile:[kDocumentPath stringByAppendingPathComponent:self.Identifier]];
        }
    }else {
        [self.listData addObjectsFromArray:dataArray];
    }
    
    [self.listData sortUsingComparator:^NSComparisonResult(ZKscenicSpotList * _Nonnull obj1, ZKscenicSpotList *  _Nonnull obj2) {
        return obj1.distance.doubleValue > obj2.distance.doubleValue ? NSOrderedDescending : NSOrderedAscending;
    }];
    
}


@end
