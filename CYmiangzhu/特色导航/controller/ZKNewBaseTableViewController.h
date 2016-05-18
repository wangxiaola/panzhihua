//
//  JKBaseTableViewController.h
//  CYmiangzhu
//
//  Created by 王小腊 on 16/5/11.
//  Copyright © 2016年 WangXiaoLa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZKNewBaseTableViewController : UITableViewController
/**
 *  数据源数组
 */
@property (nonatomic, strong) NSMutableArray *models;
/**
 *  数据源数组所装模型的类型
 */
@property (nonatomic, strong) Class modelsType;
/**
 *  请求路径
 */
@property (nonatomic, copy) NSString *URLString;
/**
 *  请求参数
 */
@property (nonatomic, copy) NSMutableDictionary *params;
/**
 *  缓存文件名
 */
@property (nonatomic, copy) NSString *cacheFilename;
/*
 * 是否需要下拉刷新
 */
@property (nonatomic, assign, getter=isNeedsPullDownRefreshing) BOOL needsPullDownRefreshing;
/*
 * 是否需要上拉刷新
 */
@property (nonatomic, assign, getter=isNeedsPullUpRefreshing) BOOL needsPullUpRefreshing;
/**
 *  留给子类覆盖，在方法中应设置以上属性
 */
- (void)setupProperties NS_REQUIRES_SUPER; 
@end
