//
//  ZKrecommenView.h
//  CYmiangzhu
//
//  Created by Daqsoft-Mac on 15/8/12.
//  Copyright (c) 2015年 WangXiaoLa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZKrecommenMode.h"

@protocol ZKrecommenViewDelegate <NSObject>

-(void)index:(ZKrecommenMode*)list;

@end

@interface ZKrecommenView : UIView

@property(nonatomic,assign)id<ZKrecommenViewDelegate>delegate;
/**
 *  更新数据
 *
 *  @param list
 */
-(void)updata:(ZKrecommenMode*)list;

@end
