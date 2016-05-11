//
//  ZsearchKViewController.h
//  CYmiangzhu
//
//  Created by 王小腊 on 15/12/9.
//  Copyright © 2015年 WangXiaoLa. All rights reserved.
//

#import "ZKSuperViewController.h"
#import "MJRefresh.h"
#import "ZKscenicSpotList.h"
#import "YYSearchBar.h"

/**
 *  搜索基本模块
 */
@interface ZKsearchSuperViewController : ZKSuperViewController


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
 *  产品类型
 */
@property (strong, nonatomic) NSString *typecode;
/**
 *  数据
 */

@property (nonatomic, strong) NSMutableArray<ZKscenicSpotList*> *listData;
/**
 *  条件数据
 */
@property (retain, nonatomic) NSArray *chooseData;


/**
 *  请求
 *
 *  @param pic 参数
 *
 *  @return 字典
 */

-(void)loadNewData;

/**
 *  加载条件选择
 */
-(void)addTJXZ;
/**
 *  去缓存
 */
- (void)LoadTheCached;
@end
