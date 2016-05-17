//
//  ZKEventQueryStateView.h
//  CYmiangzhu
//
//  Created by 王小腊 on 16/5/17.
//  Copyright © 2016年 WangXiaoLa. All rights reserved.
//

/**
 *  view状态
 */
typedef NS_ENUM(NSInteger , EventQueryState)
{
    /**
     *  全部
     */
    EventQueryState_qb = 0,
    /**
     *  处理
     */
    EventQueryState_cl,
    /**
     *  接收
     */
    EventQueryState_js,
    /**
     *  上报
     */
    EventQueryState_sb,
};

#import <UIKit/UIKit.h>

@class ZKEventQueryStateMode;
/**
 *  事件状态
 */
@interface ZKEventQueryStateView : UIView<UITableViewDelegate,UITableViewDataSource>


@property (nonatomic, weak) id controller;

@property (nonatomic,retain)UITableView *tableView;
@property (nonatomic, weak) UIImageView *errDataView;
@property (nonatomic, strong)NSString *key;
@property (nonatomic, assign) int page;
/**
 *  标示
 */
@property (nonatomic,strong)NSString *Identifier;

/**
 *  数据
 */
@property (nonatomic, strong) NSMutableArray <ZKEventQueryStateMode*>*loadingData;


@property (nonatomic) EventQueryState eqState;

- (instancetype)initWithFrame:(CGRect)frame viewState:(EventQueryState)state;

@end
