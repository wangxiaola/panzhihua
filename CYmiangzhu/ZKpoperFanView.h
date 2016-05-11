//
//  ZKpoperFanView.h
//  weipeng
//
//  Created by Daqsoft-Mac on 15/2/10.
//  Copyright (c) 2015年 WangXiaoLa. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ZKAppDelegate.h"
@class ZKpoperFanView;
@protocol ZKpoperFanViewDelegate <NSObject>

-(void)Pconfirm:(NSInteger)sect tp:(NSInteger)k;

@end

@interface ZKpoperFanView : UIView

@property(nonatomic,assign) id<ZKpoperFanViewDelegate>delegate;

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
