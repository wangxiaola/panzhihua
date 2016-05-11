//
//  HQZXViewController.h
//  WebViewDemo
//
//  Created by AndrewTzx on 14-2-17.
//  Copyright (c) 2014年 YLink. All rights reserved.
//

#import "ZKSuperViewController.h"


@interface ZKBasicViewController : ZKSuperViewController<UIWebViewDelegate>


@property (assign, nonatomic)BOOL loadButton;
@property (weak, nonatomic) UIWebView *webView;

@property (nonatomic,strong)UIButton *back720bty;

@property(copy,nonatomic)NSString *webToUrl;

@property (assign,nonatomic)NSInteger tabHeghit;

//返回两次
@property (nonatomic, assign) BOOL backTwo;

-(void)mess:(NSString*)pc;
-(void)TOback;

@end
