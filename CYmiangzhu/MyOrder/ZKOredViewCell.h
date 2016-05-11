//
//  ZKOredViewCell.h
//  CYmiangzhu
//
//  Created by 王小腊 on 15/12/11.
//  Copyright © 2015年 WangXiaoLa. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZKmyOrdeMode;

extern NSString *const ZKOredViewCellID;

@protocol ZKOredViewCellDelegate <NSObject>

-(void)ZKOredViewCellbutton:(ZKmyOrdeMode*)list;


@end

@interface ZKOredViewCell : UITableViewCell

//数据模型
@property (nonatomic,strong) ZKmyOrdeMode *ordeModel;

@property (nonatomic,strong) NSString *state;
@property (nonatomic,assign) id<ZKOredViewCellDelegate>delegate;

@end
