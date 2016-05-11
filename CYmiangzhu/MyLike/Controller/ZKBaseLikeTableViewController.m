//
//  ZKBaseLikeTableViewController.m
//  CYmiangzhu
//
//  Created by 汤亮 on 15/12/11.
//  Copyright © 2015年 WangXiaoLa. All rights reserved.
//

#import "ZKBaseLikeTableViewController.h"
#import "MJRefresh.h"
#import "ZKFoodTableViewCell.h"
#import "ZKAddressCell.h"
#import "ZKLikeModel.h"

#import "ZKticketListViewController.h"//景区
#import "ZKHotelDetailViewController.h"//酒店
#import "ZKGoodsDetailsViewController.h"//美食
#import "ZKCharacteristicsViewController.h"//购物
#import "ZKentertainmentViewController.h"//娱乐

#import "ZKscenicSpotList.h"

@interface ZKBaseLikeTableViewController ()
@property (nonatomic, weak) UIImageView *emptyDataView;
@property (nonatomic, copy) NSString *cacheFilename;
@property (nonatomic, strong) NSMutableDictionary *params;
@end

@implementation ZKBaseLikeTableViewController

//留给子类覆盖，设置参数和缓存名
- (void)supplementToParams:(NSMutableDictionary *)params cacheFilename:(NSString **)cacheFilename {}

- (NSMutableDictionary *)params
{
    if (_params == nil) {
        _params = [NSMutableDictionary dictionary];
        _params[@"method"] = @"myCollectionAndShare";
        if ([ZKUserInfo sharedZKUserInfo].ID != nil) {
            _params[@"memberid"] = [ZKUserInfo sharedZKUserInfo].ID;
        }
        _params[@"typeint"] = self.likeType == ZKLikeTypeCollection ? @"0" : @"1";
    
    }
    return _params;
}

- (NSString *)cacheFilename
{
    if (_cacheFilename == nil) {
        _cacheFilename = [NSString string];
    }
    return _cacheFilename;
}

- (UIImageView *)emptyDataView
{
    if (_emptyDataView == nil) {
        UIImageView *emptyDataView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"errData"]];
        emptyDataView.center = CGPointMake(self.tableView.center.x, self.tableView.center.y - 64);
        [self.tableView addSubview:emptyDataView];
        self.emptyDataView = emptyDataView;
    }
    return _emptyDataView;
}

- (NSMutableArray<ZKLikeModel *> *)likeModels
{
    if (_likeModels == nil) {
        _likeModels = [NSMutableArray array];
    }
    return _likeModels;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupTableView];
    [self readDataFromSandBox];
}

- (void)readDataFromSandBox
{
    NSString *cacheFilename = nil;
    //对象属性不能通过“&self.属性”来访问地址，只能设置临时变量后再赋值
    [self supplementToParams:self.params cacheFilename:&cacheFilename];
    self.cacheFilename = cacheFilename;
    
    NSMutableArray *cacheModels = [NSKeyedUnarchiver unarchiveObjectWithFile:[kDocumentPath stringByAppendingPathComponent:self.cacheFilename]];
    if (cacheModels.count > 0) {
        self.likeModels = cacheModels;
        [self.tableView reloadData];
    }
    [self.tableView.mj_header beginRefreshing];
}

- (void)setupTableView
{
    self.tableView.backgroundColor = YJCorl(231, 231, 231);
    //去掉plain样式下多余的分割线
    self.tableView.tableFooterView = [[UIView alloc] init];
    //设置分割线左边无边距，默认是15
    self.tableView.separatorInset = UIEdgeInsetsZero;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    [self.tableView registerNib:[UINib nibWithNibName:@"ZKAddressCell" bundle:nil] forCellReuseIdentifier:ZKAddressCellID];
}

