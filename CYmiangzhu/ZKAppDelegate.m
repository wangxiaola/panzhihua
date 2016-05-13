//
//  ZKAppDelegate.m
//  CYmiangzhu
//
//  Created by Daqsoft-Mac on 15/5/27.
//  Copyright (c) 2015年 WangXiaoLa. All rights reserved.
//

//测试
//#import "ZKCityPickerViewController.h"

#import "ZKAppDelegate.h"

#import "iflyMSC/IFlySpeechSynthesizer.h"
#import "iflyMSC/IFlySpeechSynthesizerDelegate.h"
#import "iflyMSC/IFlySpeechConstant.h"
#import "iflyMSC/IFlySpeechUtility.h"
#import "iflyMSC/IFlySetting.h"
#import <AMapNaviKit/AMapNaviKit.h>


/**
 *  分享sdk
 */
#import <ShareSDK/ShareSDK.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import "WXApi.h"
#import "WeiboSDK.h"

//#import "JSON.h"
//#import "ZKcarrierViewController.h"
//#import "ZKregisterViewController.h"
#import "ZKLiveInPZHViewController.h"
#import "ZKNavigationController.h"
/**
 *  支付宝
 */
#import <AlipaySDK/AlipaySDK.h>

@implementation ZKAppDelegate

#pragma mark 配置导航
- (void)configureAPIKey
{
    [AMapNaviServices sharedServices].apiKey = gaodeKEY;
    [MAMapServices sharedServices].apiKey = gaodeKEY;
}


- (void)configIFlySpeech
{
    NSString *initString = [[NSString alloc] initWithFormat:@"appid=%@,timeout=%@",@"5565581b",@"20000"];
    
    [IFlySpeechUtility createUtility:initString];
    
    [IFlySetting setLogFile:LVL_NONE];
    [IFlySetting showLogcat:NO];
    
    // 设置语音合成的参数
    [[IFlySpeechSynthesizer sharedInstance] setParameter:@"50" forKey:[IFlySpeechConstant SPEED]];//合成的语速,取值范围 0~100
    [[IFlySpeechSynthesizer sharedInstance] setParameter:@"50" forKey:[IFlySpeechConstant VOLUME]];//合成的音量;取值范围 0~100
    
    // 发音人,默认为”xiaoyan”;可以设置的参数列表可参考个 性化发音人列表;
    [[IFlySpeechSynthesizer sharedInstance] setParameter:@"xiaoyan" forKey:[IFlySpeechConstant VOICE_NAME]];
    
    // 音频采样率,目前支持的采样率有 16000 和 8000;
    [[IFlySpeechSynthesizer sharedInstance] setParameter:@"8000" forKey:[IFlySpeechConstant SAMPLE_RATE]];
    
    // 当你再不需要保存音频时，请在必要的地方加上这行。
    [[IFlySpeechSynthesizer sharedInstance] setParameter:nil forKey:[IFlySpeechConstant TTS_AUDIO_PATH]];
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //从沙盒中加载用户信息
    [[ZKUserInfo sharedZKUserInfo] loadUserInfo];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.inform =[[noting alloc]init];
    /**
     *  用户信息
     */
//    [self userlocanting];
    
    // 初始化百度统计SDK
    [self startBaiduMobStat];
    
//    [self myNotification];
    //注册通知
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(socket:) name:@"socket" object:nil];

       //高德地图 Key
    
    [self configureAPIKey];
    [self configIFlySpeech];
    [self initSDK];

    UITabBarItem *item = [UITabBarItem appearance];
    [item setTitleTextAttributes:@{NSForegroundColorAttributeName :[UIColor lightGrayColor]} forState:UIControlStateNormal];
    [item setTitleTextAttributes:@{NSForegroundColorAttributeName :CYBColorGreen} forState:UIControlStateSelected];
    
    ZKLiveInPZHViewController *kangyangVc =[[ZKLiveInPZHViewController alloc] init];
    ZKNavigationController *nav =[[ZKNavigationController alloc] initWithRootViewController:kangyangVc];
    nav.navigationBarHidden =YES;
    self.window.rootViewController = nav;

    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;

}

