//
//  ZKFootprintEditCell.h
//  CYmiangzhu
//
//  Created by 汤亮 on 15/12/21.
//  Copyright © 2015年 WangXiaoLa. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    ZKEditOperationModify, //修改操作
    ZKEditOperationDelete  //删除操作
} ZKEditOperation;

extern NSString *const ZKFootprintEditCellID;

@interface ZKFootprintEditCell : UITableViewCell

@property (nonatomic, copy) void (^editFootprintCallback)(ZKEditOperation op);

@end
