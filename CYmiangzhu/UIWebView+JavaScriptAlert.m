//
//  UIWebView+JavaScriptAlert.m
//  uiwebtext
//
//  Created by Daqsoft-Mac on 15/4/17.
//  Copyright (c) 2015年 WangXiaoLa. All rights reserved.
//

#import "UIWebView+JavaScriptAlert.h"
#import "Toast+UIView.h"
#import "ZKMoreReminderView.h"
#import "noting.h"
@implementation UIWebView (JavaScriptAlert)

- (void)webView:(UIWebView *)sender runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(id)frame {
    
    if ([message  rangeOfString:@"iphonefun"].location !=NSNotFound) {
        
        NSRange range = [message rangeOfString:@"iphonefun:"];//获取$file/的位置
        NSString *xp = [message substringFromIndex:range.location +
                        range.length];//开始截取
        NSString *xxp = [xp stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
        //创建通知
        NSNotification *notification =[NSNotification notificationWithName:@"tongzhi" object:xxp];
        //通过通知中心发送通知
        [[NSNotificationCenter defaultCenter] postNotification:notification];
        
        //[APPDELEGATE.inform setValue:xxp forKey:@"popl"];

    }else{
        
        [[APPDELEGATE window] makeToast:message];
    }
}

//static BOOL diagStat = NO;
static NSInteger bIdx = -1;

- (BOOL)webView:(UIWebView *)sender runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(id)frame {
    
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
    
    ZKMoreReminderView *more =[[ZKMoreReminderView alloc]initTs:@"操作提示" MarkedWords:message ];
    
    [more sectec:^(int pgx) {
        
        bIdx =pgx;
        
    }];
    
    [more show];
    bIdx = -1;
    
    while (bIdx==-1) {
        //[NSThread sleepForTimeInterval:0.2];
        [[NSRunLoop mainRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.1f]];
    }
    
    
    if (bIdx == 0){//取消;
      //  diagStat = NO;
        
        NSLog(@" 1111111");
        
        return NO;
    }
    else if (bIdx == 1) {//确定;
      //  diagStat = YES;
        
                NSLog(@" 2222222 ");
        
        return YES;
        
    }
    
    
    return YES;
    
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    NSLog(@"  333333   %ld",(long)buttonIndex);
    
    bIdx = buttonIndex;

    
}

@end
