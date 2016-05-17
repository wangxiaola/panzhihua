//
//  ZKEventQueryStateView.m
//  CYmiangzhu
//
//  Created by 王小腊 on 16/5/17.
//  Copyright © 2016年 WangXiaoLa. All rights reserved.
//

#import "ZKEventQueryStateView.h"
#import "ZKEventQueryStateMode.h"
#import "MJRefresh.h"
#import "ZKEventQueryStateCell.h"
#import "ZKEventQueryListViewController.h"

@implementation ZKEventQueryStateView

- (UIImageView *)errDataView
{
    
    if (_errDataView == nil) {
        UIImageView *emptyDataView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"errData"]];
        CGSize t = emptyDataView.frame.size;
        emptyDataView.frame =CGRectMake((self.frame.size.width-t.width)/2, (self.frame.size.height-t.height)/2, t.width, t.height);
        emptyDataView.userInteractionEnabled =YES;
        [self addSubview:emptyDataView];
        self.errDataView = emptyDataView;
        UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(loadNewData)];
        [emptyDataView addGestureRecognizer:tapGr];
        
    }
    return _errDataView;
}


- (NSMutableArray<ZKEventQueryStateMode *> *)loadingData
{

    if (!_loadingData) {
        
        _loadingData = [NSMutableArray arrayWithCapacity:0];
    }
    
    return _loadingData;
}

- (instancetype)initWithFrame:(CGRect)frame viewState:(EventQueryState)state;
{

    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.eqState = state;
        
        self.key = @"";
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, frame.size.height) style:UITableViewStylePlain];
        _tableView.backgroundColor = YJCorl(231, 231, 231);
        //去掉plain样式下多余的分割线
        _tableView.tableFooterView = [[UIView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.estimatedRowHeight = 60; //预估行高 可以提高性能
        //设置分割线左边无边距，默认是15
        _tableView.separatorInset = UIEdgeInsetsZero;
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
        _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
        
        [self addSubview:_tableView];
        
        [_tableView registerNib:[UINib nibWithNibName:@"ZKEventQueryStateCell" bundle:nil] forCellReuseIdentifier:ZKEventQueryStateCellID];
        
    }
    
    return self;
}

#pragma mark  数据请求

-(NSMutableDictionary*)dataList:(NSInteger)index data:(NSMutableDictionary*)list;

{
    
    
    [list setObject:@"resoureList" forKey:@"method"];
    [list setObject:[NSNumber numberWithInteger:index] forKey:@"page"];
    [list setObject:@"15" forKey:@"rows"];
    [list setObject:self.key forKey:@"key"];
    
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
    NSMutableDictionary *pic = [NSMutableDictionary dictionary];
    
    [ZKHttp Post:@"" params:[self  dataList:self.page data:pic] success:^(id responseObj) {
        
        NSMutableArray <ZKEventQueryStateMode*>*dataArray = [ZKEventQueryStateMode objectArrayWithKeyValuesArray:responseObj[@"rows"]];
            [self dealWithDataArray:dataArray];
            [self endRefreshAccordingTotalCount:[responseObj[@"total"] intValue]];

        if (self.loadingData.count == 0 && self.page > 1) {
            self.page--;
        }
        
        [self.tableView reloadData];
        
        //根据数据个数判断是否要显示提示没有数据的图片
        self.errDataView.hidden = self.loadingData.count > 0;
        
    } failure:^(NSError *error) {
        
        [self LoadTheCached];
        
    }];
    
    
    
}


#pragma mark  数据处理
//去缓存
- (void)LoadTheCached
{
    
    NSMutableArray *cacheModels = [NSKeyedUnarchiver unarchiveObjectWithFile:[kDocumentPath stringByAppendingPathComponent:self.Identifier]];
    if (cacheModels == nil || cacheModels.count == 0) {
        
        [self endRefreshAccordingTotalCount:-1];
        self.page =1;
        //提示
        [SVProgressHUD showErrorWithStatus:@"网络连接错误！" duration:1];
        
        //根据数据个数判断是否要显示提示没有数据的图片
        self.errDataView.hidden = self.loadingData.count > 0;
        
    }else {
        
        self.loadingData = cacheModels;
        [self.tableView reloadData];
        
    }
    
    
}


- (void)endRefreshAccordingTotalCount:(int)totalCount
{
    if (self.page == 1) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer resetNoMoreData];
    }else {
        
        if (totalCount != -1 && self.loadingData.count == totalCount) {
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
        self.loadingData = dataArray;
        [NSKeyedArchiver archiveRootObject:dataArray toFile:[kDocumentPath stringByAppendingPathComponent:self.Identifier]];
        
    }else {
        [self.loadingData addObjectsFromArray:dataArray];
    }
    
    
}

#pragma mark table代理

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{

    return 8;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZKEventQueryStateCell *cell = [tableView dequeueReusableCellWithIdentifier:ZKEventQueryStateCellID];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}
- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{

    return [[UIView alloc]init];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    [[self.controller navigationController] pushViewController:[[ZKEventQueryListViewController alloc] initData:nil] animated:YES];
    
    
}
//赋值
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    

    return 1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;

}
//哪几行可以编辑
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return YES;
}


//继承该方法时,左右滑动会出现删除按钮(自定义按钮),点击按钮时的操作
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (editingStyle != UITableViewCellEditingStyleDelete) { return; }
    
//    ZKEventQueryStateMode *list =[self.loadingData objectAtIndex:indexPath.section];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"method"] = @"messageResouceDel";
    params[@"memberid"] = [ZKUserInfo sharedZKUserInfo].ID;
    
    
    [ZKHttp Post:@"" params:params success:^(id responseObj) {
        
//        [self.loadingData removeObjectAtIndex:indexPath.section];
        
        [tableView beginUpdates];
        
        NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:indexPath.section];
        [tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
        
        [tableView endUpdates];
        
        
    } failure:^(NSError *error) {
        
        //提示
        [SVProgressHUD showErrorWithStatus:@"请检查网络"];
        
        
    }];
    
}


- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return @"删除";
}

//当 tableview 为 editing 时,左侧按钮的 style
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}


@end
