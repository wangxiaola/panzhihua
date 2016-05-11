//
//  ZKExplainView.h
//  CYmiangzhu
//
//  Created by Daqsoft-Mac on 15/6/1.
//  Copyright (c) 2015年 WangXiaoLa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZKAppDelegate.h"
@interface ZKExplainView : UIView

typedef void(^p_dex) (void);

@property(nonatomic,copy)p_dex sect;


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

@end
