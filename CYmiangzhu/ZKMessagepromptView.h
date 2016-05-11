//
//  ZKMessagepromptView.h
//  wpJieBanYou
//
//  Created by Daqsoft-Mac on 15/3/27.
//  Copyright (c) 2015年 WangXiaoLa. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ZKAppDelegate.h"

@interface ZKMessagepromptView : UIView

@property(nonatomic,strong) NSString * url;

-(id)initImage:(NSString*)url Message:(NSString*)message Fid:(NSNumber*)fid Name:(NSString*)name;

-(void)show;

@property(nonatomic,assign)id content;

@end
