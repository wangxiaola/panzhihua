//
//  ZKErrorView.h
//  CYmiangzhu
//
//  Created by 王小腊 on 16/5/13.
//  Copyright © 2016年 WangXiaoLa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZKErrorView : UIView
@property (nonatomic, copy) void(^reloadBlock)();
- (void)addTarget:(id)target selector:(SEL)selector;
@end
