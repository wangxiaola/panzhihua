//
//  ZKregisterViewController.h
//  CYmiangzhu
//
//  Created by Daqsoft-Mac on 15/8/11.
//  Copyright (c) 2015年 WangXiaoLa. All rights reserved.
//


#import "ZKSuperViewController.h"
#import "ZKTextField.h"

extern NSString *const ZKUserDidLoginedNotification;

/**
 *  登录
 */
@interface ZKregisterViewController : ZKSuperViewController

@property (strong, nonatomic) IBOutlet UIImageView *hom_backImage;

@property (strong, nonatomic) IBOutlet UIButton *dengluClick;
@property (strong, nonatomic) IBOutlet ZKTextField *peopleText;
@property (strong, nonatomic) IBOutlet ZKTextField *passwoderText;
@property (strong, nonatomic) IBOutlet UIButton *cenceBUtton;




typedef void (^UpdateAlertBlock)();
@property (nonatomic, copy) UpdateAlertBlock updateAlertBlock;
/**
 *  登录成功
 *
 */
-(void)dengluCG:(UpdateAlertBlock)pk;

@property (assign, nonatomic) BOOL isMy;

@end
