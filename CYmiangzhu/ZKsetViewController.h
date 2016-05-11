//
//  ZKsetViewController.h
//  CYmiangzhu
//
//  Created by Daqsoft-Mac on 15/8/14.
//  Copyright (c) 2015年 WangXiaoLa. All rights reserved.
//

#import "ZKSuperViewController.h"
#import "UIKeyboardViewController.h"
@class ZKsetViewController;


typedef enum{
    ZKsetOperationCancelAuth, //注销
    ZKsetOperationSaveUserInfo //保存了用户信息
} ZKsetOperation;

@protocol ZKsetViewControllerDelegate <NSObject>

@optional
/**
 *  完成了一个操作后的代理方法
 */
- (void)setViewControllerDidOperaton:(ZKsetOperation)operation;
@end

/**
 *  设置
 */
@interface ZKsetViewController : ZKSuperViewController<UIKeyboardViewControllerDelegate>
{
    
    UIKeyboardViewController *keyBoardController;
}

@property (nonatomic, weak) id<ZKsetViewControllerDelegate>delegate;

@end
