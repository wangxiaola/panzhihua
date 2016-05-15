//
//  ZKWellcomeView.m
//  CYmiangzhu
//
//  Created by 王小腊 on 16/5/13.
//  Copyright © 2016年 WangXiaoLa. All rights reserved.
//

#import "ZKWellcomeView.h"
#import "ZKWellcomeJTMode.h"
#import "ZKWellcomeZNMode.h"
#import "ZKWellcomeJTTableViewCell.h"
#import "ZKWellcomeZNTableViewCell.h"
#import "MJRefresh.h"

#import "ZKWellcomeJTListViewController.h"
#import "ZKWellcomeZNListViewController.h"

@implementation ZKWellcomeView

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



- (instancetype)initWithFrame:(CGRect)frame viewTyper:(wellcomeViewTyper)typer;
{

    self = [super initWithFrame:frame];
    
    if (self) {
        self.wellcomeViewTyper = typer;
        self.key = @"";
        self.loadingData = [NSMutableArray arrayWithCapacity:0];
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, frame.size.height) style:UITableViewStylePlain];
        _tableView.backgroundColor = YJCorl(231, 231, 231);
        //去掉plain样式下多余的分割线
        _tableView.tableFooterView = [[UIView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        //设置分割线左边无边距，默认是15
        _tableView.separatorInset = UIEdgeInsetsZero;
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
        _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
      
        [self addSubview:_tableView];

        if (typer == wellcomeViewJT)
        {
            self.Identifier = @"wellcomeViewJT";
              _tableView.estimatedRowHeight=200;
            [_tableView registerNib:[UINib nibWithNibName:@"ZKWellcomeJTTableViewCell" bundle:nil] forCellReuseIdentifier:ZKWellcomeJTTableViewCellID];
        }else
        {
            self.Identifier = @"wellcomeViewZN";
              _tableView.estimatedRowHeight=100;
             [_tableView registerNib:[UINib nibWithNibName:@"ZKWellcomeZNTableViewCell" bundle:nil] forCellReuseIdentifier:ZKWellcomeZNTableViewCellID];
        }
        
        
    }
    
    return self;
}

/**
 *  更新
 */
- (void)updata:(NSString*)key;
{

    self.key = key;
    [self loadNewData];
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
    self.key = @"";
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

- (void)indicatorViewData
{
    self.page = 1;
    [self postData];
    
}
-(void)postData;
{
    NSMutableDictionary *pic = [NSMutableDictionary dictionary];
    
    [ZKHttp Post:@"" params:[self  dataList:self.page data:pic] success:^(id responseObj) {
        
        if (self.wellcomeViewTyper == wellcomeViewJT)
        {
            NSMutableArray <ZKWellcomeJTMode*>*dataArray = [ZKWellcomeJTMode objectArrayWithKeyValuesArray:responseObj[@"rows"]];
            [self dealWithDataArray:dataArray];
            [self endRefreshAccordingTotalCount:[responseObj[@"total"] intValue]];
        }
        else
        {
        
            NSMutableArray <ZKWellcomeZNMode*>*dataArray = [ZKWellcomeZNMode objectArrayWithKeyValuesArray:responseObj[@"rows"]];
           
            [self dealWithDataArray:dataArray];
            [self endRefreshAccordingTotalCount:[responseObj[@"total"] intValue]];
        }
        
       
        
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
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{

    if ([self.delegate respondsToSelector:@selector(scrollViewChange)]) {
        
        [self.delegate scrollViewChange];
    }

}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.wellcomeViewTyper == wellcomeViewJT)
    {
        
        return 190;
    }
    else
    {
       return 100;
    }
   
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (self.wellcomeViewTyper == wellcomeViewJT)
    {
        ZKWellcomeJTTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ZKWellcomeJTTableViewCellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
        
    }
    else
    {
        ZKWellcomeZNTableViewCell  *cell = [tableView dequeueReusableCellWithIdentifier:ZKWellcomeZNTableViewCellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }

}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    
    if (self.wellcomeViewTyper == wellcomeViewJT)
    {
        ZKWellcomeJTListViewController *vc = [[ZKWellcomeJTListViewController alloc] initData:nil];
        [[self.controller navigationController] pushViewController:vc animated:YES];
    }
    else
    {
        ZKWellcomeZNListViewController *vc = [[ZKWellcomeZNListViewController alloc]initData:nil];
        [[self.controller navigationController] pushViewController:vc animated:YES];
        
    }

    

}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.wellcomeViewTyper == wellcomeViewJT)
    {
        ZKWellcomeJTTableViewCell *jtCell = (ZKWellcomeJTTableViewCell*)cell;

        jtCell.dataList = nil;
    }
    else
    {
        ZKWellcomeZNTableViewCell  *znCell = (ZKWellcomeZNTableViewCell*)cell;
     
        znCell.dataList = nil;
    }


}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

//    return self.loadingData.count;
    return 5;
}
@end
