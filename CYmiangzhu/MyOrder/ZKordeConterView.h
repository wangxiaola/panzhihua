//
//  ZKordeConterView.h
//  CYmiangzhu
//
//  Created by 王小腊 on 15/12/11.
//  Copyright © 2015年 WangXiaoLa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZKOredViewCell.h"
@class ZKmyOrdeMode;

typedef void(^selctView)(NSInteger p);

@interface ZKordeConterView : UIView<UITableViewDataSource,UITableViewDelegate,ZKOredViewCellDelegate>

@property (nonatomic, assign) int page;
@property (nonatomic,strong)UITableView * tableView;
@property (nonatomic, weak) UIImageView *errDataView;
@property (nonatomic,strong)NSMutableArray <ZKmyOrdeMode*>*listData;
@property (nonatomic,strong)NSString *type;

@property (nonatomic,copy) selctView toView;

@property(weak,nonatomic)id contess;

-(void)updata;
-(id)initWithFrame:(CGRect)frame type:(NSString*)str;

-(void)chooseView:(selctView)view;

@end
