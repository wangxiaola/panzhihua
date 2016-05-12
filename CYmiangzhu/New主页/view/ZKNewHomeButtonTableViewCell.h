//
//  ZKNewHomeButtonTableViewCell.h
//  CYmiangzhu
//
//  Created by 王小腊 on 16/5/12.
//  Copyright © 2016年 WangXiaoLa. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *const ZKNewHomeButtonTableViewCellID;

@interface ZKNewHomeButtonTableViewCell : UITableViewCell

@property (nonatomic, weak) id controller;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *centerLin;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lefLin;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ritLin;

@end
