//
//  ZKMapViewController.h
//  weipeng
//
//  Created by Daqsoft-Mac on 15/1/21.
//  Copyright (c) 2015年 WangXiaoLa. All rights reserved.
//

#import "ZKSuperViewController.h"

//#import "ZKMaterialViewController.h"

@class ZKMaterialViewController;

@protocol ZKMapDelegate<NSObject>

-(void)site:(NSString*)loc Lon:(NSString*)lon Lat:(NSString*)lat;

@end

@interface ZKMapViewController : ZKSuperViewController


@property(nonatomic,assign)NSObject<ZKMapDelegate>*delegate;


@end
