//
//  ZKAnnounciatorView.h
//  CYmiangzhu
//
//  Created by 王小腊 on 16/4/15.
//  Copyright © 2016年 WangXiaoLa. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^click)();

@interface ZKAnnounciatorView : UIView
/**
 *  选择的标签
 */
- (void)selClick:(void (^) ())sel;




@end
