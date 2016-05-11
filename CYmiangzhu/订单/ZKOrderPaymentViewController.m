//
//  ZKOrderPaymentViewController.m
//  CYmiangzhu
//
//  Created by 王小腊 on 15/12/3.
//  Copyright © 2015年 WangXiaoLa. All rights reserved.
//

#import "ZKOrderPaymentViewController.h"

@interface ZKOrderPaymentViewController ()<UIWebViewDelegate>

@property (retain, nonatomic) UIWebView *web;

@end

@implementation ZKOrderPaymentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
     self.titeLabel.text =@"订单支付";
    NSLog(@"  ---->>>>>>  %@\n",self.url);
    
    self.web =[[UIWebView alloc]initWithFrame:CGRectMake(0, 64, kDeviceWidth, TabelHeghit)];
    [self.view addSubview:self.web];
    self.web.delegate =self;
    [self.web  loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[self.url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]]];
    
     [SVProgressHUD showWithStatus:@"努力加载中"];
}

#pragma mark - webview
//完成
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    

    [SVProgressHUD dismiss];
    
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(nullable NSError *)error;
{

    [SVProgressHUD dismissWithError:@"加载失败！"];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
