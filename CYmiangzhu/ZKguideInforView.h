//
//  ZKguideInforView.h
//  CYmiangzhu
//
//  Created by Daqsoft-Mac on 15/9/30.
//  Copyright (c) 2015年 WangXiaoLa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZKAppDelegate.h"
#import "ListMapData.h"


typedef void(^senderBUtton)(ListMapData*list,int index);


@interface ZKguideInforView : UIView

@property (nonatomic,copy) senderBUtton senderbutton;

/**
 *  导游信息
 *
 *  @param list 数据
 *
 *  @return
 */
-(id)initData:(ListMapData*)list;

-(void)show;

-(void)dism;

-(void)click:(senderBUtton)sender;

@end