/**
 *  获取udid
 *
 *  @return udid
 */
-(NSString*) uuid {
    CFUUIDRef puuid = CFUUIDCreate( nil );
    CFStringRef uuidString = CFUUIDCreateString( nil, puuid );
    NSString * result = CFBridgingRelease(CFStringCreateCopy( NULL, uuidString));
    CFRelease(puuid);
    CFRelease(uuidString);
    return result;
}

-(void)userlocanting
{

    self.locationManager = [[CLLocationManager alloc]init];
    _locationManager.delegate = self;
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    _locationManager.distanceFilter = 10;
    
    if (IsIOS8) {
        
        
        [_locationManager requestAlwaysAuthorization];
        
    }
    
    [_locationManager startUpdatingLocation];


}

/**
 *  初始化百度统计SDK
 */
- (void)startBaiduMobStat {
    
    BaiduMobStat* statTracker = [BaiduMobStat defaultStat];
    // 此处(startWithAppId之前)可以设置初始化的可选参数，具体有哪些参数，可详见BaiduMobStat.h文件，例如：
    statTracker.shortAppVersion  = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    statTracker.enableDebugOn = NO;
    statTracker.logStrategy = BaiduMobStatLogStrategyAppLaunch;
    statTracker.monitorStrategy = BaiduMobStatMonitorStrategyNone;
    [statTracker startWithAppId:BaiduID];
}

#pragma mark 通知
-(void)myNotification
{
    
    
    /**
     *   接收消息
     *
     *  @param list 字典
     *
     *  @return return value description
     */
    
    /*****
     
    [[ZKSingleton sharedInstance]mess:^(NSDictionary *list) {
        
        
        NSLog(@" -++通知+- %@",list);
        
        
        UILocalNotification *notification = [[UILocalNotification alloc] init];
        //设置0秒之后
        NSDate *pushDate = [NSDate dateWithTimeIntervalSinceNow:0];
        if (notification != nil) {
            // 设置推送时间
            notification.fireDate = pushDate;
            // 设置时区
            notification.timeZone = [NSTimeZone defaultTimeZone];
            // 推送声音
            notification.soundName = UILocalNotificationDefaultSoundName;
            //名字
            notification.alertAction =[NSString stringWithFormat:@"%@",[list valueForKey:@"notify_title"]];
            // 推送内容
            notification.alertBody = [list valueForKey:@"notify_content"];
            //显示在icon上的红色圈中的数子
            notification.applicationIconBadgeNumber = 1;
            notification.alertTitle =[list valueForKey:@"notify_url"];
            notification.alertLaunchImage =[list valueForKey:@"notify_pic"];
            //设置userinfo 方便在之后需要撤销的时候使用
            NSDictionary *info = [NSDictionary dictionaryWithObject:@"name"forKey:@"key"];
            notification.userInfo = info;
            //添加推送到UIApplication
            UIApplication *app = [UIApplication sharedApplication];
            [app scheduleLocalNotification:notification];
            
        }
    }];
    
    ****/

}
-(void)socket:(NSNotification *)text
{

//    NSString *pd =text.object;
//    NSDictionary *dc =[pd JSONValue];
//    
//    NSLog(@"   心跳参数 %@",dc);
//    
//    /**
//     *  及时通信
//     */
//    
//  
//         
//    //192.168.0.147
//    [ZKSingleton sharedInstance].socketHost = @"192.168.2.30";// host设定
//    [ZKSingleton sharedInstance].socketPort = 5222;// port设定
//    [ZKSingleton sharedInstance].dicc =dc;
//    // 在连接前先进行手动断开
//    [ZKSingleton sharedInstance].socket.userData = SocketOfflineByUser;
//    [[ZKSingleton sharedInstance] cutOffSocket];
//    
//    // 确保断开后再连，如果对一个正处于连接状态的socket进行连接，会出现崩溃
//    [ZKSingleton sharedInstance].socket.userData = SocketOfflineByServer;
//    [[ZKSingleton sharedInstance] socketConnectHost];
//    
//    
//    if([ZKSingleton sharedInstance].socket==nil)
//    {
//        [[ZKSingleton sharedInstance] socketConnectHost];
//    }
//    
//    
//    NSData *d =nil;
//    [[ZKSingleton sharedInstance].socket writeData:d withTimeout:-1 tag:0];
//    [[ZKSingleton sharedInstance].socket readDataWithTimeout:-1 tag:0];
//    
//    
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"socket" object:nil];
//    
 

    
}



