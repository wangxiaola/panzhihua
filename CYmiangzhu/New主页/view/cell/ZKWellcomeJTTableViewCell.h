//
//  ZKWellcomeJTTableViewCell.h
//  CYmiangzhu
//
//  Created by 王小腊 on 16/5/13.
//  Copyright © 2016年 WangXiaoLa. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZKWellcomeJTMode;
extern NSString *const  ZKWellcomeJTTableViewCellID;

@interface ZKWellcomeJTTableViewCell : UITableViewCell

@property (nonatomic, strong) ZKWellcomeJTMode *dataList;
@property (weak, nonatomic) IBOutlet UIImageView *backImageView;
@property (weak, nonatomic) IBOutlet UILabel *inforlabel;
@property (weak, nonatomic) IBOutlet UIButton *scButton;
@property (weak, nonatomic) IBOutlet UIButton *fxButton;
@property (weak, nonatomic) IBOutlet UIButton *xxButton;

@end
