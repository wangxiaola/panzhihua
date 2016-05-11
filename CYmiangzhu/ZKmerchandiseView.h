//
//  ZKmerchandiseView.h
//  weipeng
//
//  Created by Daqsoft-Mac on 15/2/11.
//  Copyright (c) 2015年 WangXiaoLa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZKAppDelegate.h"
@class ZKmerchandiseView;
@protocol ZKmerchandiseViewDelegate <NSObject>

-(void)array:(NSArray*)data tp:(NSInteger)k;

@end
@interface ZKmerchandiseView : UIView

@property(nonatomic,assign) id<ZKmerchandiseViewDelegate>delegate;

-(void)show;

/**
 *  复选
 *
 *  @param list {我，你，他}
 *  @param str  标题
 *  @param p    当钱选中的
 *  @param j    区分事件
 *
 *  @return self
 */

-(id)initArray:(NSArray*)list Name:(NSString*)str sect:(NSString*)p tp:(NSInteger)j;

@end
