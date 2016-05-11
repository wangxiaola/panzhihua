//
//  ZKFootprintCell.h
//  CYmiangzhu
//
//  Created by 汤亮 on 15/12/17.
//  Copyright © 2015年 WangXiaoLa. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZKFootprintModel;

extern NSString *const ZKFootprintCellID;

@interface ZKFootprintCell : UITableViewCell

@property (nonatomic, strong)ZKFootprintModel *footprintModel;

@end
