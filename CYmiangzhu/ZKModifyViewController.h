//
//  ZKModifyViewController.h
//  CYmiangzhu
//
//  Created by Daqsoft-Mac on 15/8/17.
//  Copyright (c) 2015年 WangXiaoLa. All rights reserved.
//

#import "ZKSuperViewController.h"
#import "UIKeyboardViewController.h"

/**
 *  修改密码
 */
@interface ZKModifyViewController : ZKSuperViewController<UIKeyboardViewControllerDelegate>
{
    
    UIKeyboardViewController *keyBoardController;
}


@end