-(void)initSDK
{
    
    [ShareSDK registerApp:@"9fa75a5da4e0"];//字符串api20为您的ShareSDK的AppKey
    
    
    //当使用新浪微博客户端分享的时候需要按照下面的方法来初始化新浪的平台
    [ShareSDK  connectSinaWeiboWithAppKey:xinlangweipoID
                                appSecret:xinlangweipoSecret
                              redirectUri:@"http://www.sharesdk.cn"
                              weiboSDKCls:[WeiboSDK class]];
    

//    添加腾讯微博应用 注册网址 http://dev.t.qq.com
    
    [ShareSDK connectTencentWeiboWithAppKey:tenxunweipoKEY
                                  appSecret:tenxunweipoSecret
                                redirectUri:@"http://www.sharesdk.cn"];
    
    //添加QQ空间应用  注册网址  http://connect.qq.com/intro/login/
    [ShareSDK connectQZoneWithAppKey:tenxunQQID
                           appSecret:tenxunQQKEY
                   qqApiInterfaceCls:[QQApiInterface class]
                     tencentOAuthCls:[TencentOAuth class]];
    
    
    /*
    //添加QQ应用  注册网址  http://open.qq.com/
    [ShareSDK connectQQWithQZoneAppKey:tenxunQQID
                     qqApiInterfaceCls:[QQApiInterface class]
                       tencentOAuthCls:[TencentOAuth class]];
    */
     
    /*
    //添加微信应用 注册网址 http://open.weixin.qq.com
    [ShareSDK connectWeChatWithAppId:weixinID
                           wechatCls:[WXApi class]];
     */
    
    [ShareSDK connectWeChatWithAppId:weixinID
                           appSecret:weixinSecret
                           wechatCls:[WXApi class]];
    
       
}

- (BOOL)application:(UIApplication *)application
      handleOpenURL:(NSURL *)url
{
    return [ShareSDK handleOpenURL:url
                        wxDelegate:self];
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    
    if ([url.host isEqualToString:@"safepay"]) {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result00002\n = %@",resultDic);
        }];
    }
    
    return [ShareSDK handleOpenURL:url
                 sourceApplication:sourceApplication
                        annotation:annotation
                        wxDelegate:self];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

-(void)application:(UIApplication*)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    
    
//    ZKMessagepromptView * mess =[[ZKMessagepromptView alloc] initImage:notification.alertLaunchImage Message:notification.alertBody Fid:[[ZKUtil imageUrls:notification.alertAction] objectAtIndex:1] Name:[[ZKUtil imageUrls:notification.alertAction] objectAtIndex:0] ];
//    mess.content =self;
//    mess.url =notification.alertTitle;
//    [mess show];
//    
//    // 图标上的数字减1
//    application.applicationIconBadgeNumber -=0;
    
}


#pragma mark 获取位置
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *currLocation = [locations lastObject];
    
    NSString *lan =[NSString stringWithFormat:@"%f",currLocation.coordinate.latitude];
    NSString *lon =[NSString stringWithFormat:@"%f",currLocation.coordinate.longitude];
    
    [ZKUtil MyValue:lan MKey:@"Latitude"];
    [ZKUtil MyValue:lon MKey:@"Longitude"];
    
    [_locationManager stopUpdatingLocation];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
