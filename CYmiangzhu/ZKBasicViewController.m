//
//  HQZXViewController.m
//  WebViewDemo
//
//  Created by AndrewTzx on 14-2-17.
//  Copyright (c) 2014年 YLink. All rights reserved.
//

#import "ZKBasicViewController.h"
#import "Toast+UIView.h"
#import "ZKCity.h"

#import "ZKMoreReminderView.h"
#import "ZKHttp.h"
#import "ZKUtil.h"
#import "JSON.h"
#import "JSONKit.h"
#import "SVProgressHUD.h"
#import "MJPhoto.h"
#import "MJPhotoBrowser.h"
#import "ZKpoperFanView.h"
#import "ZKmerchandiseView.h"
#import "ZKSecondaryViewController.h"
#import "ZYQAssetPickerController.h"
#import "ZKregisterViewController.h"
#import "CustomCalendarViewController.h"
#import "ZKProduction.h"
#import "ZKCommitOrderViewController.h"
#import "ZKHotelCommitOrderViewController.h"
#import "ZKMutiCalendarViewController.h"

#import <JavaScriptCore/JavaScriptCore.h>
/**
 *
 * 照片
 */
#import "ZKCommonImagePickerController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "ZYQAssetPickerController.h"
#import "MBProgressHUD+Add.h"
/**
 *  二维码
 *
 *  @return
 */
#import "ZKZBarRootViewController.h"
/**
 *  音乐
 *
 *  @return
 */
//#import "AudioStreamer.h"

/**
 *  地图
 *
 *  @return
 */
#import "MMLocationManager.h"
#import <CoreLocation/CoreLocation.h>

#import "ZKMapNavController.h"

#import "RoutePlanViewController.h"

#import "ZKAppDelegate.h"
/**
 *  推荐表
 *
 *  @return
 */
#import "ZKrecommendedViewController.h"
#import "ZKnearListViewController.h"//附近地图

#import "ZKVideoViewController.h"

#import "MONActivityIndicatorView.h"
#import "ZKActivitiesShareViewController.h"
#import "YYSearchBar.h"

//选择城市
#import "ZKCityPickerViewController.h"
#import "ZKTimePickerViewController.h"
#import "LSPaoMaView.h"
//行程订单
#import "ZKStrokeOrderViewController.h"


//支付宝
#import "Order.h"
#import "DataSigner.h"
#import <AlipaySDK/AlipaySDK.h>
#import "APAuthV2Info.h"

#define appDocumentPath [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject]

int popLoginCount = 0;

@interface ZKBasicViewController ()<MJPhotoBrowserDelegate,ZKpoperFanViewDelegate,ZKmerchandiseViewDelegate,UIActionSheetDelegate,ZKCommonImagePickerControllerDelegate,ZYQAssetPickerControllerDelegate,UINavigationControllerDelegate,UIScrollViewDelegate,CLLocationManagerDelegate,UIImagePickerControllerDelegate,MONActivityIndicatorViewDelegate,UISearchBarDelegate,CustomCalendarViewControllerDelegate,ZKMutiCalendarViewControllerDelegate,ZKCityPickerViewControllerDelegate>

@property (nonatomic, strong) CLLocationManager  *locationManager;


@property (nonatomic, strong) AMapNaviPoint* startPoint;
@property (nonatomic, strong) AMapNaviPoint* endPoint;


@property (strong,nonatomic) UIImagePickerController *imagePicker;


@property (strong, nonatomic) YYSearchBar *searchBar;


@end


@implementation ZKBasicViewController
{
    
    ZKpoperFanView *duoxuanPop;
    
    ZKmerchandiseView *duoxuanMer;
    
    NSString *sy;
    
    NSString *pur;
    
    NSString *webUrl;
    
    NSArray *webUrlArray;
    
    ZKMoreReminderView *more ;
    /**
     *  头部
     */
    
    LSPaoMaView *lsPaoMaView;
    
    NSString *name;
    
    BOOL isRitbutton;
    /***/
    
    UIButton *stickButton;
    
    NSString * stick;
    
    NSArray *poptitisArray;
    
    /**
     *  照片
     */
    ZKCommonImagePickerController *imagePickerController;
    
    NSMutableDictionary *photographDic;//记录照片
    
    NSInteger numphotograph;//记录照片标签
    
    NSData *scData;
    
    UIImageView *errorImage;
    
    BOOL isPost;
    
    BOOL isShow;
    
    NSInteger record;
    
    /**
     *  显示大图
     */
    UIImageView *fotoImage;
    NSMutableArray *imageArray;
    
    NSString *_webUrl;//当前加载的url；
    
    /**
     *  地图相关
     */
    double ToLatitude;
    
    double ToLongitude;
    
    BOOL isjuli;//是否是距离获取
    
    NSString *endOf;
    
    NSString *toAdder;
    
    RoutePlanViewController *rou;
    
    BOOL z_ishidhead;
    
    /**
     *  上传视屏
     */
    NSString *videoUrl;
    
    
    MONActivityIndicatorView *indicatorView;
    
    /**
     *  上传视屏链接
     */
    
    NSString *spHtml;
    
    BOOL isSPno;
    
    BOOL isLogined;
}


@synthesize back720bty;

- (YYSearchBar *)searchBar
{
    if (_searchBar == nil) {
        _searchBar = [[YYSearchBar alloc] initWithFrame:CGRectMake(0, 0.0f, self.navigationBarView.frame.size.width-100, 60.0f)];
        _searchBar.center =CGPointMake(self.navigationBarView.frame.size.width/2, self.navigationBarView.frame.size.height/2+5);
        _searchBar.backgroundColor = [UIColor clearColor];
        _searchBar.delegate = self;
        
    }
    return _searchBar;

}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    
    if (strIsEmpty(name) ==0) {
        
        [self nameGD];
    }
  
    
    [self navSupFrme];
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tongzhi:) name:@"tongzhi" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifClick:) name:@"notifClick" object:nil];
    

    [self.webView stringByEvaluatingJavaScriptFromString:@"Z_onResume()"];
    
    if ([name isEqualToString:@"我的游记"]) {
        [self.rittBarButtonItem setImage:[UIImage imageNamed:@"my_cell_4"] forState:UIControlStateNormal];
    }
    

    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
}

-(void)navSupFrme
{
    NSLog(@"%@", self.webToUrl);
    if ([self.webToUrl rangeOfString:@"z_ishidhead=true"].location !=NSNotFound) {
        self.navigationBarView.layer.opacity =0;
        self.webView.frame =self.view.bounds;
    }else if ([self.webToUrl rangeOfString:@"z_ishidhead=false"].location !=NSNotFound) {
        self.navigationBarView.layer.opacity =1;
        self.webView.frame =CGRectMake(0, navigationHeghit, self.view.frame.size.width, TabelHeghit-self.tabHeghit);
    }
    
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    self.loadButton = YES;
    
    
    [SVProgressHUD dismiss];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"tongzhi" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"notifClick" object:nil];

}

-(id)init
{
    self =[super init];
    if (self) {
        
        //self.hidesBottomBarWhenPushed =YES;
    }
    
    return self;

}
- (void)viewDidLoad
{
    [super viewDidLoad];

    UIWebView *webView =[[UIWebView alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, TabelHeghit-self.tabHeghit)];
    webView.delegate =self;
 
    
    webView.scrollView.delegate =self;
    webView.scrollView.bounces =NO;
    [self.view addSubview:webView];
    self.webView = webView;
    
    
    JSContext *context = [self.webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    
    context[@"jsCalliOS"] = ^(NSString*one, NSString *two, NSString *three) {


        /*
         *生成订单信息及签名
         */
        //将商品信息赋予AlixPayOrder的成员变量
        Order *order = [[Order alloc] init];
        order.partner = PARTNER;
        order.seller = SELLER;
        order.tradeNO = three; //订单ID（由商家自行制定）
        order.productName = one; //商品标题
        order.productDescription = [NSString stringWithFormat:@"%@-总价%@",one,two]; //商品描述
        order.amount =two; //商品价格
        order.notifyURL =  @"http://pzh.geeker.com.cn/planFrontNotify.jkb"; //回调URL
        
        order.service = @"mobile.securitypay.pay";
        order.paymentType = @"1";
        order.inputCharset = @"utf-8";
        order.itBPay = @"30m";
        order.showUrl = @"m.alipay.com";
        
        //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
        NSString *appScheme = @"CYmiangzhu";
        
        //将商品信息拼接成字符串
        NSString *orderSpec = [order description];
        NSLog(@"orderSpec = %@",orderSpec);
        
        //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
        id<DataSigner> signer = CreateRSADataSigner(PRIVATEKEY);
        NSString *signedString = [signer signString:orderSpec];
        
        //将签名成功字符串格式化为订单字符串,请严格按照该格式
        NSString *orderString = nil;
        if (signedString != nil) {
            orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                           orderSpec, signedString, @"RSA"];
            
            [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
                
                NSString *result =[resultDic valueForKey:@"result"];
                NSLog(@" 支付宝  ＝＝  %@\n",resultDic);
                
                if (strIsEmpty(result) ==0) {
                    
                    [SVProgressHUD showSuccessWithStatus:@"支付成功" duration:1.5];
                    
                    
                }else{
                    
                    [SVProgressHUD showErrorWithStatus:@"支付失败" duration:1.5];
                    
                    
                }
                
        
                [self.navigationController popViewControllerAnimated:YES];
                
            }];
        }

        
    };
    


    z_ishidhead =NO;
    
    isPost =NO;
    
    isjuli =NO;
    
    record =0;
    
    ToLatitude =[[ZKUtil ToTakeTheKey:@"Latitude"] doubleValue];
    ToLongitude =[[ZKUtil ToTakeTheKey:@"Longitude"] doubleValue];
    toAdder =[ZKUtil ToTakeTheKey:@"adder"];
    
    
    [self.leftBarButtonItem removeFromSuperview];
    
    
    self.leftBarButtonItem = [[UIButton alloc]initWithFrame:CGRectMake(2, 20, buttonItemWidth, buttonItemWidth)];
    [self.leftBarButtonItem setImage:[UIImage imageNamed:@"backimage"] forState:UIControlStateNormal];
    [self.leftBarButtonItem addTarget:self action:@selector(navback) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationBarView  addSubview:self.leftBarButtonItem];
    
    self.leftBarButtonItem.layer.opacity =1;
    
    self.rittBarButtonItem =[[UIButton alloc]initWithFrame:CGRectMake(kDeviceWidth-2-40, 20, 40, 40)];
    self.rittBarButtonItem.backgroundColor =[UIColor clearColor];
    self.rittBarButtonItem.titleLabel.textColor =[UIColor whiteColor];
    self.rittBarButtonItem.titleLabel.font =[UIFont systemFontOfSize:12];
    self.rittBarButtonItem.titleLabel.font =[UIFont boldSystemFontOfSize:12];
    [self.rittBarButtonItem addTarget:self action:@selector(enterClick) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationBarView addSubview: self.rittBarButtonItem];
    
    self.rittBarButtonItem2 =[[UIButton alloc]initWithFrame:CGRectMake(kDeviceWidth-2-70, 20, 40, 40)];
    self.rittBarButtonItem2.backgroundColor =[UIColor clearColor];
    self.rittBarButtonItem2.titleLabel.textColor =[UIColor whiteColor];
    self.rittBarButtonItem2.titleLabel.font =[UIFont systemFontOfSize:12];
    self.rittBarButtonItem2.titleLabel.font =[UIFont boldSystemFontOfSize:12];
    [self.rittBarButtonItem2 addTarget:self action:@selector(enterClick2) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationBarView addSubview: self.rittBarButtonItem2];
    
    
    photographDic =[[NSMutableDictionary alloc] initWithCapacity:0];
    numphotograph =0;
    
    
    fotoImage =[[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2,  self.webView.frame.size.height/2, 1, 1)];
    fotoImage.backgroundColor =[UIColor clearColor];
    [self.view addSubview:fotoImage];
    
    imageArray =[[NSMutableArray alloc]initWithCapacity:0];
    
    stickButton =[[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width-55, self.view.frame.size.height-55, 35, 35)];
    stickButton.backgroundColor =[UIColor clearColor];
    [stickButton setBackgroundImage:[UIImage imageNamed:@"top"] forState:UIControlStateNormal];
    [stickButton addTarget:self action:@selector(stickButton) forControlEvents:UIControlEventTouchUpInside];
    stickButton.layer.opacity =0;
    [self.view addSubview:stickButton];
    
    [self subSearchBar];

    
    [APPDELEGATE.inform addObserver:self forKeyPath:@"popl" options:NSKeyValueObservingOptionNew context:nil];
    
    
    indicatorView = [[MONActivityIndicatorView alloc] init];
    indicatorView.delegate = self;
    indicatorView.numberOfCircles = 4;
    indicatorView.radius = 10;
    indicatorView.internalSpacing = 5;
    indicatorView.center =self.webView.center;
    [self.view addSubview:indicatorView];
    
    [indicatorView startAnimating];
    
    
    [self loadWeebUrl];
    
    [self subTitle];
    
}

