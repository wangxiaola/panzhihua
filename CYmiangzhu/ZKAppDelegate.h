//
//  ZKAppDelegate.h
//  CYmiangzhu
//
//  Created by Daqsoft-Mac on 15/5/27.
//  Copyright (c) 2015年 WangXiaoLa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "noting.h"
#import <CoreLocation/CoreLocation.h>



@interface ZKAppDelegate : UIResponder <UIApplicationDelegate,CLLocationManagerDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic) dispatch_source_t timerSource;

@property (nonatomic, strong) CLLocationManager  *locationManager;

@property (nonatomic,retain)noting *inform;

@end
