//
//  ZKComplaintsViewController.h
//  CYmiangzhu
//
//  Created by 王小腊 on 15/12/17.
//  Copyright © 2015年 WangXiaoLa. All rights reserved.
//

#import "ZKSuperViewController.h"
#import "UIKeyboardViewController.h"
/**
 *  投诉
 */


@interface ZKComplaintsViewController : ZKSuperViewController
{
    
    UIKeyboardViewController *keyBoardController;
}

@property (nonatomic, copy) void (^succeedTousu)();

@end