/**
 *  拦截搜索框
 */
- (void)subSearchBar
{
    
    [self.navigationBarView addSubview:self.searchBar];
    
    if ([self.webToUrl rangeOfString:@"setnew_head_search="].location != NSNotFound) {  //酒店住宿
        
        self.searchBar.placeString = @"景点地名/酒店";

        
    }else if ([self.webToUrl rangeOfString:@"setnew_head_search_shangjia="].location != NSNotFound){ //特色美食和休闲娱乐
    
        self.searchBar.placeString = @"商家名/地名";

        
    }else if ([self.webToUrl rangeOfString:@"setnew_head_search_gouwu="].location != NSNotFound){ //特色购物
    
        self.searchBar.placeString = @"商家名/特产名";

        
    }else if ([self.webToUrl rangeOfString:@"setnew_head_search_zixun="].location != NSNotFound){ //旅游资讯
    
        self.searchBar.placeString = @"活动/旅游资讯";

        
    }else if ([self.webToUrl rangeOfString:@"setnew_head_search_jqjd"].location != NSNotFound){ //720全景
    
        self.searchBar.placeString = @"景区/景点名";

        
    }else if ([self.webToUrl rangeOfString:@"setnew_head_search_all="].location != NSNotFound){ //分类模块
    
        self.searchBar.placeholder = @"景区地名/酒店";

        
    }else{ //全都找不到
    
        [self.searchBar removeFromSuperview];
        
    }
    
}


/**
 *  从url中拦截标题
 */
- (void)subTitle
{
    //从url中截取标题
    
    if (self.searchBar.superview) {
        return;
    }
    
    NSString *para = @"(^|&|\\?)+z_pagetitle=+([^&]*)(&|$)" ;
    
    NSRegularExpression * regex = [NSRegularExpression regularExpressionWithPattern:para options:0 error:nil];
    
    NSArray * result = [regex matchesInString:self.webToUrl options:0 range:NSMakeRange(0, self.webToUrl.length)];
    
    for (NSTextCheckingResult *match in result) {
        
        NSString *strResult = [self.webToUrl substringWithRange:match.range];
        
        NSRange strRange = [strResult rangeOfString:@"z_pagetitle="];
        
        name = [[strResult substringFromIndex:strRange.location + strRange.length] stringByRemovingPercentEncoding];
        
        NSRange r = [name rangeOfString:@"&"];
        
        if (r.location != NSNotFound) {
            name = [name substringToIndex:r.location];
        }
        
    }
    
    
    if(name.length==0 || name==nil){
      name = @"畅游攀枝花";
    }
    
    [self nameGD];
    
}

-(void)startAnimating
{
    
    [indicatorView startAnimating];
}
#pragma mark 通知

/**
 *  及时通信通知
 *
 *  @param text
 */
-(void)notifClick:(NSNotification*)text
{
    
    ZKSecondaryViewController *sec =[[ZKSecondaryViewController alloc]init];
    sec.webToUrl =text.object;
    [self.navigationController pushViewController:sec animated:YES];
    
}


