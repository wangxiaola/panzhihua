//
//  UIWebView+JavaScriptAlert.h
//  uiwebtext
//
//  Created by Daqsoft-Mac on 15/4/17.
//  Copyright (c) 2015年 WangXiaoLa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZKAppDelegate.h"
@interface UIWebView (JavaScriptAlert)

-(void) webView:(UIWebView *)sender runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(id)frame;


- (BOOL)webView:(UIWebView *)sender runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(id)frame;

@end
