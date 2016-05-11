//
//  ZKStrategyCell.h
//  CYmiangzhu
//
//  Created by 汤亮 on 15/12/16.
//  Copyright © 2015年 WangXiaoLa. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZKStrategyModel;
extern NSString *const ZKStrategyCellID;

@interface ZKStrategyCell : UITableViewCell
@property (nonatomic, strong) ZKStrategyModel *strategyModel;
@end
