//
//  ZKPhoneModifyViewController.h
//  CYmiangzhu
//
//  Created by 汤亮 on 15/8/28.
//  Copyright (c) 2015年 WangXiaoLa. All rights reserved.
//

#import "ZKSuperViewController.h"
#import "UIKeyboardViewController.h"

@class ZKPhoneModifyViewController;

@protocol ZKPhoneModifyViewControllerDelegate <NSObject>

@optional
- (void)phoneModifyViewControllerDidModifyPhone:(ZKPhoneModifyViewController *)phoneModifyViewController;

@end


@interface ZKPhoneModifyViewController : ZKSuperViewController<UIKeyboardViewControllerDelegate>
{
    
    UIKeyboardViewController *keyBoardController;
}

@property (nonatomic, weak) id<ZKPhoneModifyViewControllerDelegate>delegate;
@end