-(void)mess:(NSString*)pc;
{

    
//    hreftodaohang2:endPoints=31.133062,104.395407&endAddr=长江西路一段314号附近&cityCode=0838
    
    NSString *requestString =pc;
    
    NSArray *components = [requestString componentsSeparatedByString:@":"];//提交请求时候分割参数的分隔符

    NSLog(@" == 900= == %@",pc);
    
    
    /**
     *  判断是否是url
     */
    NSString*url =components[0];
    
    
    if ([url isEqualToString:@"http"]||[url isEqualToString:@"https"]) {
        
        NSArray *p =[requestString componentsSeparatedByString:@"//"];
        
        webUrl =p[1];
        
        
    }
    
    if (components.count>1) {
        
        NSString *sr =components[0];
        NSString *dataGBK =components[1];
        
        
        
        
    
        /**
         *  选择日期
         */
        if ([sr isEqualToString:@"toSelectDatePage"]) {
            
            CustomCalendarViewController *datePicker = [[CustomCalendarViewController alloc] init];
            datePicker.delegate = self;
//            [datePicker setDate:dataGBK];
            
            [self presentViewController:datePicker animated:YES completion:nil];
//            [self.navigationController pushViewController:datePicker animated:YES];
        }
        

        if ([sr isEqualToString:@"toSelectDateTwoPage"]) {
            ZKMutiCalendarViewController *datePickerTwo = [[ZKMutiCalendarViewController alloc] init];
            datePickerTwo.delegate = self;
            [self presentViewController:datePickerTwo animated:YES completion:nil];
        }
        
        /**
         *  分享
         */
        
        if ([sr isEqualToString:@"toSharePage"]) {
            
            
            NSArray *comArray = [pc componentsSeparatedByString:@"?"];
            
            NSArray *dataArray =[comArray[1] componentsSeparatedByString:@"&"];
            
            NSString *title =[dataArray[0] componentsSeparatedByString:@"="][1];
            NSString *content =[dataArray[1] componentsSeparatedByString:@"="][1];
            NSString *imageUrl =[dataArray[2] componentsSeparatedByString:@"="][1];
            
            NSString *linkUrl = @"zz";
            if (dataArray.count >= 4) {
                
               linkUrl =[dataArray[3] componentsSeparatedByString:@"="][1];
            }
            
            NSString* headerData=content;
            headerData = [headerData stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];  //去除掉首尾的空白字符和换行字符
            headerData = [headerData stringByReplacingOccurrencesOfString:@"\r\n\r\n\r\n\t" withString:@"\n"];
//            headerData = [headerData stringByReplacingOccurrencesOfString:@"\n" withString:@""];
            
            ZKActivitiesShareViewController *activ =[[ZKActivitiesShareViewController alloc]initImageUrl:imageUrl Theme:title Name:headerData Lurl:linkUrl];

            [self.navigationController pushViewController:activ animated:YES];
            
            
        }
        // toSharePage:Share?title=攀枝花金雅仙客&content=&nbsp;&nbsp;&nbsp; 攀枝花金雅仙客性价比高，住宿环境、通风采光较好;&imageUrl=http://www.tpanzhihua.com/sc_pzh/upload/file/201509/17144853yacb.jpg&linkUrl=http://192.168.0.217:8018/desc_hotel.aspx?z_isheadback=true&id=100233508&z_pagetitle=攀枝花金雅仙客
  
        /*
         toSharePage:Share?title=攀枝花金海开元名都大酒店&coƒntent=
        攀枝花金海开元名都大酒店位于机场路，地处攀枝花市中心，西临疾病预防控制中心；地理位置优越，闹中取静、环境舒适。
        
        
        攀枝花金海开元名都大酒店主楼高28层，拥有装修时尚、温馨舒适的各式客房，房内设施齐全。
        
        
        酒店内有各式餐厅，西西里西餐厅提供中西自助早餐、晚餐与西餐零点，精品荟萃；普天乐中餐厅由资深主厨掌勺，奉上经典川、粤美食和当地特色菜肴。酒店另设8个大小不等的会议室，可为商旅客人提供各种会议服务。此外，酒店还有悦蓝山大堂吧、名都西点饼屋、一品盛世包厢群，并提供送餐、洗衣、叫醒、免费停车、外币兑换等服务，让您拥有非同寻常的入住体验。
        &imageUrl=http://www.tpanzhihua.com/sc_pzh/upload/file/201509/17135825yuui.jpg&linkUrl=http://192.168.0.217:8018/desc_hotel.aspx?z_isheadback=true&id=100233507&z_pagetitle=攀枝花金海开元名都大酒店
        */
        
        
        /**
         *  选择城市
         */

        if ([sr isEqualToString:@"toSelectOfPathPage"]){
        
            ZKCityPickerViewController *vc =[[ZKCityPickerViewController alloc]init];
            vc.delegate =self;
            [self presentViewController:vc animated:YES completion:^{
                
            }];

        
        }
        
        
        /**
         *  取得手机唯一码
         */
        if ([sr isEqualToString:@"getPhoneKey"]) {
            
            
    
            CFUUIDRef puuid = CFUUIDCreate( nil );
            CFStringRef uuidString = CFUUIDCreateString( nil, puuid );
            NSString * result = CFBridgingRelease(CFStringCreateCopy( NULL, uuidString));
            CFRelease(puuid);
            CFRelease(uuidString);
            
            [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"IOSFA.getphonekeyresult('%@')",result]];
        }
        
        /**
         *  上传游记/视屏
         */
        if ([sr isEqualToString:@"uploadMulsfileToserver"]) {
            
            
            NSRange range = [pc rangeOfString:@"uploadMulsfileToserver:fot_1,"];
            
            
            
            if (range.location!=NSNotFound) {
            
               NSArray *comArray = [pc componentsSeparatedByString:@"uploadMulsfileToserver:fot_1,"];
               NSArray *keyArray = [comArray[1] componentsSeparatedByString:@","];
              
               NSData *imagedata = photographDic[@"fot_1"];
                
                NSString *acceptName = keyArray[1]; //Filedata
                
                NSArray *array1 =[keyArray[0] componentsSeparatedByString:@"?"]; //http://zx.tpanzhihua.com/app/rest.do和 method=uploadFile&seccode=9C1438BE6CF68E52E0B20C6C4259C250F6913438DABE0219
                
                NSString *url = array1[0]; //http://zx.tpanzhihua.com/app/rest.do
                
                NSArray *keyValues = [array1[1] componentsSeparatedByString:@"&"];//method=uploadFile和seccode=9C1438BE6CF68E52E0B20C6C4259C250F6913438DABE0219
                
                NSMutableDictionary *dic =[NSMutableDictionary dictionary];
                
                for (int i=0; i<keyValues.count; i++) {
                    
                    NSArray *dccArray =[keyValues[i] componentsSeparatedByString:@"="];
                    [dic setObject:dccArray[1] forKey:dccArray[0]];
                }
            
                [ZKHttp youjiPostImage:url params:dic Data:imagedata name:acceptName success:^(id responseObj) {
                   
//                   NSLog(@"成功－－1－%@", responseObj);
                   id redic = [NSJSONSerialization JSONObjectWithData:responseObj options:0 error:nil];
                    
                     [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"fun_z_overuploadOneofpic('%@')",[redic JSONRepresentation]]];
            
               } failure:^(NSError *error) {
                   NSLog(@"失败");
               }];
 
                
            }else{
                
                NSArray *comArray = [pc componentsSeparatedByString:@"uploadMulsfileToserver:vodio,"];
            
            
                NSArray *keyArray = [comArray[1] componentsSeparatedByString:@","];
                
                NSString *viodUrl =[keyArray[0] stringByReplacingOccurrencesOfString:@"?" withString:@""];
                
                NSString *viodKey =keyArray[1];
                
                NSArray *dicArray =[keyArray[2] componentsSeparatedByString:@"&"];
                
                NSMutableDictionary *dic =[NSMutableDictionary dictionary];
                
                NSURL *pcurl = [NSURL URLWithString:[ZKUtil ToTakeTheKey:@"shiping"]];//videoUrl

                NSData *videoData = [NSData dataWithContentsOfURL:pcurl];
                
                NSString *pictureDataString =[videoData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];

                
                for (int i=0; i<dicArray.count; i++) {
                    NSArray *dccArray =[dicArray[i] componentsSeparatedByString:@"="];
                    [dic setObject:dccArray[1] forKey:dccArray[0]];
                }
                
                [dic setObject:pictureDataString forKey:viodKey];
                
                [ZKHttp normalPost:viodUrl params:dic success:^(id responseObj) {

                    id redic = [NSJSONSerialization JSONObjectWithData:responseObj options:0 error:nil];
                    [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"fun_z_overuploadOneofpic('%@')",[redic JSONRepresentation]]];
                    
                    
                } failure:^(NSError *error) {
                    
                    [self.view makeToast:@"上传失败"];
                    
                }];
            
            }
      
            //            NSArray *comArray = [pc componentsSeparatedByString:@"uploadMulsfileToserver:"];
            //
            //            NSArray *keyArray = [comArray[1] componentsSeparatedByString:@","];
            //
            //
            //            if (strIsEmpty(videoUrl) ==0) {
            //
            //                NSMutableDictionary *dic =[NSMutableDictionary dictionary];
            //                NSString *dic_0 =keyArray[3];
            //
            //                NSArray *dicArray_0 =[dic_0 componentsSeparatedByString:@"&"];
            //
            //                for (int i =0; i<dicArray_0.count; i++) {
            //
            //                    NSArray *dicArray_1 =[dicArray_0[i] componentsSeparatedByString:@"="];
            //
            //                    [dic setObject:dicArray_1[1] forKey:dicArray_1[0]];
            //                }
            //
            //
            //
            //                [ZKHttp updata:keyArray[1] params:dic typey:keyArray[0] name:keyArray[2] vodioUrl:videoUrl success:^(id responseObj) {
            //
            //                } failure:^(NSError *error) {
            //
            //                    [[APPDELEGATE window] makeToast:@"上传出错了"];
            //
            //                } jingdu:^(float p) {
            //
            //                    NSLog(@"  *****  == ****  %f",p);
            //
            //                    [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"fun_z_returnuploadOneofpicprogress('%f')",p]];
            //
            //                }];
            //
            //
            //            }else{
            //
            //                [self.view makeToast:@"正在保存，请稍等！"];
            //
            //
            //            }
            
            
        }
        
        /**
         *  录视频
         */
        if ([sr isEqualToString:@"openlushiping"]) {
            
            
            videoUrl =nil;
            isSPno = NO;
            [self myimagePicker];
            
            
        }
        
        /**
         *  先录视屏
         */
        if ([sr isEqualToString:@"openlushipingbefore"]) {
            
            
            
            NSArray *comArray = [pc componentsSeparatedByString:@"openlushipingbefore:"];
            
            NSArray *contArray =[comArray[1] componentsSeparatedByString:@"$#$"];
             spHtml =contArray[0];
            
            videoUrl =nil;
            isSPno =YES;
            [self myimagePicker];
        }
        
        /**
         *  在上传视屏
         */
        if ([sr isEqualToString:@"getVideomessage"]) {
            
            
            NSString *path =[ZKUtil ToTakeTheKey:@"shiping"];
            
            UIImage *picImage =[self testGenerateThumbNailDataWithVideo:[NSURL URLWithString:path]];

            NSData *_data = UIImageJPEGRepresentation(picImage, 0.5f);
            
            NSString *_encodedImageStr = [_data base64EncodedStringWithOptions:0];
            
//            NSLog(@"urlllllllll-------%@", self.webToUrl);
            
            [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"sendVideosData('data:image/png;base64,%@#%@')",_encodedImageStr,@"vodio"]];
        }
        
        /**
         *  开启摇一摇功能
         */
        if ([sr isEqualToString:@"z_isyyy=true"]) {
            
            [self becomeFirstResponder];
            [[UIApplication sharedApplication]setApplicationSupportsShakeToEdit:YES];
            
        }
        
        /**
         *  　关闭该页面摇一7摇功能
         */
        if ([sr isEqualToString:@"closeYYY"]) {
            
            [self canBecomeFirstResponder];
            
        }
        
        
        /**
         *  返回首页
         */
        if ([sr isEqualToString:@"backTohome"]) {
            
            self.tabBarController.selectedIndex =0;
            [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:0] animated:YES];
        }
        
        
        if ([sr isEqualToString:@"addpagetofinish"]) {
            
            _webUrl =[NSString stringWithFormat:@"http:%@",components[2]];
            
        }
        
        
        /**
         *  播放视屏
         */
        
        if ([sr isEqualToString:@"toVideoshowPage"]) {
            
            
            NSArray *comArray = [pc componentsSeparatedByString:@"toVideoshowPage:"];
            
            NSArray *listArray =[comArray[1] componentsSeparatedByString:@"&"];
            
            NSArray *array_0 =[listArray[0] componentsSeparatedByString:@"="];
            NSArray *array_1 =[listArray[1] componentsSeparatedByString:@"="];
            
            ZKVideoViewController *video =[[ZKVideoViewController alloc] init];
            video.hidesBottomBarWhenPushed = YES;
            video.url =array_1[1];
            video.videoName =array_0[1];
            [self.navigationController pushViewController:video animated:YES];
        
        }
        
        
        
        
        /**
         *  跳转页面
         */
        if ([sr isEqualToString:@"hrefpage"]) {

            if (components.count>3) {
                
                NSString *pc_0 =components[3];
                
                NSArray *data =[pc_0 componentsSeparatedByString:@"$#$"];
                
               

//                NSString *color =data[2] ;
                NSString *isbool =data[3];
                NSArray *ictitis =[url componentsSeparatedByString:@"&"];
              

                if (ictitis.count==2) {
                    
                    name =[[ictitis objectAtIndex:1] componentsSeparatedByString:@"="][1];
                    [self nameGD];
                }
                
                
                NSArray *urlArray_0 = [pc componentsSeparatedByString:@"hrefpage:"];
                NSString *sy_0 =urlArray_0[1];
                NSArray *urlArray_1 = [sy_0 componentsSeparatedByString:@"$#$"];
                NSString *url =[[urlArray_1 objectAtIndex:0] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                
                ZKSecondaryViewController *vc =[[ZKSecondaryViewController alloc]init];
                vc.hidesBottomBarWhenPushed = YES;
                
                vc.webToUrl =url;
                
                [self.navigationController pushViewController:vc animated:YES];
                
                if ([isbool isEqualToString:@"true"]) {
                    
                    NSInteger p =self.navigationController.viewControllers.count;
                    
                    UIViewController *vc =[self.navigationController.viewControllers objectAtIndex:p-2];
                    
                    [vc removeFromParentViewController];
                    
                }
                
            }else{
                
                NSString *pc =components[2];
                
                NSArray *data =[pc componentsSeparatedByString:@"$#$"];
                
                NSString *url =[[NSString stringWithFormat:@"http:%@",data[0]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                NSString *color =data[2] ;
                NSString *isbool =data[3];
                
                ZKSecondaryViewController *vc =[[ZKSecondaryViewController alloc]init];
                vc.webToUrl =url;
                vc.mycolor =color;
        
                if ([url rangeOfString:@"720.daqsoft.com"].location != NSNotFound) {
                    
                    [self TOback];

                
                }
                
                [self.navigationController pushViewController:vc animated:YES];
                
                if ([isbool isEqualToString:@"true"]) {
                    
                    NSInteger p =self.navigationController.viewControllers.count;
                    
                    UIViewController *vc =[self.navigationController.viewControllers objectAtIndex:p-2];
                    
                    [vc removeFromParentViewController];
                    
                }
            }
            
        }
        

        
        /**
         *  进去超图
         */
        if ([sr isEqualToString:@"hreftodaohang2"]) {
            
            
            
            
                if ([dataGBK  rangeOfString:@"TOTYPE"].location !=NSNotFound) {
                    //TOTYPE=openhotelorder&pzh_name=攀枝花市二滩国家森林公园&pzh_price=160&pzh_usetime=&pzh_whichroom=100007918景区门票&pzh_productID=18&pzh_qixian=2015-10-01,2015-11-07
                    
                  //  TOTYPE=SELECTHOUR&day=3&start=&end=&selectedDay=&willurl=http,
                  //  app.pzh.wopeng.tv/s_customdzCont.aspx?startdate=2015-12-02
                    
                    NSArray *cmps = [dataGBK componentsSeparatedByString:@"&"];
                    
                    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                    
                    NSString *zdStr_0 = cmps[0];
                    
                    /**
                     *  行程订单
                     */
                    if ([zdStr_0 isEqualToString:@"TOTYPE=scenic"]) {
                        
                        ZKStrokeOrderViewController *vc =[[ZKStrokeOrderViewController alloc]initData:cmps];

                        [self.navigationController pushViewController:vc animated:YES];
                        
                        return;
                    }
                    
                    if ([zdStr_0 isEqualToString:@"TOTYPE=SELECTHOUR"]) {
                        
                        
                        NSArray *cmps1 = [pc componentsSeparatedByString:@"daohang2:"];
                        
                        // dataGBK1:
                        // TOTYPE=SELECTHOUR&day=2&start=7&end=8&selectedDay=1&willurl=http://192.168.0.132:8323/sdy_dzCont.aspx?selectedDay=2015-04-17
                        NSString *dataGBK1 =cmps1[1];
                        
                        // cmps:
                        // @[@"TOTYPE=SELECTHOUR", @"day=2", @"day=2", @"end=8", @"selectedDay=1", @"willurl=http://192.168.0.132:8323/sdy_dzCont.aspx?selectedDay=2015-04-17"]
                        NSArray *cmps = [dataGBK1 componentsSeparatedByString:@"&"];
                        
                        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                        
                        for (int i = 1; i<cmps.count; ++i) {
                            NSArray *cmp = [cmps[i] componentsSeparatedByString:@"="];
                            
                            if ([cmp[1] rangeOfString:@"?"].location != NSNotFound) {
                                // cmp:
                                // @[@"willurl", @"http://192.168.0.132:8323/sdy_dzCont.aspx?selectedDay", @"2015-04-17"]
                                [dic setObject:[NSString stringWithFormat:@"%@=%@", cmp[1], cmp[2]] forKey:@"willurl"];
                                continue;
                            }
                            
                            [dic setObject:cmp[1] forKey:cmp[0]];
                        }
                        
    
                        
                        
                        ZKTimePickerViewController *timePickerVC = [[ZKTimePickerViewController alloc] init];
                        timePickerVC.info = dic;
                        [self.navigationController pushViewController:timePickerVC animated:YES];
                        
                        
                        
                        
                        return;
                        
                    }
                    
                    
                    for (int i = 1; i<cmps.count; ++i) {
                        NSArray *cmp = [cmps[i] componentsSeparatedByString:@"="];
                        
                        [dic setObject:cmp[1] forKey:cmp[0]];
                    }
                    
                    ZKProduction *production = [[ZKProduction alloc] init];
                    
                    [production setValuesForKeysWithDictionary:dic];
                    
                    NSString *totypeValue = (NSString *)[cmps[0] componentsSeparatedByString:@"="][1];
                    
                    
                    
                    
                    if ([totypeValue isEqualToString:@"openhotelorder"]) {
                        UIStoryboard *story = [UIStoryboard storyboardWithName:@"Order" bundle:nil];
                        ZKHotelCommitOrderViewController *hotelOrderVC = [story instantiateViewControllerWithIdentifier:@"HotelCommit"];
                        
                        hotelOrderVC.production = production;
                        [self.navigationController pushViewController:hotelOrderVC animated:YES];
                        
                    }else {
                        
                        UIStoryboard *story = [UIStoryboard storyboardWithName:@"Order" bundle:nil];
                        ZKCommitOrderViewController *senceryOrderVC = [story instantiateInitialViewController];
                        senceryOrderVC.production = production;
                        [self.navigationController pushViewController:senceryOrderVC animated:YES];
                    }
                    
                    
                }else{
                    
                    if ([dataGBK  rangeOfString:@"type"].location !=NSNotFound) {  //通过类型查找附近
                        
                        
                        
                        NSArray *dtData = [dataGBK componentsSeparatedByString:@"&"];//提交请求
                        
                        if (dtData.count>2) {
                            /**
                             *  附近接口
                             */
                            ZKnearListViewController *near =[[ZKnearListViewController alloc]init:dtData];
                            [self.navigationController pushViewController:near animated:YES];
                            
                        }else{
                            /**
                             *  推荐接口
                             */
                            ZKrecommendedViewController *recom =[[ZKrecommendedViewController alloc]init:dtData];
                            [self.navigationController pushViewController:recom animated:YES];
                        }
                        
                    }else{  //通过经纬度查找附近
                        
                        //                NSArray *arry0 =[dataGBK componentsSeparatedByString:@"&"];
                        
                        
                        
                        NSArray *arry1 =[dataGBK componentsSeparatedByString:@"="];
                        
                        NSArray *arry2 =[arry1[1] componentsSeparatedByString:@","];
                        
                        if ([dataGBK  rangeOfString:@"endAddr"].location !=NSNotFound){
                            
                            if (!ToLongitude) {
               
                                [self.view makeToast:@"正在定位，请稍候！"];
                                [self locan];
                                
                            }else{
                            
                            
                                NSString *st_0 = arry2[0];
                                NSString *st_1 = [arry2[1] componentsSeparatedByString:@"&"][0];
                                NSString *st_2 =[arry1[2] componentsSeparatedByString:@"&"][0];

                                ZKMapNavController *nav =[[ZKMapNavController alloc]initKLat:ToLatitude KLon:ToLongitude Kadder:toAdder WLat:[st_0 doubleValue] WLon:[st_1 doubleValue] WAdder:st_2 code:arry1[3]];
       
                                [self.navigationController pushViewController:nav animated:YES];
                            }

                            
                        }else{
                        
                            ZKnearListViewController *near =[[ZKnearListViewController alloc]init:arry2];
                            [self.navigationController pushViewController:near animated:YES];
                        }
                        
                 
                        
                        
                        
                    }
                }

            
            
        }
        
        
        /**
         *  获取2点之间的距离
         */
        if ([sr isEqualToString:@"getlengthStartandEnd"]) {
            
            NSArray *jwd =[dataGBK componentsSeparatedByString:@"$"];
            
            NSString *z1 =[jwd objectAtIndex:0];
            endOf =[jwd objectAtIndex:1];
            
            if (!strIsEmpty(z1)) {
                //有起始坐标
                NSArray *arra1 =[z1 componentsSeparatedByString:@","];
                NSArray *arra2 =[endOf componentsSeparatedByString:@","];
                
                double k1 =[arra1[0] doubleValue];
                double k2 =[arra1[1] doubleValue];
                double w1 =[arra2[0] doubleValue];
                double w2 =[arra2[1] doubleValue];
                
                _startPoint = [AMapNaviPoint locationWithLatitude:k1 longitude:k2];
                _endPoint   = [AMapNaviPoint locationWithLatitude:w1 longitude:w2];
                
                CLLocation *orig=[[CLLocation alloc] initWithLatitude:_startPoint.latitude longitude:_startPoint.longitude];
                CLLocation *dist=[[CLLocation alloc] initWithLatitude:_endPoint.latitude longitude:_endPoint.longitude];
                
                CLLocationDistance kilometers = [orig distanceFromLocation:dist];
                
                [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"IOSFA.sendMapdistancetopage('%f')",kilometers]];
                
            }else{
                // 没有起始坐标
                
                isjuli =YES;
                
                if (ToLatitude>0&&ToLongitude>0) {
                    
                    NSArray *arra2 =[endOf componentsSeparatedByString:@","];
                    
                    double k1 =ToLatitude;
                    double k2 =ToLongitude;
                    double w1 =[arra2[0] doubleValue];
                    double w2 =[arra2[1] doubleValue];
                    
                    _startPoint = [AMapNaviPoint locationWithLatitude:k1 longitude:k2];
                    _endPoint   = [AMapNaviPoint locationWithLatitude:w1 longitude:w2];
                    
                    CLLocation *orig=[[CLLocation alloc] initWithLatitude:_startPoint.latitude longitude:_startPoint.longitude];
                    CLLocation* dist=[[CLLocation alloc] initWithLatitude:_endPoint.latitude longitude:_endPoint.longitude];
                    
                    CLLocationDistance kilometers = [orig distanceFromLocation:dist];
                    
                    [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"IOSFA.sendMapdistancetopage('%f')",kilometers]];
                    
                    
                }else{
                    
                    [self locan];
                }
            }
        }
    
        //         /**
        //          *  进入导航页面
        //          */
        //         if ([sr isEqualToString:@"hreftodaohang"]) {
        //
        //
        //             if (!ToLongitude) {
        //
        //                 isjuli =NO;
        //
        //                 [self locan];
        //             }
        //
        //
        //
        //
        //            rou =[[RoutePlanViewController alloc]initKLat:ToLatitude KLon:ToLongitude WLat:31 WLon:107];
        //             [self.navigationController pushViewController:rou
        //                                                  animated:YES];
        //
        //
        //         }
        
        /**
         *  获取地理位置
         */
        if ([sr isEqualToString:@"getgaodepathname"]) {
            
            
            if (strIsEmpty(toAdder) ==0) {
                
                [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"IOSFA.returngaodemapnameresult('%@')",toAdder]];
                
            }else{
                
                [[ MMLocationManager  shareLocation] getAddress:^(NSString *addressString) {
                    
                    [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"IOSFA.returngaodemapnameresult('%@')",addressString ]];
                }];
            }
        }
        
        /**
         *  获取经纬度
         */
        if ([sr isEqualToString:@"getgaodepath"]) {
            
            
            
            isjuli =NO;
            
            if (!ToLatitude) {
                
                [self locan];
                
            }else{
                
                NSString *add =[NSString stringWithFormat:@"%f,%f",ToLongitude,ToLatitude];
                
                [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"IOSFA.returngaodemaplnglatresult('%@')",add]];
            }
        }
        
        /**
         *  二维码扫描
         */
        if ([sr isEqualToString:@"open2pic"]) {
            
            if(IOS7)
            {
                ZKZBarRootViewController * rt = [[ZKZBarRootViewController alloc]init];
                
                [rt rtConter:^(NSString *str) {
                    
                    
                    [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"sendShaomiandataTojs('%@')",str]];
                    
                }];
                
                [self presentViewController:rt animated:YES completion:^{
                    
                }];
            }
        }
        
        /**
         *  保存图片到相册
         */
        if ([sr isEqualToString:@"loadfiletolocalpath"]) {
            
            NSString *surl =[NSString stringWithFormat:@"http:%@",components[2]];
            
            [SVProgressHUD show];
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                
                NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:surl]];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [SVProgressHUD dismiss];
                    
                    if (data) {
                        
                        [self saveImage:[UIImage imageWithData:data]];
                        
                    }else{
                        
                        [SVProgressHUD dismissWithError:@"网络错误！"];
                        
                    }
                });
            });
        }
        
        /**
         *  判断是否自己返回
         */
        if ([sr isEqualToString:@"setAutocloseLoadingpages"]) {
            
            webUrlArray =[dataGBK componentsSeparatedByString:@","];
        
        }
        
        
        if ([sr isEqualToString:@"closeuppage"]) {
            
            record =[dataGBK integerValue];
        }
        
        
        /**
         *  上传图片
         */
        if ([sr isEqualToString:@"uploadfileToserver"]) {
            
            NSRange range = [requestString rangeOfString:@"uploadfileToserver:"];//获取$file/的位置
            NSString *xp = [requestString substringFromIndex:range.location +
                            range.length];//开始截取
            NSString *xxp = [xp stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSArray *infoArray =[xxp componentsSeparatedByString:@","];
            
            scData =[photographDic valueForKey:infoArray[0]];
            NSArray *pc =[infoArray[3] componentsSeparatedByString:@"="];
            
            NSMutableDictionary *dic =[NSMutableDictionary dictionary];
            [dic setObject:pc[1] forKey:pc[0]];
            
            [ZKHttp PostImage:infoArray[1] params:dic Data:scData success:^(id responseObj) {
                
            } failure:^(NSError *error) {
                
                [[APPDELEGATE window] makeToast:@"上传失败"];
            }];
        }
        
        /**
         *  取多张图片
         */
        if ([sr isEqualToString:@"getMulpicsbyIphone"]) {
            
            
            NSInteger number =[dataGBK integerValue];
            
            ZYQAssetPickerController *picker = [[ZYQAssetPickerController alloc] init];
            picker.maximumNumberOfSelection = number;
            [[APPDELEGATE window] makeToast:[NSString stringWithFormat:@"你能选%ld张图片。",(long)number] duration:1 position:nil];
            picker.assetsFilter = [ALAssetsFilter allPhotos];
            picker.showEmptyGroups=NO;
            picker.delegat=self;
            picker.delegate =self;
            picker.selectionFilter = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
                if ([[(ALAsset*)evaluatedObject valueForProperty:ALAssetPropertyType] isEqual:ALAssetTypeVideo]) {
                    NSTimeInterval duration = [[(ALAsset*)evaluatedObject valueForProperty:ALAssetPropertyDuration] doubleValue];
                    return duration >= 5;
                } else {
                    return YES;
                }
            }];
            
            
            [self.navigationController presentViewController:picker animated:YES completion:NULL];
            
        }
        
        /**
         *  取单张照片
         */
        if ([sr isEqualToString:@"getOnepc"]) {
            
            UIActionSheet *sheet=[[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:dataGBK otherButtonTitles:@"从相册选择",@"拍照", nil];
            [sheet showInView:[self view]];
        }
        
        /**
         *  改变右边item的值
         */
        if ([sr isEqualToString:@"setrightButtonText"]) {
            
            if (self.loadButton == YES) {
                return;
            }
            
            
            NSString *regex = @"[0-9]";
            
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
            
            if ([predicate evaluateWithObject:dataGBK] == YES) {
                
                NSInteger k =[dataGBK integerValue];
                
                switch (k) {
                    case 1:
                
                [self.rittBarButtonItem setImage:[UIImage imageNamed:@"my_for_0"] forState:UIControlStateNormal];

                        break;
                        
                    case 2:
                        
                [self.rittBarButtonItem setImage:[UIImage imageNamed:@"my_cell_4"] forState:UIControlStateNormal];
                        
                        break;
                        
                    case 3:
                        
                [self.rittBarButtonItem setImage:[UIImage imageNamed:@"my_cell_1"] forState:UIControlStateNormal];
                        
                        break;
                        
                    case 4:
                        
                [self.rittBarButtonItem setImage:[UIImage imageNamed:@"hom"] forState:UIControlStateNormal];
                        
                        break;
                        
                    case 5:
   
                        break;
                        
                    case 7:
                        
                    [self.rittBarButtonItem setImage:[UIImage imageNamed:@"nav_more"] forState:UIControlStateNormal];
                        
                        break;
                        
                    default:
                        break;
                }
                
                
            }else{
                
                [self.rittBarButtonItem setTitle:dataGBK forState:UIControlStateNormal];
            }
        }
        
        if ([sr isEqualToString:@"setrightButtonTextTwo"]){
            
            
            
        
            if (self.loadButton == YES) {
                return;
            }
            NSString *regex = @"[0-9]";
            
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
            
            if ([predicate evaluateWithObject:dataGBK] == YES) {
                
                NSInteger k =[dataGBK integerValue];
                
                if (k == 6) {
                    
                    
                    
                    [self.rittBarButtonItem2 setImage:[UIImage imageNamed:@"my_for_1"] forState:UIControlStateNormal];
                    isRitbutton =YES;
                    [self nameGD];
                    
                    
                    NSLog(@"11919919191919、\n\n\n\n");
                    
                    
                    
                }
            }
        }
        
        
        /**
         *  跳转页面
         */
        if ([sr isEqualToString:@"hrefresult"]) {
        
//            if ([sr isEqualToString:@"hrefpage"]) {
            
            NSRange range = [requestString rangeOfString:@"hrefresult:"];//获取$file/的位置
//            NSRange range = [requestString rangeOfString:@"hrefpage:"];//获取$file/的位置
            NSString *xp = [requestString substringFromIndex:range.location +
                            range.length];//开始截取
            NSString *xxp = [xp stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//            NSLog(@"xxp == %@",xxp);
            
            ZKSecondaryViewController *test =[[ZKSecondaryViewController alloc]init];
            test.webToUrl =xxp;
            
            
            [self.navigationController pushViewController:test animated:YES];
        }
        
        /**
         *  清除缓存
         */
        if ([sr isEqualToString:@"sysclearcache"]) {
      
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                
               NSString *cachPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
               
               NSArray *files = [[NSFileManager defaultManager] subpathsAtPath:cachPath];
               for (NSString *p in files) {
                   NSError *error;
                   NSString *path = [cachPath stringByAppendingPathComponent:p];
                   if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
                       [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
                   }
               }
           });
            
            [self.view makeToast:@" 清除缓存成功" duration:1 position:nil];
            
            
        }
        
        /**
         *  退出程序
         */
        if ([sr isEqualToString:@"exit"]) {
            
            UIWindow *window = APPDELEGATE.window;
            [UIView animateWithDuration:0.5f animations:^{
                window.alpha = 0;
                window.frame = CGRectMake(0, window.bounds.size.width, 0, 0);
            } completion:^(BOOL finished) {
                exit(0);
            }];
        }
        
        /**
         *  复选框
         */
        
        if ([sr isEqualToString:@"showDialogmulcheckbox"]) {

                NSArray *arry =[dataGBK componentsSeparatedByString:@"$"];
                
                NSArray * merArray =[arry[1] componentsSeparatedByString:@","];
                duoxuanMer =[[ZKmerchandiseView alloc]initArray:merArray Name:arry[0] sect:arry[2] tp:0];
                duoxuanMer.delegate =self;
                [duoxuanMer show];
            
        }
        
        /**
         *  单选框
         */
        if ([sr isEqualToString:@"showDialogsingle"]) {
            
               [duoxuanPop removeFromSuperview];
            
                NSArray *arry =[dataGBK componentsSeparatedByString:@"$"];
                
                poptitisArray =[arry[1] componentsSeparatedByString:@","];
                NSInteger pc=[arry[2] integerValue];
                duoxuanPop =[[ZKpoperFanView alloc]initNames:poptitisArray sect:pc reminder:arry[0] tp:0];
                duoxuanPop.delegate =self;
                [duoxuanPop show];
        }
        
        /**
         *  是否隐藏头部
         */
        if ([sr isEqualToString:@"hidenOfhead"]) {
            
            if ([dataGBK isEqualToString:@"true"]) {
                
                self.navigationBarView.layer.opacity =0;
                self.webView.frame =self.view.bounds;
                
            }else{
                
                self.navigationBarView.layer.opacity =1;
                
                self.webView.frame =CGRectMake(0, navigationHeghit, self.view.frame.size.width, TabelHeghit-_tabHeghit);
                
            }
        }
        
        /**
         *  拨打电话
         */
        
        if ([sr isEqualToString:@"callOfphone"]) {
            
            NSArray *phones= [dataGBK componentsSeparatedByString:@","];
            if (phones.count > 1) {
                dataGBK = phones[0];
            }
        
            
            [[BaiduMobStat defaultStat] logEvent:@"btn_call" eventLabel:@"打电话 "];
            
            NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",[dataGBK stringByReplacingOccurrencesOfString:@"—" withString:@""]];
            
            UIWebView * callWebview = [[UIWebView alloc] init];
            [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
            [self.view addSubview:callWebview];
        }
        
        /**
         *  打开设置网络
         */
        if ([sr isEqualToString:@"openSetnetPage"]) {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"网络连接异常" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
        }
        
        /**
         *  设置置顶按钮
         */
        if ([sr isEqualToString:@"showbackTopbutton"]) {
            
            stickButton.layer.opacity =1;
            stick =dataGBK;
        }
        
        if ([sr isEqualToString:@"isShoworHidrbBack"]) {
            
            if ([dataGBK isEqualToString:@"false"]) {
                
                stickButton.layer.opacity =0;
                
            }else{
                
                stickButton.layer.opacity =1;
            }
        }
        
        /**
         *  是否显示滚动条
         */
        if ([sr isEqualToString:@"isshowUiwebviewbarornot"]) {
            
            if ([dataGBK isEqualToString:@"true"]) {
                
                self.webView.scrollView.showsVerticalScrollIndicator =YES;
                
            }else if ([dataGBK isEqualToString:@"false"]){
                
                self.webView.scrollView.showsVerticalScrollIndicator =NO;
            }
        }
        
        
        
        /**
         *  掉返回按钮
         */
        if ([sr isEqualToString:@"gobackUrl"]) {
            
            [self  navback];
        }
        
        /**
         *  改头部标示
         */
        if ([sr isEqualToString:@"setHeadmiddleOftitle"]) {
            
            name = dataGBK;
            [self nameGD];
        }
        
        /**
         *  开 HUD
         */
        if ([sr isEqualToString:@"openIosLoading"]) {
            
            [SVProgressHUD showWithStatus:dataGBK];
        }
        
        /**
         *  关闭 HUD
         */
        if ([sr isEqualToString:@"closeIosLoading"]) {
            
            [SVProgressHUD dismiss];
        }
        
        /**
         *  获取图片
         */
        if ([sr isEqualToString:@"goopenlookpicswindow"]) {
            
            NSRange range = [requestString rangeOfString:@"goopenlookpicswindow:"];//获取$file/的位置
            NSString *xp = [requestString substringFromIndex:range.location +
                            range.length];//开始截取
            NSString *xxp = [xp stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            
            NSArray *ay =[ZKUtil data:xxp];
            
            NSArray *titisArry = ay[ay.count-1];
            
            [imageArray removeAllObjects];
            
            NSArray *parray =ay[0];
            
            for (int i=0; i<parray.count; i++) {
                
                NSString *p =parray[i];
                
                if (strIsEmpty(p)) {
                    
                    break;
                }else{
                    
                    [imageArray addObject:p];
                }
            }
            
//            NSLog(@"tp == %@",imageArray);
            
            float index = 0.0;
            for (int i=0; i<imageArray.count; i++) {
                
                if ([ay[1] isEqualToString:[imageArray objectAtIndex:i]]) {
                    
                    index =i;
                    break;
                }
                
            }
            
            if (imageArray.count>0) {
                NSInteger count = imageArray.count;
                // 1.封装图片数据
                NSMutableArray *photos = [NSMutableArray arrayWithCapacity:count];
                
                
                for (int i = 0; i<count; i++) {
                    
                    NSString *url =[imageArray objectAtIndex:i];
                    
                    NSString *purl;
                    
                    NSString *titis = titisArry[i];
                    if ([url  rangeOfString:@"http"].location!=NSNotFound) {
                        
                        purl =url;
                    }else{
                        
                        purl =[NSString stringWithFormat:@"http://192.168.0.132:7200/%@",url];
                    }
//                    NSLog(@" --- url %@",purl);
                    
                    MJPhoto *photo = [[MJPhoto alloc] init];
                    photo.titis = titis;
                    photo.url = [NSURL URLWithString:purl]; // 图片路径
                    photo.srcImageView = fotoImage; // 来源于哪个UIImageView
                    [photos addObject:photo];
                }
                
                // 2.显示相册
                MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
                browser.currentPhotoIndex = index; // 弹出相册时显示的第一张图片是？
                browser.photos = photos; // 设置所有的图片
                browser.delegate =self;
                browser.isDelete =YES;
                [browser show];
            }
        }
        
        /**
         *  取数据
         */
        if ([sr isEqualToString:@"doajaxpost"]) {
            
//            NSLog(@">>>>>>>第一个请求数据 >>>>>>>>  ");
            NSRange range = [requestString rangeOfString:@"doajaxpost:"];//获取$file/的位置
            NSString *xp = [requestString substringFromIndex:range.location +
                            range.length];//开始截取
            NSString *xxp = [xp stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//            NSLog(@"xxp == %@",xxp);
            
            NSArray *pxArray =[xxp componentsSeparatedByString:@"#$#"];
            
//            NSLog(@"多参数 :%@",pxArray);
            
            NSMutableDictionary *dic =[NSMutableDictionary dictionary];
            
            NSString *js =pxArray[1];
            
            dic =[js JSONValue];
            
//            NSLog(@">>>%@", dic);
            
            
        [ZKHttp Post:pxArray[0] params:dic success:^(id responseObj) {
            
            NSData * jsonData = [NSJSONSerialization dataWithJSONObject:responseObj options:0 error:nil];
            NSString * myString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            
            NSString *pch = [myString stringByReplacingOccurrencesOfString:@"\\" withString:@"\\\\"];
            
            [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"iosreturndata('%@#$#%@')",pxArray[3],pch]];
                
        } failure:^(NSError *error) {
                
            [more dism];
            
            if (isShow ==NO) {
                
                isShow =YES;
                
                more =[[ZKMoreReminderView alloc]initTs:@"温馨提示" MarkedWords:@"数据加载失败！要重新加载吗？" ];
                
                __weak typeof(self) weakSelf = self;
                
                [more sectec:^(int pgx) {
                  
                    if (pgx ==0) {
                        
                        if ([weakSelf.webToUrl isEqualToString:pur]) {
                            [weakSelf.navigationController popToRootViewControllerAnimated:YES];
                        }else{
                            
                            [weakSelf.webView goBack];
                            
                        }
                        
                    }else{
                        
                        isShow =NO;
                        
                        [weakSelf.webView reload];
                    }
                    
                }];
                
                [more show];
             }
            
          }];
            
        }
        
        
        /**
         *  最新取数据
         */
        if ([sr isEqualToString:@"doajaxpostnew"]) {
            
//            NSLog(@">>>>>>>第二个请求数据 >>>>>>>>  ");
            
            NSRange range = [requestString rangeOfString:@"doajaxpostnew:"];//获取$file/的位置
            NSString *xp = [requestString substringFromIndex:range.location +
                            range.length];//开始截取
            NSString *xxp = [xp stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//            NSLog(@"xxp == %@",xxp);
            
            NSArray *pxArray =[xxp componentsSeparatedByString:@"#$#"];
            
//            NSLog(@"多参数 :%@",pxArray);
            
            NSMutableDictionary *dic =[NSMutableDictionary dictionary];
            
            NSString *js =pxArray[1];
            
            dic =[js JSONValue];
            
//            NSLog(@">>>%@",  dic);
            
            [ZKHttp Post:pxArray[0] params:dic success:^(id responseObj) {
                
                NSData * jsonData = [NSJSONSerialization dataWithJSONObject:responseObj options:0 error:nil];
                NSString * myString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
                
                NSString *pch = [myString stringByReplacingOccurrencesOfString:@"\\" withString:@"\\\\"];
                
                // NSString *bv =[pch stringByReplacingOccurrencesOfString:@"/" withString:@"//"];
                
//                NSLog(@"-----\n获取数据  : %@", pch);
                
                [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"sendResultTojs('%@#$#%@')",pxArray[3], pch]];
                
            } failure:^(NSError *error) {
                
                [more dism];
                
                if (isShow ==NO) {
                    
                    isShow =YES;
                    
                    more =[[ZKMoreReminderView alloc]initTs:@"温馨提示" MarkedWords:@"数据加载失败！要重新加载吗？" ];
                    
                    [more sectec:^(int pgx) {
                        
                        
                        if (pgx ==0) {
                            
                            if ([self.webToUrl isEqualToString:pur]) {
                                [self.navigationController popToRootViewControllerAnimated:YES];
                            }else{
                                
                                [self.webView goBack];
                                
                            }
                            
                        }else{
                            
                            isShow =NO;
                            [self.webView reload];
                        }
                        
                        
                        
                    }];
                    
                    
                    [more show];
            
                }
                
            }];
            
        }
        
        
        if ([sr isEqualToString:@"setstaticmap"]) {
            
            NSArray *ar =[requestString componentsSeparatedByString:@"#$#"];
            
            sy =[ar objectAtIndex:1] ;
            [ZKUtil MyValue:sy MKey:@"setstaticmap"];
            
//            NSLog(@" sysysysys %@",sy);
        }
        
        
        if ([sr isEqualToString:@"getstaticmap"]) {
            /**
             *  返回值
             *
             *  @param '%@'
             *
             *  @return 值
             */
            
            sy =[ZKUtil ToTakeTheKey:@"setstaticmap"];
            
//            NSLog(@"取出需要传过去的值＝＝＝%@",sy);
            [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"IOSFA.getstaticmap('%@')", sy]];
        }
        
        
        /**
         *  存放的永久内容
         */
        if ([sr isEqualToString:@"setforevermap"]) {
            
            NSArray *comArray = [pc componentsSeparatedByString:@"setforevermap:"];
            
            NSArray *ar =[comArray[1] componentsSeparatedByString:@"#$#"];
            
            [ZKUtil MyValue:[ar objectAtIndex:1] MKey:[ar objectAtIndex:0]];
     
        }
        
        
        /**
         *  取永久值
         */
        if ([sr isEqualToString:@"getevermap"]) {
            popLoginCount++;
           
            NSLog(@"%@", [ZKUserInfo sharedZKUserInfo].ID);
            NSLog(@"%@", [ZKUtil ToTakeTheKey:@"USER_MESSAGE_ID"]);
            
            if ([ZKUserInfo sharedZKUserInfo].ID==nil) {
                
                if (popLoginCount == 1) {
                
                    ZKregisterViewController *reg =[[ZKregisterViewController alloc]init];
                    reg.isMy =YES;
                    reg.updateAlertBlock = ^() {
                        
                        NSLog(@"调用了block");
                        
                    };
                    
                    UINavigationController *nav =[[UINavigationController alloc]initWithRootViewController:reg];
                    nav.navigationBarHidden =YES;
                    [self presentViewController:nav animated:YES completion:^{
                        
                    }];
                    
                }else {
                
                    [self.view makeToast:@"请先登录"];
                }

            }
            
            NSString *cun =[ZKUtil ToTakeTheKey:dataGBK];
            cun = cun == nil ? @"" : cun;
            
            [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"IOSFA.getevermap('%@')", cun]];
            
        }
        
        
        if([sr isEqualToString:@"alert"]){
            
            [self.view makeToast:[NSString stringWithFormat:@"%@",dataGBK]];
            
        }
    }
}