- (void)loadData
{
    if ([ZKUserInfo sharedZKUserInfo].ID == nil) {
        [self.tableView makeToast:@"请先登录"];
        [self.tableView.mj_header endRefreshing];
        return;
    }
    
    NSLog(@"---- %@", self.params);
    [ZKHttp Post:@"" params:self.params success:^(id responseObj) {
        NSLog(@"%@", responseObj);
        
        [self.tableView.mj_header endRefreshing];
        self.likeModels = [ZKLikeModel objectArrayWithKeyValuesArray:responseObj[@"rows"]];
        [self.likeModels sortUsingComparator:^NSComparisonResult(ZKLikeModel * _Nonnull obj1, ZKLikeModel * _Nonnull obj2) {
            return obj1.distance.doubleValue > obj2.distance.doubleValue ? NSOrderedDescending : NSOrderedAscending;
        }];
        [self.tableView reloadData];
        [NSKeyedArchiver archiveRootObject:self.likeModels toFile:[kDocumentPath stringByAppendingPathComponent:self.cacheFilename]];
    } failure:^(NSError *error) {
        
        [self.tableView.mj_header endRefreshing];
        
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    self.emptyDataView.hidden = self.likeModels.count > 0;
    return self.likeModels.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZKAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:ZKAddressCellID];
    cell.likeModel = self.likeModels[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 88;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ZKLikeModel *model = self.likeModels[indexPath.row];
    
    if ([model.type isEqualToString:@"hotel"]) {
        
        NSMutableDictionary *list = [NSMutableDictionary dictionary];
        
        [list setObject:model.type forKey:@"type"];
        [list setObject:@"resoureDetail" forKey:@"method"];
        [list setObject:model.dataid forKey:@"id"];
        
        [ZKHttp Post:@"" params:list success:^(id responseObj) {
            
            NSLog(@" === %@",responseObj);
            ZKscenicSpotList *list = [ZKscenicSpotList objectWithKeyValues:responseObj];
            UIStoryboard *sb = [UIStoryboard storyboardWithName:@"SourceDetail" bundle:nil];
            ZKHotelDetailViewController *vc = [sb instantiateInitialViewController];
            vc.hotelModel =list;
            [self.navigationController pushViewController:vc animated:YES];
            
        } failure:^(NSError *error) {
            
            [self.view makeToast:@"网络出错了!"];
            
        }];

    }else{
    
        UIViewController *vc = [self navPush:model];
        
        [self.navigationController pushViewController:vc animated:YES];
    }


    //NSString *str = [NSString stringWithFormat:@"desc_resource.aspx?z_isheadback=true&id=%@&z_pagetitle=%@&type=%@",model.ID, model.dataname, model.type];
    //[self jumpToWebUrl:webUrl(str)];
    
}

-(UIViewController*)navPush:(ZKLikeModel*)data
{

    NSString *type = data.type;
    
    if ([type isEqualToString:@"scenery"] ) {
        
        ZKticketListViewController *vc =[ZKticketListViewController new];
        [vc updata:data.dataid name:data.dataname];
        return vc;
        
    }else if ([type isEqualToString:@"dining"]){
        ZKGoodsDetailsViewController *vc =[ZKGoodsDetailsViewController new];
        [vc updata:data.dataid type:data.type name:data.dataname];
        
        return vc;
        
    }else if ([type isEqualToString:@"shopping"]){
        
        ZKCharacteristicsViewController *vc =[ZKCharacteristicsViewController new];
        [vc updata:data.dataid type:data.type name:data.dataname];
        return vc;
        
    }else {
        
        ZKentertainmentViewController *vc =[ZKentertainmentViewController new];
        [vc updata:data.dataid type:data.type name:data.dataname];
        return vc;
    }
    
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
- (void)jumpToWebUrl:(NSString *)webUrl
{
    ZKBasicViewController *web = [[ZKBasicViewController alloc] init];
    web.webToUrl = [webUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    web.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:web animated:YES];
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle != UITableViewCellEditingStyleDelete) { return; }
    
    ZKLikeModel *model = self.likeModels[indexPath.row];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"method"] = @"cancelCollection";
    params[@"memberid"] = [ZKUserInfo sharedZKUserInfo].ID;
    params[@"type"] = model.type;
    params[@"id"] = model.dataid;
    params[@"typeint"] = self.likeType == ZKLikeTypeCollection ? @"0":@"1";
    
    [SVProgressHUD showWithStatus:@"删除中..."];
    [ZKHttp Post:@"" params:params success:^(id responseObj) {
        
        if ([responseObj[@"state"] isEqualToString:@"success"]) {
            [SVProgressHUD showSuccessWithStatus:@"删除成功"];
            [self.likeModels removeObjectAtIndex:indexPath.row];
            
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            
            [NSKeyedArchiver archiveRootObject:self.likeModels toFile:[kDocumentPath stringByAppendingPathComponent:self.cacheFilename]];
        }else {
            [SVProgressHUD showSuccessWithStatus:responseObj[@"msg"]];
        }
        
    } failure:^(NSError *error) {
        [SVProgressHUD showSuccessWithStatus:@"网络出错"];
    }];
   
}

@end
