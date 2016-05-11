//
//  ZKInformationCell.h
//  CYmiangzhu
//
//  Created by 汤亮 on 15/12/16.
//  Copyright © 2015年 WangXiaoLa. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZKInformationModel;

extern NSString *const ZKInformationCellID;

@interface ZKInformationCell : UITableViewCell
@property (nonatomic, strong) ZKInformationModel *informationModel;

@end
