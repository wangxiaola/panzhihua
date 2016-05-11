//
//  DQNavSelectView.h
//  changyouyibin
//
//  Created by Daqsoft-Mac on 15/2/9.
//  Copyright (c) 2015年 WangXiaoLa. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DQNavSelectView;

@protocol DQNavSelectViewDeleget <NSObject>

-(void)pAdd:(NSInteger)a;

-(void)pCancel:(NSInteger)c;


@end

@interface DQNavSelectView : UIView

-(id)initWithFrame:(CGRect)frame;
/**
 *  添加高亮选中
 *
 *  @param selec 第几个
 */
-(void)updata:(NSInteger)selec;
/**
 *  都变暗
 */
-(void)dismHeg;
/**
 *  都变亮
 */
-(void)showHeg;

@property(nonatomic,assign)id<DQNavSelectViewDeleget>delegate;

@end