-(void)tongzhi:(NSNotification *)text{
    
    NSString *requestString = text.object;//获取请求的绝对路径.
    
    [self mess:requestString];
}



#pragma mark - 加载网页
-(void)loadWeebUrl;
{
    
    [indicatorView stopAnimating];
    
    NSURLRequest *rest =[NSURLRequest requestWithURL:[NSURL URLWithString:_webToUrl]];
    
    
    self.webView.backgroundColor =[UIColor whiteColor];
    [self.webView loadRequest:rest];

}


#pragma mark - MONActivityIndicatorViewDelegate Methods

- (UIColor *)activityIndicatorView:(MONActivityIndicatorView *)activityIndicatorView
      circleBackgroundColorAtIndex:(NSUInteger)index {
    
    CGFloat red   = (arc4random() % 256)/255.0;
    CGFloat green = (arc4random() % 256)/255.0;
    CGFloat blue  = (arc4random() % 256)/255.0;
    CGFloat alpha = 1.0f;
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}


#pragma mark uiwebview代理
/**
 *WebView加载完毕的时候调用（请求完毕）
 */
-(void)webViewDidFinishLoad:(UIWebView *)webView{

//    NSLog(@" ---------  %@",webView.request.URL);
    
    pur =[NSString stringWithFormat:@"%@",webView.request.URL];
    
    
    if ([pur  rangeOfString:@"http://192.168.0.132:8156"].location !=NSNotFound) {
        
    }else{
        
        [SVProgressHUD dismiss];
        
    }
    
    /**
     *  隐藏顶部
     */
    if ([pur  rangeOfString:@"z_ishidhead=true"].location !=NSNotFound) {
        
        self.navigationBarView.layer.opacity =0;
        self.webView.frame =self.view.bounds;
        z_ishidhead =YES;
        
    }else if ([pur  rangeOfString:@"z_ishidhead=false"].location !=NSNotFound) {
        
        self.navigationBarView.layer.opacity =1;
        self.webView.frame =CGRectMake(0, 0, self.view.frame.size.width, kDeviceHeight);
        
        z_ishidhead =NO;
    }
    

    [indicatorView stopAnimating];
    
    /****  禁止web长按事件 *****/
    [self.webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitUserSelect='none';"];
    
    [self.webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitTouchCallout='none';"];
    
    
    /***传版本****/
    
    [self.webView stringByEvaluatingJavaScriptFromString:@"setDEVICETYPE('IOS')"];
    
    
    
    /***拦截title****/
    
    if ((name.length==0 || name==nil || [name isEqualToString:@"畅游攀枝花"]) && !self.searchBar.superview) {
        name = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
        [self nameGD];
    }
    
    
    if (isPost ==YES) {
        
        
        for (NSString*p in webUrlArray) {
            
            if ([webUrl  rangeOfString:p].location !=NSNotFound) {
                
                [SVProgressHUD dismiss];
                
                break;
            }
        }
        
    }else{
        
        isPost =YES;
    }
}

/**
 *WebView加载失败的时候调用（请求失败）
 */
-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    
    [indicatorView stopAnimating];
    
    if (isPost ==YES) {
        
        [SVProgressHUD dismiss];
        
    }
    
    [self errorView];
}



/**
 *WebView开始加载资源的时候调用（开始发送请求）
 */
-(void)webViewDidStartLoad:(UIWebView *)webView
{
  
    [indicatorView stopAnimating];
    
    stickButton.layer.opacity =0;
    
    if (errorImage) {
        [errorImage removeFromSuperview];
    }
    
    if (isPost ==YES) {
        
        [SVProgressHUD showWithStatus:@"努力加载中"];
        
    }else{
        
        [self startAnimating];

    }
}


- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType;
{
//    NSLog(@" ---------  %@",webView.request.URL.absoluteString);
    /**
     *  判断是否关闭这个页面
     */
    
    NSString *p =[NSString stringWithFormat:@"%@",request.URL];
    
    
    if ([_webUrl isEqualToString:p]) {
        
        _webUrl =@"";
        [self  navback];
    }
    
    return YES;
    
}

#pragma mark  选择城市代理
- (void)cityPickerViewController:(ZKCityPickerViewController *)cityPickerViewController didSelectedCity:(ZKCity *)city;
{
    
     [self.webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitTouchCallout='none';"];
    
    NSLog(@"%@--%@", city.title, city.value);

    NSString *text = [NSString stringWithFormat:@"z_set_selectPathofdata('%@')",[NSString stringWithFormat:@"%@,%@",city.value,city.title]];
    
    [self.webView stringByEvaluatingJavaScriptFromString:text];
    
}
#pragma mark - searchBarDelegate
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    NSString *text = [NSString stringWithFormat:@"Z_onTopchange('%@')", searchText];
    
    [self.webView stringByEvaluatingJavaScriptFromString:text];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{

    [searchBar resignFirstResponder];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.searchBar resignFirstResponder];

}

//将开始降速时
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView;
{
    
    [indicatorView stopAnimating];
    
    if (scrollView.contentOffset.y<-50) {
        
        [self loadGoogle];
        
        isPost =NO;
        
        [UIView animateWithDuration:0.3 animations:^{
            
            self.webView.scrollView.contentOffset =CGPointMake(0, 0);
            
        }];
    }
}

/**
 *  错误返回图片
 */
-(void)errorView
{
    if (errorImage) {
        [errorImage removeFromSuperview];
    }
    
    self.leftBarButtonItem.layer.opacity =1;
    self.webView.backgroundColor =TabelBackCorl;
    errorImage =[[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width/6, 130, 100, 100)];
    errorImage.image =[UIImage imageNamed:@"errData"];
    errorImage.center =CGPointMake(self.webView.frame.size.width/2, self.webView.frame.size.height/2);
    errorImage.userInteractionEnabled =YES;
    [self.webView  addSubview:errorImage];
    UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(loadGoogle)];
    [errorImage addGestureRecognizer:tapGr];
    [self.view makeToast:@"亲，网络连接错误!" duration:1 position:nil];
    
}

