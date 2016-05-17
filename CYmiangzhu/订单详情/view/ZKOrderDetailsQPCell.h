//
//  ZKOrderDetailsQPCell.h
//  CYmiangzhu
//
//  Created by 王小腊 on 16/5/17.
//  Copyright © 2016年 WangXiaoLa. All rights reserved.
//
extern NSString *const ZKOrderDetailsQPCellID;
#import <UIKit/UIKit.h>
@class ZKOrderDetailsMode;

@interface ZKOrderDetailsQPCell : UITableViewCell

@property(nonatomic, strong) ZKOrderDetailsMode *dataList;
@end
