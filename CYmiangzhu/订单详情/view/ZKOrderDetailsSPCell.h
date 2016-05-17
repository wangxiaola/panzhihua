//
//  ZKOrderDetailsSPCell.h
//  CYmiangzhu
//
//  Created by 王小腊 on 16/5/17.
//  Copyright © 2016年 WangXiaoLa. All rights reserved.
//
extern NSString *const ZKOrderDetailsSPCellID;
#import <UIKit/UIKit.h>
@class ZKOrderDetailsMode;

@interface ZKOrderDetailsSPCell : UITableViewCell

@property (nonatomic, strong) ZKOrderDetailsMode *dataList;
@end
