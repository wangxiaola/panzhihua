//
//  ZKCallLabelTableViewCell.h
//  CYmiangzhu
//
//  Created by 王小腊 on 16/5/16.
//  Copyright © 2016年 WangXiaoLa. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^selecTitle)(NSInteger  index);

@interface ZKCallLabelTableViewCell : UITableViewCell

@property (nonatomic, strong) NSMutableArray <UIButton*>*butArray;

@property (nonatomic, copy) selecTitle choice;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier listData:(NSArray*)data;

- (void)choice:(selecTitle)dex;

@end
