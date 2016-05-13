//
//  ZKWellcomeView.h
//  CYmiangzhu
//
//  Created by 王小腊 on 16/5/13.
//  Copyright © 2016年 WangXiaoLa. All rights reserved.
//


/**
 *  康养样式
 */
typedef NS_ENUM(NSInteger,wellcomeViewTyper) {
    /**
     *  基地
     */
    wellcomeViewJT = 0,
    /**
     *  指南
     */
    wellcomeViewZN,
};


#import <UIKit/UIKit.h>
@class ZKWellcomeJTMode;
@class ZKWellcomeZNMode;


@protocol ZKWellcomeDelegate <NSObject>

- (void)scrollViewChange;

@end
@interface ZKWellcomeView : UIView<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic) wellcomeViewTyper wellcomeViewTyper;

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
@property (nonatomic, strong) NSMutableArray *loadingData;

- (instancetype)initWithFrame:(CGRect)frame viewTyper:(wellcomeViewTyper)typer;
/**
 *  更新
 */
- (void)updata:(NSString*)key;

@property (nonatomic, assign) id<ZKWellcomeDelegate>delegate;


@end
