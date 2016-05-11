//
//  ZKSceneryTicketCell.h
//  CYmiangzhu
//
//  Created by 汤亮 on 15/12/9.
//  Copyright © 2015年 WangXiaoLa. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZKSceneryTicketModel;

extern NSString *const ZKSceneryTicketCellID;

@interface ZKSceneryTicketCell : UITableViewCell

@property (nonatomic, strong) ZKSceneryTicketModel *sceneryTicketModel;
@end
