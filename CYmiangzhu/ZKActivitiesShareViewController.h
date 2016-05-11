//
//  ZKActivitiesShareViewController.h
//  weipeng
//
//  Created by Daqsoft-Mac on 15/2/12.
//  Copyright (c) 2015年 WangXiaoLa. All rights reserved.
//

#import "ZKSuperViewController.h"

typedef  void(^shareSuccess)(void);

@interface ZKActivitiesShareViewController : ZKSuperViewController

@property(nonatomic,copy)shareSuccess shareBlok;

/**
 *  分享
 *
 *  @param url  图片url
 *  @param str  默认类容
 *  @param name 主题
 *  @param lur  连接
 *
 *  @return
 */
-(id)initImageUrl:(NSString*)url Theme:(NSString*)str Name:(NSString*)name Lurl:(NSString*)lur;

-(void)shareSuccess:(shareSuccess)es;

@end
