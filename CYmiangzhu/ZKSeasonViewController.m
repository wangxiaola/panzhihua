//
//  ZKTripViewController.m
//  CYmiangzhu
//
//  Created by 王小腊 on 15/12/16.
//  Copyright © 2015年 WangXiaoLa. All rights reserved.
//

#import "ZKSeasonViewController.h"
#import "ZKSeasonMode.h"
#import "MJRefresh.h"
#import "WaterF.h"
#import "WaterFLayout.h"

@interface ZKSeasonViewController ()

@property (nonatomic, assign) int page;
@property (nonatomic, weak) UIImageView *errDataView;
@property (nonatomic, strong) NSMutableArray <ZKSeasonMode *> *listData;
@property (nonatomic,strong) WaterF* waterfall;

@end


@implementation ZKSeasonViewController



//static NSString * const reuseIdentifier = @"Cell";



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.titeLabel.text =@"旅游季节";
    
    UIView *contenView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, kDeviceWidth, kDeviceHeight-64)];
    contenView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:contenView];
    
    WaterFLayout * flowLayout = [[WaterFLayout alloc]init];
    flowLayout.sectionInset = UIEdgeInsetsMake(5, 10, 2, 10);//设置其边界
    [flowLayout setMinimumInteritemSpacing:10]; //设置 y 间距

    self.waterfall = [[WaterF alloc]initWithCollectionViewLayout:flowLayout];
    self.waterfall.sectionNum = 1;
    self.waterfall.imagewidth = kDeviceWidth/2-15;
    [contenView addSubview:self.waterfall.view];
    
    self.waterfall.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    self.waterfall.collectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];

    [self LoadTheCached];
    
    
}

#pragma mark  数据请求

-(NSMutableDictionary*)dataList:(NSInteger)index data:(NSMutableDictionary*)list;

{
    
    [list setObject:[NSNumber numberWithInteger:index] forKey:@"page"];
    [list setObject:@"20" forKey:@"rows"];
    [list setObject:@"aerial" forKey:@"type"];
    [list setObject:@"piclistbyname" forKey:@"method"];
    
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

- (void)indicatorViewData
{
    self.page = 1;
    [self postData];
    
}
-(void)postData;
{
    NSMutableDictionary *pic = [NSMutableDictionary dictionary];
    [ZKHttp Post:@"" params:[self  dataList:self.page data:pic] success:^(id responseObj) {

        NSMutableArray<ZKSeasonMode *> *dataArray = [ZKSeasonMode objectArrayWithKeyValuesArray:responseObj[@"rows"]];
        
        NSLog(@" \n post = %@ \n ",[[responseObj valueForKey:@"rows"][0] valueForKey:@"title"]);
        [self dealWithDataArray:dataArray];
        [self endRefreshAccordingTotalCount:[responseObj[@"total"] intValue]];
        
        if (dataArray.count == 0 && self.page > 1) {
            self.page--;
        }
        
        [self.waterfall.collectionView reloadData];
        
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





#pragma mark ----  tool

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


//去缓存
- (void)LoadTheCached
{
    self.page = 1;
    NSMutableArray *cacheModels = [NSKeyedUnarchiver unarchiveObjectWithFile:[kDocumentPath stringByAppendingPathComponent:@"ZKSeasonViewController"]];
    if (cacheModels == nil || cacheModels.count == 0) {
        [self.waterfall.collectionView.mj_header beginRefreshing];
    }else {
        self.listData = cacheModels;
        
        for (ZKSeasonMode *list in cacheModels) {
            
            NSData* data = [[NSData alloc]initWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", imageUrlPrefix, list.lurl]]];
            [self.waterfall.imagesArr addObject:[UIImage imageWithData:data]];
            [self.waterfall.textsArr addObject:list.title];
        }

        
        [self.waterfall.collectionView reloadData];
    }
}


- (NSMutableArray<ZKSeasonMode *> *)listData
{
    if (_listData == nil) {
        
        _listData = [NSMutableArray array];
        
    }
    return _listData;
}

- (void)endRefreshAccordingTotalCount:(int)totalCount
{
    if (self.page == 1) {
        [self.waterfall.collectionView.mj_header endRefreshing];
        [self.waterfall.collectionView.mj_footer resetNoMoreData];
    }else {
        
        if (totalCount != -1 && self.listData.count == totalCount) {
            [self.waterfall.collectionView.mj_footer endRefreshingWithNoMoreData];
        }else {
            [self.waterfall.collectionView.mj_footer endRefreshing];
        }
    }
}

- (void)dealWithDataArray:(NSMutableArray *)dataArray
{
    //第一页的时候覆盖并缓存数据，其他页的时候累加数据
    if (self.page == 1) {
        
        self.listData = dataArray;
        [self.waterfall.imagesArr removeAllObjects];
        [self.waterfall.textsArr removeAllObjects];
        
        for (ZKSeasonMode *list in dataArray) {
            
            
            NSData* data = [[NSData alloc]initWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", imageUrlPrefix, list.lurl]]];
            [self.waterfall.imagesArr addObject:[UIImage imageWithData:data]];
            [self.waterfall.textsArr addObject:list.title];
        }
        
        [NSKeyedArchiver archiveRootObject:dataArray toFile:[kDocumentPath stringByAppendingPathComponent:@"ZKSeasonViewController"]];
        
        
        
    }else {
        [self.listData addObjectsFromArray:dataArray];
        
        for (ZKSeasonMode *list in dataArray) {
            
            NSData* data = [[NSData alloc]initWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", imageUrlPrefix, list.lurl]]];
            [self.waterfall.imagesArr addObject:[UIImage imageWithData:data]];
            [self.waterfall.textsArr addObject:list.title];

        }
        
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