-(void)loadGoogle
{
    self.webView.backgroundColor =[UIColor whiteColor];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:pur]]];
    
}

-(void)nameGD{
    
    
    if (lsPaoMaView) {
        
        [lsPaoMaView removeFromSuperview];
    }
    
    float labelW;
    
    if (isRitbutton ==YES) {
        
        labelW =self.view.frame.size.width-80-40;
        
    }else{
    
        labelW =self.view.frame.size.width-80;
    }
    
    
    lsPaoMaView = [[LSPaoMaView alloc]initWithFrame:CGRectMake(40, 8, labelW, navigationHeghit) title:name];
    
    
    [self.navigationBarView  addSubview:lsPaoMaView];
    
}
#pragma mark pop代理
-(void)Pconfirm:(NSInteger)sect tp:(NSInteger)k;
{
    
//    NSLog(@"pop -- %@",poptitisArray[sect]);
    
    [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"IOSFA.getradioResultdata('%@')", poptitisArray[sect]]];
    
}


-(void)array:(NSArray*)data tp:(NSInteger)k;
{
    
    NSMutableArray *numArray =[[NSMutableArray alloc]initWithCapacity:0];
    NSMutableArray *nameArray =[[NSMutableArray alloc] initWithCapacity:0];
    
    for (NSString *cy in data) {
        
        NSArray *l =[cy componentsSeparatedByString:@"#"];
        [numArray addObject:l[0]];
        [nameArray addObject:l[1]];
    }
    NSString *num =[numArray componentsJoinedByString:@","];
    NSString *names =[nameArray componentsJoinedByString:@","];
    
    NSString *tj =[NSString stringWithFormat:@"%@#%@",num,names];
//    NSLog(@"--%@",tj);
    
    [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"IOSFA.getmulcheckboxresult('%@')",tj]];
}
/**
 *  uibuttin
 */
