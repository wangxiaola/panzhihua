//
//  ZKmyCityArrayView.h
//  CYmiangzhu
//
//  Created by 小腊 on 15/5/31.
//  Copyright (c) 2015年 WangXiaoLa. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ZKAppDelegate.h"
@class ZKpoperFanView;
@protocol ZKmyCityArrayViewDelegate <NSObject>

-(void)Cityconfirm:(NSInteger)sect tp:(NSInteger)k;

@end

@interface ZKmyCityArrayView : UIView

@property(nonatomic,assign) id<ZKmyCityArrayViewDelegate>delegate;

-(void)show;

-(void)didSelect;
/**
 *  单选
 *
 *  @param type {我，你，他}
 *  @param p    当前选中的
 *  @param r    标题
 *  @param j    区分事件
 *
 *  @return self
 */
-(id)initNames:(NSArray*)type sect:(NSInteger)p reminder:(NSString*)r tp:(NSInteger)j;

@end
