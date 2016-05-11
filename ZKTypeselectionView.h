//
//  ZKTypeselectionView.h
//  CYmiangzhu
//
//  Created by Daqsoft-Mac on 15/7/14.
//  Copyright (c) 2015年 WangXiaoLa. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ZKTypeselectionViewDelegate<NSObject>

-(void)pAdd:(NSInteger)a;

-(void)pCancel:(NSInteger)c;


@end

/**
 *  类型选择  单选
 */
@interface ZKTypeselectionView : UIView

-(id)initWithFrame:(CGRect)frame data:(NSArray*)list;

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

@property(nonatomic,assign)id<ZKTypeselectionViewDelegate>delegate;

@end
