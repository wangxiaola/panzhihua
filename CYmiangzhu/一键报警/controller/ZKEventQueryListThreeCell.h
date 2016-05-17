//
//  ZKEventQueryListThreeCell.h
//  CYmiangzhu
//
//  Created by 王小腊 on 16/5/17.
//  Copyright © 2016年 WangXiaoLa. All rights reserved.
//

extern NSString *const ZKEventQueryListThreeCellID;

#import <UIKit/UIKit.h>
@class ZKEventQueryDetailsMode;

@interface ZKEventQueryListThreeCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *lefImageView;
@property (weak, nonatomic) IBOutlet UILabel *stateLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIView *linView;

- (void)updata:(ZKEventQueryDetailsMode*)list select:(NSInteger)index;

@end