- (void)navback
{

    if (self.backTwo){
        
        //    ZKBasicViewController *sirendingzhi = self.navigationController.viewControllers[self.navigationController.viewControllers.count - 2];
        //    [self.navigationController popToViewController:sirendingzhi animated:YES];
        
        NSUInteger index = [[self.navigationController viewControllers] indexOfObject:self];
        
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:index-2] animated:YES];
        
        return;
    }
    
    /**
     *  判断是不是第一个页面。
     */
    
    if (strIsEmpty(pur) ==1) {
        
        [self.navigationController popViewControllerAnimated:YES];
        
        return;
        
    }
    
    if ([self.webToUrl isEqualToString:pur]) {
        
        [self.navigationController popViewControllerAnimated:YES];
        
    }else{
        
        if (record>0) {
            
            for (int i=0; i<record+1; i++) {
                
                [self.webView goBack];
            }
            
            record =0;
            
        }else{
            
            [self.webView  goBack];
            
        }
        
    }

}

-(void)enterClick
{
    
    
    
    [self.webView stringByEvaluatingJavaScriptFromString:@"IOSFA.rightbuttonclickoutfun()"];
    
}

- (void)enterClick2
{
    
    
   [self.webView stringByEvaluatingJavaScriptFromString:@"IOSFA.rightbuttonclickoutfun2()"];

}

