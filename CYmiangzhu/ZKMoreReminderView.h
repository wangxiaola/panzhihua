//
//  DQMoreReminderView.h
//  changyouyibin
//
//  Created by Daqsoft-Mac on 14/12/9.
//  Copyright (c) 2014年 WangXiaoLa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZKAppDelegate.h"

typedef void(^p_dex) (int pgx);

@interface ZKMoreReminderView : UIView


@property(nonatomic,copy)p_dex sect;

@property (nonatomic, assign) float textHeghit;

-(void)sectec:(p_dex)p;


/**
 *  提示框
 *
 *  @param ts    标题
 *  @param words 内容
 *  @param k     tag
 *
 *  @return int区分
 */
-(id)initTs:(NSString*)ts MarkedWords:(NSString*)words;

-(void)show;

-(void)dism;

@end
