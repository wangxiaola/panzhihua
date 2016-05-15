//
//  ZKPjHeaderView.h
//  CYmiangzhu
//
//  Created by 小腊 on 16/5/15.
//  Copyright © 2016年 WangXiaoLa. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^CommentBlock)();

//评价头部
@interface ZKPjHeaderView : UIView

@property (nonatomic, copy) CommentBlock commentBlock;

@end
