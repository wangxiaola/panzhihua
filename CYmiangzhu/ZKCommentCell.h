//
//  ZKCommentCell.h
//  CYmiangzhu
//
//  Created by 汤亮 on 16/1/8.
//  Copyright © 2016年 WangXiaoLa. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZKCommentModel;

extern NSString *const ZKCommentCellID;

@interface ZKCommentCell : UITableViewCell
@property (nonatomic, strong) ZKCommentModel *commentModel;
@end