/**
 *  置顶
 */
-(void)stickButton
{
    
    [self.webView stringByEvaluatingJavaScriptFromString:stick];
    
}



#pragma mark  照片方法

-(void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex{
    if(buttonIndex == 0||buttonIndex ==3){
        return;
    }
    
    if(imagePickerController == nil){
        imagePickerController = [[ZKCommonImagePickerController alloc] init];
        imagePickerController.imagePickerDelegate = self;
        
    }
    if(buttonIndex == 1){
        
        imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        
    }else if(buttonIndex == 2){
        imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    [self presentViewController:imagePickerController animated:YES completion:nil];
}




#pragma mark - ZYQAssetPickerController Delegate
/**
 *  多选照片
 *
 *  @param picker ZYQAssetPickerController
 *  @param assets 照片类容
 */
-(void)assetPickerController:(ZYQAssetPickerController *)picker  didFinishPickingAssets:(NSArray *)assets{
    
    for (int i=0; i<assets.count; i++) {
        ALAsset *asset=assets[i];
        UIImage *tempImg=[UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage];
        
        
        NSData *_data = UIImageJPEGRepresentation(tempImg, 0.1f);
        
        NSString *_encodedImageStr = [_data base64EncodedStringWithOptions:0];
        
        NSString *sign =[NSString stringWithFormat:@"fot_%ld",i+1+numphotograph];
        
        [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"fun_z_returnMulofpics('data:image/png;base64,%@#%@')",_encodedImageStr,sign]];
        
        [photographDic setObject:_data forKey:sign];
//        NSLog(@" --- %@",sign);
    }
}



#pragma mark UIImagePickerControllerDelegate
//完成
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    NSString *mediaType=[info objectForKey:UIImagePickerControllerMediaType];
    
    if([mediaType isEqualToString:(NSString *)kUTTypeMovie]){//如果是录制视频
//        NSLog(@"video...");
        
        NSURL *spPathUrl=[info objectForKey:UIImagePickerControllerMediaURL];//视频路径
        
        [ZKUtil MyValue:spPathUrl.absoluteString MKey:@"shiping"];

        //压缩视频
        
//        NSString *videoPathName = [self dateString];
//        NSURL *uploadURL = [NSURL fileURLWithPath:[[appDocumentPath stringByAppendingPathComponent:videoPathName] stringByAppendingString:@".3pg"]];
//       
//        // Compress movie first
//        
//        [self convertVideoToLowQuailtyWithInputURL:spPathUrl outputURL:uploadURL];
//        [ZKUtil MyValue:videoPathName MKey:@"shiping"];
        
        if (isSPno ==NO) {
            
            UIImage *picImage =[self testGenerateThumbNailDataWithVideo:spPathUrl];
            
            
            NSData *_data = UIImageJPEGRepresentation(picImage, 0.5f);
            
            NSString *_encodedImageStr = [_data base64EncodedStringWithOptions:0];
            
            [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"sendKeLuVideosData('data:image/png;base64,%@#%@')",_encodedImageStr,@"vodio"]];
        }
 
        
        NSString *urlStr=[spPathUrl path];
        
           self.view.userInteractionEnabled =NO;
        
        if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(urlStr)) {
            //保存视频到相簿，注意也可以使用ALAssetsLibrary来保存
            UISaveVideoAtPathToSavedPhotosAlbum(urlStr, self, @selector(video:didFinishSavingWithError:contextInfo:), nil);//保存视频到相簿
        }
        
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
     self.view.userInteractionEnabled =YES;
    
    if (isSPno==YES){
    ZKSecondaryViewController *vc =[[ZKSecondaryViewController alloc]init];
    vc.webToUrl =[spHtml stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [self.navigationController pushViewController:vc animated:YES];
    }
}




