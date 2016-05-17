//
//  ZKEventQueryListTwoCell.h
//  CYmiangzhu
//
//  Created by 王小腊 on 16/5/17.
//  Copyright © 2016年 WangXiaoLa. All rights reserved.
//

extern NSString *const ZKEventQueryListTwoCellID;

#import <UIKit/UIKit.h>
@class ZKEventQueryDetailsMode;
@interface ZKEventQueryListTwoCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *sjDateLabel;

@property (weak, nonatomic) IBOutlet UILabel *adderLabel;

@property (weak, nonatomic) IBOutlet UILabel *sbDateLabel;

@property (weak, nonatomic) IBOutlet UILabel *clDateLabel;

@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;


@property (nonatomic, strong)ZKEventQueryDetailsMode *list;

@end
