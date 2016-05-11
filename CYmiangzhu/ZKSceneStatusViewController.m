//
//  ZKSceneStatusViewController.m
//  CYmiangzhu
//
//  Created by 汤亮 on 15/8/31.
//  Copyright (c) 2015年 WangXiaoLa. All rights reserved.
//

#import "ZKSceneStatusViewController.h"
#import "ZKSceneManCollectionViewCell.h"
#import "ZKSceneStatusNumberCell.h"
#import "ZKSceneStatusCell.h"
#import "ZKSceneStatusLayout.h"
#import "ZKSceneStatus.h"
#import "ZKCollectionHeaderView.h"

static NSString *const cellID1 = @"ZKSceneManCollectionViewCellID";
static NSString *const cellID2= @"SceneStatusNumberCell";

typedef enum{
  
  CellStyleMan,
  CellStyleNumber
    
} CellStyle;

@interface ZKSceneStatusViewController ()<UICollectionViewDataSource>
@property (nonatomic, weak) UICollectionView *collectionView;

@property (nonatomic, assign)CellStyle cellStyle;

@property (nonatomic, strong) NSArray *sceneStatuses;
@property (nonatomic, weak)ZKCollectionHeaderView *header;
@end

@implementation ZKSceneStatusViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.cellStyle = CellStyleMan;
    [[BaiduMobStat defaultStat] logEvent:@"home_go_present" eventLabel:@"首页-现状"];
    [self setupNavigationBar];
    [self setupCollectionView];
    
    [self postData];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
//    [SVProgressHUD dismiss];

}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [SVProgressHUD dismiss];
}


- (NSArray *)sceneStatuses
{
    if (_sceneStatuses == nil) {
        _sceneStatuses = [NSArray array];
    }
    return _sceneStatuses;
}

#pragma mark - 控件初始化
- (void)setupCollectionView
{
    ZKSceneStatusLayout *flow = [[ZKSceneStatusLayout alloc] init];
    flow.itemSize = CGSizeMake(150, 80);
    CGFloat inset = (self.view.bounds.size.width - 2 * flow.itemSize.width) / 3 -2;
    
    flow.sectionInset = UIEdgeInsetsMake(30, inset, 0, inset);
    // 设置每一行之间的间距
    flow.minimumLineSpacing = inset;
    flow.maxItemRowSpace = inset;
    flow.colums = 2;
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:flow];
    collectionView.y = 64;
    collectionView.dataSource = self;
    collectionView.backgroundColor = [UIColor whiteColor];
    collectionView.alwaysBounceVertical = YES;
    collectionView.contentInset = UIEdgeInsetsMake(0, 0, 70, 0);
    [collectionView registerNib:[UINib nibWithNibName:@"ZKSceneManCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:cellID1];
    [collectionView registerNib:[UINib nibWithNibName:@"ZKSceneStatusNumberCell" bundle:nil] forCellWithReuseIdentifier:cellID2];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeCell)];
    [collectionView addGestureRecognizer:tap];
    
    ZKCollectionHeaderView *header = [ZKCollectionHeaderView collectionHeaderView];
    header.x = header.y = 0;
    header.width = collectionView.width;
    header.height = 30;
    [collectionView addSubview:header];
    self.header = header;
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    header.timeLabel.text = [fmt stringFromDate:[NSDate date]];
    
    self.collectionView = collectionView;
    [self.view addSubview:collectionView];

}

- (void)setupNavigationBar
{
    self.titeLabel.text =@"景区现状";
    self.rittBarButtonItem =[[UIButton alloc]initWithFrame:CGRectMake(kDeviceWidth-2-40, 20, 40, 40)];
    self.rittBarButtonItem.backgroundColor =[UIColor clearColor];
    self.rittBarButtonItem.titleLabel.textColor =[UIColor whiteColor];
    self.rittBarButtonItem.titleLabel.font =[UIFont systemFontOfSize:12];
    self.rittBarButtonItem.titleLabel.font =[UIFont boldSystemFontOfSize:12];
    [self.rittBarButtonItem setImage:[UIImage imageNamed:@"xianzhuang_exchange"] forState:UIControlStateNormal];
    [self.rittBarButtonItem addTarget:self action:@selector(refreshData) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationBarView addSubview: self.rittBarButtonItem];

}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.sceneStatuses.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //ZKSceneStatusCell *cell = nil;
    
    if (self.cellStyle == CellStyleMan) {
       ZKSceneManCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID1 forIndexPath:indexPath];
        cell.status = self.sceneStatuses[indexPath.item];
        return cell;
    }else{
        
      ZKSceneStatusNumberCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID2 forIndexPath:indexPath];
        cell.status = self.sceneStatuses[indexPath.item];
        return cell;
    }
    
    
}

#pragma mark - 刷新

-(void)postData
{

        NSMutableDictionary *para = [NSMutableDictionary dictionary];
        para[@"method"] = @"realTime";
        para[@"format"] = @"json";
    
        [SVProgressHUD showWithStatus:@"获取数据中..."];
    
       [ZKHttp tlPost:@"" params:para success:^(id responseObj) {
           [SVProgressHUD dismiss];
    
    
    
           NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
           fmt.dateFormat = @"yyyy-MM-dd HH:mm:ss";
           self.header.timeLabel.text = [fmt stringFromDate:[NSDate date]];
    
           if ([responseObj[@"rows"] count] ==0) {
               [SVProgressHUD showErrorWithStatus:@"暂无数据" duration:1];
               return;
           }
    
           [SVProgressHUD showSuccessWithStatus:@"获取数据成功" duration:1];
           self.sceneStatuses = [ZKSceneStatus objectArrayWithKeyValuesArray:responseObj[@"rows"]];
           [self.collectionView reloadData];
    
    
    
       } failure:^(NSError *error) {
           
           [SVProgressHUD dismiss];
           [SVProgressHUD showErrorWithStatus:@"获取数据失败" duration:1];
           
       }];


}
- (void)refreshData
{
    
    [self changeCell];
    
    
}

#pragma mark - 改变cell显示样式
- (void)changeCell
{
    if (self.cellStyle == CellStyleMan) {
        self.cellStyle = CellStyleNumber;
    }else{
        self.cellStyle = CellStyleMan;
    }
    [self.collectionView reloadData];
}

@end
