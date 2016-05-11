//
//  ZKMapNavController.h
//  CYmiangzhu
//
//  Created by Daqsoft-Mac on 15/5/27.
//  Copyright (c) 2015年 WangXiaoLa. All rights reserved.
//

#import "BaseNaviViewController.h"
#import "ZKAppDelegate.h"
//#import "UIKeyboardViewController.h"

//#define MCRelease(x)

@interface ZKMapNavController : BaseNaviViewController
//<UIKeyboardViewControllerDelegate>
//{
//    UIKeyboardViewController *keyBoardController;
//}


-(id)initKLat:(double)Klat KLon:(double)Klon Kadder:(NSString*)kadder WLat:(double)Wlat WLon:(double)Wlon WAdder:(NSString*)wadder code:(NSString*)city;


@end
