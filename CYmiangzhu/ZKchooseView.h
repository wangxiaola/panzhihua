//
//  ZKchooseView.h
//  CYmiangzhu
//
//  Created by 王小腊 on 15/12/9.
//  Copyright © 2015年 WangXiaoLa. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^p_dex) (NSString *key,NSInteger index);

/**
 *  选择条件
 */
@interface ZKchooseView : UIView




@property(nonatomic,copy)p_dex choose;

/**
 *  选择条件boolk
 *
 *  @param name 条件
 */
-(void)chooseKey:(p_dex)name;

-(id)initWithFrame:(CGRect)frame titis:(NSArray*)dataArray;

-(void)dismm;
@end