-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
//    NSLog(@"取消");
    
    [self dismissViewControllerAnimated:YES completion:nil];
     self.view.userInteractionEnabled =YES;
}


//视频保存后的回调
- (void)video:(NSString *)videoPath didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    
       self.view.userInteractionEnabled =YES;
    
    if (error) {
        
        [[APPDELEGATE window] makeToast:@"保存视频过程中发生错误"];
        
        //        NSLog(@"保存视频过程中发生错误，错误信息:%@",error.localizedDescription);
        
    }else{
        
//        NSLog(@"视频保存成功.%@",contextInfo);
        //录制完之后自动播放
//        NSLog(@"  ==  url  %@",videoPath);
        
        videoUrl =videoPath;
        
    }
}


#pragma mark -
#pragma mark 生成缩略图：
- (UIImage*)testGenerateThumbNailDataWithVideo:(NSURL *)videoURL {
    
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:videoURL options:nil];
    AVAssetImageGenerator *gen = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    gen.appliesPreferredTrackTransform = YES;
    CMTime time = CMTimeMakeWithSeconds(0.0, 600);
    NSError *error = nil;
    CMTime actualTime;
    
    CGImageRef image = [gen copyCGImageAtTime:time actualTime:&actualTime error:&error];
    UIImage *currentImg = [[UIImage alloc] initWithCGImage:image];
    CGImageRelease(image);
    
    return currentImg;
}


#pragma mark - 录制方法
-(void)myimagePicker{
    
    
    [_imagePicker removeFromParentViewController];
    
    _imagePicker=[[UIImagePickerController alloc]init];
    _imagePicker.sourceType=UIImagePickerControllerSourceTypeCamera;//设置image picker的来源，这里设置为摄像头
    _imagePicker.cameraDevice=UIImagePickerControllerCameraDeviceRear;//设置使用哪个摄像头，这里设置为后置摄像头
    
    _imagePicker.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:_imagePicker.sourceType];
//    _imagePicker.mediaTypes=@[(NSString *)kUTTypeMovie];
    
    _imagePicker.cameraCaptureMode=UIImagePickerControllerCameraCaptureModeVideo;//设置摄像头模式（拍照，录制视频）
    _imagePicker.videoQuality = UIImagePickerControllerQualityTypeMedium;//视频质量设置
    _imagePicker.delegate = self;
    _imagePicker.allowsEditing = YES;
    _imagePicker.videoMaximumDuration = 300.0f;//设置最长录制5分钟
//    _imagePicker.mediaTypes = [NSArray arrayWithObject:@"public.movie"];
    
    
    
    [self presentViewController:_imagePicker animated:YES completion:nil];
    

    
}

- (void)PimagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    @autoreleasepool {
        [self dismissViewControllerAnimated:YES completion:nil];
        
        UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
        if(!image){
            image = [info objectForKey:UIImagePickerControllerOriginalImage];
        }
        if(!image){
            return;
        }
        
        NSURL *url = [info objectForKey:UIImagePickerControllerReferenceURL];
        
        //添加选择的图片
        if(url){
            ALAssetsLibrary *assetLibrary = [[ALAssetsLibrary alloc] init];
            [assetLibrary assetForURL:url resultBlock:^(ALAsset *asset)  {
                if(asset){
                    ALAssetRepresentation *representation = asset.defaultRepresentation;
                    UIImage *assetImageData = [UIImage imageWithCGImage:representation.fullResolutionImage scale:representation.scale orientation:(UIImageOrientation)representation.orientation];
                    
                    
                    if (assetImageData) {
                        //相册
                        
                        [self addDataImage:[UIImage imageWithCGImage:asset.thumbnail]];
                        
                    }else{
                        
                        
                        
                        [self addDataImage:[UIImage imageWithCGImage:asset.thumbnail]];
                        
                    }
                }
            } failureBlock:^(NSError *error) {
                
            }];
        }else{
            
            
            [self addDataImage:[image imageByScalingAndCroppingForSize:CGSizeMake(157, 157)]];
            
        }
    }
}

//保存图片
-(void)addDataImage:(UIImage*)data
{
    
    NSData *_data = UIImageJPEGRepresentation(data, 0.1f);
    
    NSString *_encodedImageStr = [_data base64EncodedStringWithOptions:0];
    
    [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"fun_z_returnOneofpic('data:image/png;base64,%@#%@')",_encodedImageStr,@"fot_0"]];
    [photographDic setObject:_data forKey:@"fot_0"];
  
}


#pragma mark 相册代理

- (void)PimagePickerControllerDidCancel:(UIImagePickerController *)picker;
{
  
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

/**
 *  保存图片到相册
 */
- (void)saveImage:(UIImage*)img
{
    if (!img) {
        [self.view makeToast:@"图片出错了"];
        return;
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        UIImageWriteToSavedPhotosAlbum(img, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    });
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (error) {
        
        [MBProgressHUD showSuccess:@"保存失败" toView:nil];
    } else {
        
        [MBProgressHUD showSuccess:@"成功保存到相册" toView:nil];
    }
}


#pragma mark 点击事件
-(void)TOback;
{

    back720bty = [[UIButton alloc]initWithFrame:CGRectMake(2, 20, buttonItemWidth, buttonItemWidth)];
    [back720bty setImage:[UIImage imageNamed:@"backimage"] forState:UIControlStateNormal];
    back720bty.backgroundColor =[UIColor clearColor];
    [back720bty addTarget:self action:@selector(back720) forControlEvents:UIControlEventTouchUpInside];
    [[APPDELEGATE window] addSubview:back720bty];
}
-(void)back720
{

    if (back720bty) {
        
        [back720bty removeFromSuperview];
        
    }
    [self.navigationController popViewControllerAnimated:YES];
    


}

#pragma mark 获取位置
-(void)locan
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


- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *currLocation = [locations lastObject];
    NSString *add =[NSString stringWithFormat:@"%f,%f",currLocation.coordinate.longitude,currLocation.coordinate.latitude];
    
    ToLatitude =currLocation.coordinate.latitude;
    ToLongitude =currLocation.coordinate.longitude;
    
    if (isjuli ==NO) {
        
        [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"IOSFA.returngaodemaplnglatresult('%@')",add]];
        
        
    }else if (isjuli ==YES){
        //返回距离
        NSArray *arra2 =[endOf componentsSeparatedByString:@","];
        
        double k1 =ToLatitude;
        double k2 =ToLongitude;
        double w1 =[arra2[0] doubleValue];
        double w2 =[arra2[1] doubleValue];
        
        _startPoint = [AMapNaviPoint locationWithLatitude:k1 longitude:k2];
        _endPoint   = [AMapNaviPoint locationWithLatitude:w1 longitude:w2];
        
        CLLocation *orig=[[CLLocation alloc] initWithLatitude:_startPoint.latitude longitude:_startPoint.longitude];
        CLLocation* dist=[[CLLocation alloc] initWithLatitude:_endPoint.latitude longitude:_endPoint.longitude];
        CLLocationDistance kilometers = [orig distanceFromLocation:dist];
        
        [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"IOSFA.sendMapdistancetopage('%f')",kilometers]];
        
    }
    
    [self.view makeToast:@"定位成功"];
    [_locationManager stopUpdatingLocation];
}


/**
 *  实现Observer的回调方法
 *
 *  @return 方法
 */

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    
    
    NSString *requestString = [object valueForKey:@"popl"];//获取请求的绝对路径.
    [self.webView stringByEvaluatingJavaScriptFromString:requestString];

}


#pragma mark  摇一摇代理
//    开始摇一摇

-(void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    
    
}
/** 摇一摇取消（被中断，比如突然来电） */
-(void)motionCancelled:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    
    
}
/** 摇一摇结束（需要在这里处理结束后的代码） */
-(void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    
    if (event.subtype == UIEventSubtypeMotionShake) {
        
        //something happens
        
        [self.webView stringByEvaluatingJavaScriptFromString:@"yyyResultOver()"];
        
    }
}

#pragma mark - 日期选择的回调
- (void)customCalendarViewController:(CustomCalendarViewController *)customCalendarViewController didSelectedDate:(NSDate *)date
{
    if (date==nil) {
        date = [NSDate date];
    }
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-M-d";
    
    NSString *dateStr = [fmt stringFromDate:date];
    
    [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"z_set_selectdate('%@')",dateStr]];
}

- (void)mutiCalendarViewController:(ZKMutiCalendarViewController *)mutiCalendarViewController didSelectRangeFrom:(NSDate *)startDate to:(NSDate *)endDate dayCount:(NSInteger)dayCount
{
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd";
    fmt.locale = [NSLocale localeWithLocaleIdentifier:@"en_US"];
    
    NSString *start = [fmt stringFromDate:startDate];
    NSString *end = [fmt stringFromDate:endDate];
    
    NSString *webstr = [NSString stringWithFormat:@"z_set_selectdate('%@,%@,%ld')", start, end, (long)dayCount];
    [self.webView stringByEvaluatingJavaScriptFromString:webstr];

}

- (void)dealloc
{
    
    NSLog(@"------dealloc--");
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
