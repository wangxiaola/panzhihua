//
//  ZKmyTableViewCell.h
//  CYmiangzhu
//
//  Created by Daqsoft-Mac on 15/8/14.
//  Copyright (c) 2015年 WangXiaoLa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZKmyList.h"
@interface ZKmyTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *lefIMage;

@property (strong, nonatomic) IBOutlet UILabel *ritLabel;

@property (strong, nonatomic) IBOutlet UILabel *leiLabel;

/**
 *  更新数据
 *
 *  @param p
 */
-(void)updata:(ZKmyList*)p;

@end
