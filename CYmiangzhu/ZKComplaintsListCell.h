//
//  ZKComplaintsListCell.h
//  CYmiangzhu
//
//  Created by 王小腊 on 15/12/18.
//  Copyright © 2015年 WangXiaoLa. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZKComplaintsListMode;
extern NSString *const ZKComplaintsListCellID;

@interface ZKComplaintsListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *infor;
@property (weak, nonatomic) IBOutlet UILabel *timer;
@property (nonatomic,strong)ZKComplaintsListMode *listMode;
@end
