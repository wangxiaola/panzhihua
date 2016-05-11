//
//  ZKTripViewController.m
//  CYmiangzhu
//
//  Created by 王小腊 on 15/12/16.
//  Copyright © 2015年 WangXiaoLa. All rights reserved.
//

#import "ZKTripViewController.h"
#import "XWMagicMoveCell.h"
#import "MJRefresh.h"
#import "ZKTripMode.h"
@interface ZKTripViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>


@property(nonatomic,strong)UICollectionView *collectionView;
@property (nonatomic, assign) int page;
@property (nonatomic, weak) UIImageView *errDataView;
@property (nonatomic, strong) NSMutableArray<ZKTripMode*> *listData;

@end


@implementation ZKTripViewController



static NSString * const reuseIdentifier = @"Cell";

-(instancetype)init
{
    self =[super init];
    
    if (self) {
        self.hidesBottomBarWhenPushed =YES ;
    }
    return self;

}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.titeLabel.text =@"行程参考";
    
    float cellw =kDeviceWidth/2-10;
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    [flowLayout setItemSize:CGSizeMake(cellw, cellw*2/3)];//设置cell的尺寸
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];//设置其布局方向
    flowLayout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);//设置其边界
    //其布局很有意思，当你的cell设置大小后，一行多少个cell，由cell的宽度决定
    
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, navigationHeghit, kDeviceWidth, TabelHeghit) collectionViewLayout:flowLayout];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.backgroundColor = [UIColor clearColor];
    _collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    _collectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    
    [_collectionView registerNib:[UINib nibWithNibName:@"XWMagicMoveCell" bundle:nil] forCellWithReuseIdentifier:reuseIdentifier];
    [self.view addSubview:_collectionView];
    
    [self LoadTheCached];

    
}

#pragma mark  数据请求

-(NSMutableDictionary*)dataList:(NSInteger)index data:(NSMutableDictionary*)list;

{

    [list setObject:[NSNumber numberWithInteger:index] forKey:@"page"];
    [list setObject:@"15" forKey:@"rows"];
    [list setObject:@"line" forKey:@"method"];
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

- (void)indicatorViewData
{
    self.page = 1;
    [self postData];
    
}
-(void)postData;
{
    NSMutableDictionary *pic = [NSMutableDictionary dictionary];
    [ZKHttp Post:@"" params:[self  dataList:self.page data:pic] success:^(id responseObj) {
        
        NSLog(@"%@", pic);
        NSLog(@" \n post = %@ \n ",responseObj);
        
        NSMutableArray<ZKTripMode *> *dataArray = [ZKTripMode objectArrayWithKeyValuesArray:responseObj[@"rows"]];
        
            
            [self dealWithDataArray:dataArray];
            [self endRefreshAccordingTotalCount:[responseObj[@"total"] intValue]];
            
            if (dataArray.count == 0 && self.page > 1) {
                self.page--;
            }
            
            [self.collectionView reloadData];
     
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




#pragma mark <UICollectionViewDataSource>


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.listData.count;
}

- (XWMagicMoveCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    XWMagicMoveCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.listModel = self.listData[indexPath.row];
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{

    ZKBasicViewController *web = [[ZKBasicViewController alloc] init];
    ZKTripMode *list =self.listData[indexPath.row];
    NSString *str =[NSString stringWithFormat:@"%@triDesc.aspx?id=%@&z_pagetitle=%@",webUrlPrefix,list.ID,list.destination];
    web.webToUrl =[str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [self.navigationController pushViewController:web animated:YES];

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
    NSMutableArray *cacheModels = [NSKeyedUnarchiver unarchiveObjectWithFile:[kDocumentPath stringByAppendingPathComponent:@"ZKTripViewController"]];
    if (cacheModels == nil || cacheModels.count == 0) {
        [self.collectionView.mj_header beginRefreshing];
    }else {
        self.listData = cacheModels;
        [self.collectionView reloadData];
    }
}


- (NSMutableArray<ZKTripMode *> *)listData
{
    if (_listData == nil) {
        
        _listData = [NSMutableArray array];
        
    }
    return _listData;
}

- (void)endRefreshAccordingTotalCount:(int)totalCount
{
    if (self.page == 1) {
        [self.collectionView.mj_header endRefreshing];
        [self.collectionView.mj_footer resetNoMoreData];
    }else {
        
        if (totalCount != -1 && self.listData.count == totalCount) {
            [self.collectionView.mj_footer endRefreshingWithNoMoreData];
        }else {
            [self.collectionView.mj_footer endRefreshing];
        }
    }
}

- (void)dealWithDataArray:(NSMutableArray *)dataArray
{
    //第一页的时候覆盖并缓存数据，其他页的时候累加数据
    if (self.page == 1) {
        self.listData = dataArray;
        
        [NSKeyedArchiver archiveRootObject:dataArray toFile:[kDocumentPath stringByAppendingPathComponent:@"ZKTripViewController"]];
        
    }else {
        [self.listData addObjectsFromArray:dataArray];
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
