//
//  RoutePlanViewController.h
//  officialDemoNavi
//
//  Created by LiuX on 14-9-1.
//  Copyright (c) 2014年 AutoNavi. All rights reserved.
//

#import "BaseNaviViewController.h"
#import "ZKAppDelegate.h"
@interface RoutePlanViewController : BaseNaviViewController

-(id)initKLat:(double)Klat KLon:(double)Klon WLat:(double)Wlat WLon:(double)Wlon;

-(NSString*)distanceLat:(double)lat Lon:(double)lon;


@end
