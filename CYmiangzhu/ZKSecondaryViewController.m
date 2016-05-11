//
//  ZKtestViewController.m
//  uiwebtext
//
//  Created by Daqsoft-Mac on 15/4/22.
//  Copyright (c) 2015年 WangXiaoLa. All rights reserved.
//

#import "ZKSecondaryViewController.h"
#import "ZKSingleton.h"
#import "JSON.h"

@interface ZKSecondaryViewController ()
{
    
    BOOL ismessg;
    
    
//    UIButton *ritButton;
}
@end

@implementation ZKSecondaryViewController

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    ismessg =NO;
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    ismessg =YES;
    
}

-(id)init{
    self =[super init];
    if (self) {
        
        self.hidesBottomBarWhenPushed =YES;
    }
    return self;
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
 
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    self.view.backgroundColor =[UIColor whiteColor];
    self.webView.backgroundColor =[self colorWithHexString:self.mycolor ];

}

#pragma mark 点击
/**
 *  返回
 */
-(void)MYnavback
{

    [self.navigationController popViewControllerAnimated:YES];

}


-(void)PenterClick
{
    
    [self.webView stringByEvaluatingJavaScriptFromString:@"IOSFA.rightbuttonclickoutfun()"];
    
}
/**
 *  十六进制转RGB
 *
 *  @param stringToConvert
 *
 *  @return
 */
-(UIColor *) colorWithHexString: (NSString *) stringToConvert
{
    NSString *cString = [[stringToConvert stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) {
        return [UIColor clearColor];
    }
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return [UIColor clearColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    
    //r
    NSString *rString = [cString substringWithRange:range];
    
    //g
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    //b
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:1.0f];
}

// 实现Observer的回调方法
-(void)tongzhi:(NSNotification *)text{
    
    
    NSString *requestString = text.object;//获取请求的绝对路径.
    
     [self mess:requestString];
    
    NSArray *components = [requestString componentsSeparatedByString:@":"];//提交请求时候分割参数的分隔符

    if (components.count>1) {
        
        NSString *sr =components[0];
        NSString *dataGBK =components[1];
        /**
         *  删除某个页面
         */
        
        if ([sr isEqualToString:@"closeUpactivity"]) {
            

            NSInteger p =self.navigationController.viewControllers.count;
            NSInteger x;
            
            NSInteger index =[dataGBK integerValue];
            if (index ==1) {
                
                x =p-1;
                
            }else if(index ==2){
            
                x =p-2;
            
            }else if (index ==3)
            {
            
                x =p-3;
            }
            
            
            UIViewController *vc =[self.navigationController.viewControllers objectAtIndex:x];
    
            [vc removeFromParentViewController];
            
        }
        

        
        /**
         *  发送数据
         */
        if ([sr isEqualToString:@"socketsendMsg"]) {
            
            NSArray *components = [requestString componentsSeparatedByString:@"socketsendMsg:"];
            
            
            NSData *JSONData = [components[1]  dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *socketDic = [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingMutableLeaves error:nil];
            NSLog(@"发送的数据  ： %@",socketDic);
            
            
            if([ZKSingleton sharedInstance].socket==nil)
            {
                [[ZKSingleton sharedInstance] socketConnectHost];
            }
            
            [[ZKSingleton sharedInstance].socket writeData:[[ZKUtil json2String:socketDic] dataUsingEncoding:NSUTF8StringEncoding] withTimeout:-1 tag:0];
            [[ZKSingleton sharedInstance].socket readDataWithTimeout:-1 tag:0];
            
        }
        /**
         *  连接心跳
         */
        if ([sr isEqualToString:@"socketInit"]) {
            /**
             *   接收消息
             *
             *  @param list 字典
             *
             *  @return return value description
             */
//            __weak typeof(self) weakSelf = self;
            [[ZKSingleton sharedInstance] mess:^(NSString *list) {
                
                if (ismessg ==YES) {
                    
//                    NSString *r =[list JSONFragment];
                    
//                    NSLog(@"收到即时消息  : %@",r);
                    
//                    [weakSelf.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"socketResultData('%@')",r]];
                    
                }
                
            }];
            
            NSArray *components = [requestString componentsSeparatedByString:@"socketInit:"];
            //创建通知
            NSNotification *notification =[NSNotification notificationWithName:@"socket" object:components[1]];
            //通过通知中心发送通知
            [[NSNotificationCenter defaultCenter] postNotification:notification];
            
            
        }
        
        
        /**
         *  返回上一界面并传值
         */
        if ([sr isEqualToString:@"pageResultfunction"]) {
            
            
            [APPDELEGATE.inform setValue:dataGBK forKey:@"popl"];
            
            [self MYnavback];
            
            
        }
        
        
    }
    
    
}


- (void)dealloc
{
    
    NSLog(@"------dealloc2--");
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
