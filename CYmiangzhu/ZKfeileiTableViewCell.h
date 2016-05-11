//
//  ZKfeileiTableViewCell.h
//  CYmiangzhu
//
//  Created by Daqsoft-Mac on 15/8/13.
//  Copyright (c) 2015年 WangXiaoLa. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZKCategory;
@interface ZKfeileiTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *lefImage;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *inforLabel;
/**
 *  更新数据
 *
 *  @param p 
 */
-(void)updata:(ZKCategory*)p;

@end
