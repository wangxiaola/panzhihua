//
//  ZKEventQueryListOneCell.h
//  CYmiangzhu
//
//  Created by 王小腊 on 16/5/17.
//  Copyright © 2016年 WangXiaoLa. All rights reserved.
//

extern NSString *const ZKEventQueryListOneCellID;
#import <UIKit/UIKit.h>
@class ZKEventQueryDetailsMode;

@interface ZKEventQueryListOneCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *indeferLabel;
@property (weak, nonatomic) IBOutlet UILabel *stateLabel;
@property (weak, nonatomic) IBOutlet UILabel *inforLabel;
@property (nonatomic, strong)ZKEventQueryDetailsMode *list;
@end
