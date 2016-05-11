//
//  ZKHomViewController.m
//  CYmiangzhu
//
//  Created by Daqsoft-Mac on 15/8/11.
//  Copyright (c) 2015年 WangXiaoLa. All rights reserved.
//

#import "ZKHomViewController.h"
#import "ZKnavMapViewController.h"
#import <CoreLocation/CoreLocation.h>


#define ratio 1.09


@interface ZKHomViewController ()<CLLocationManagerDelegate>
{
    UIScrollView *scroll;
    
    UIView *contView;
    
    
}
@property (nonatomic, strong) CLLocationManager  *locationManager;
@end

@implementation ZKHomViewController

-(id)init
{
    self =[super init];
    if (self) {
        
    }
    return self;
}


-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.tabBarController.tabBar.layer.opacity=0;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}

#pragma mark 地图相关
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
    
    _Latitude =currLocation.coordinate.latitude;
    _Longitude =currLocation.coordinate.longitude;
    [ZKUtil MyValue:[NSString stringWithFormat:@"%f",_Latitude] MKey:@"Latitude"];
    [ZKUtil MyValue:[NSString stringWithFormat:@"%f",_Longitude] MKey:@"Longitude"];
    [_locationManager stopUpdatingLocation];
    
    CLLocation *c = [[CLLocation alloc] initWithLatitude:_Latitude longitude:_Longitude];
    //创建位置
    CLGeocoder *revGeo = [[CLGeocoder alloc] init];
    [revGeo reverseGeocodeLocation:c
     //反向地理编码
                 completionHandler:^(NSArray *placemarks, NSError *error) {
                     
                     if (!error && [placemarks count] > 0)
                     {
                         NSDictionary *dict =
                         [[placemarks objectAtIndex:0] addressDictionary];
                         NSLog(@"street address: %@",
                               //记录地址
                               dict);
                         
                         NSString *str =[dict objectForKey:@"Name"];
                         
                         str =[str stringByReplacingOccurrencesOfString:@"中国" withString:@""];
                         [ZKUtil MyValue:str MKey:@"adder"];
                         [ZKUtil MyValue:[dict objectForKey:@"City"] MKey:@"myCity"];
                         
                         
                     }
                     else
                     {
                         
                         
                         NSLog(@"ERROR: %@", error); }
                 }];
}


- (void)viewDidLoad {
    
    
    
    [super viewDidLoad];
    
    [[BaiduMobStat defaultStat] logEvent:@"back4home" eventLabel:@"返回首页"];
    
    [self locan];
    
    
    [self.leftBarButtonItem removeFromSuperview];
    [self initViews];
    // Do any additional setup after loading the view.
    
    
    
    
    
    
    
}

-(void)initViews
{
    
    
    contView =[[UIView alloc]initWithFrame:[[UIApplication sharedApplication].delegate window].bounds
               ];
    
    contView.backgroundColor =[UIColor whiteColor];
    [self.view addSubview:contView];
    
    scroll =[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight)];
    scroll.showsVerticalScrollIndicator =NO;
    scroll.showsHorizontalScrollIndicator =NO;
    scroll.pagingEnabled =YES;
    scroll.contentOffset =CGPointMake(0, 0);
    scroll.bounces =NO;
    scroll.contentSize =CGSizeMake(kDeviceWidth*2, kDeviceHeight);
    [contView addSubview:scroll];
    
    UIImageView *backImagView =[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth*2, kDeviceHeight)];
    backImagView.backgroundColor =[UIColor whiteColor];
    backImagView.image =[UIImage imageNamed:@"homBack.jpg"];
    
    [scroll addSubview:backImagView];
    
    
    UIImageView *signImage =[[UIImageView alloc]initWithFrame:CGRectMake(10, 20, 80, 130)];
    signImage.backgroundColor =[UIColor clearColor];
    signImage .image =[UIImage imageNamed:@"hom_biaoji"];
    [self.view addSubview:signImage];
    
    
    float jianju ;
    
    float clicksize ;
    
    float SXjj ;
    
    
    jianju =20;
    clicksize =(kDeviceWidth*2-jianju*6)/5;;
    SXjj =5;
    
    
    UIView *centView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth*2, clicksize*3-SXjj*2)];
    centView.center =CGPointMake(kDeviceWidth, scroll.center.y+35);
    centView.backgroundColor =[UIColor clearColor];
    [scroll addSubview:centView];
    
    
    for (int i =0; i<4; i++) {
        
        UIButton *bty =[[UIButton alloc]initWithFrame:CGRectMake(jianju*3/2+clicksize/2+(clicksize+jianju)*i, 0, clicksize, clicksize * ratio)];
        
        [bty setImage:[UIImage imageNamed:[NSString stringWithFormat:@"hom_button_%d",i]] forState:UIControlStateNormal];
        bty.tag =1000+i;
        [bty addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [centView addSubview:bty];
    }
    
    for (int i =0; i<5; i++) {
        
        UIButton *bty =[[UIButton alloc]initWithFrame:CGRectMake(jianju+(clicksize+jianju)*i,clicksize-SXjj, clicksize, clicksize*ratio)];
        
        [bty setImage:[UIImage imageNamed:[NSString stringWithFormat:@"hom_button_%d",i+4]] forState:UIControlStateNormal];
        bty.tag =1000+i+4;
        [bty addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [centView addSubview:bty];
    }
    
    for (int i =0; i<4; i++) {
        
        UIButton *bty =[[UIButton alloc]initWithFrame:CGRectMake(jianju*3/2+clicksize/2+(clicksize+jianju)*i, clicksize*2-SXjj*2, clicksize, clicksize*ratio)];
        
        [bty setImage:[UIImage imageNamed:[NSString stringWithFormat:@"hom_button_%d",i+9]] forState:UIControlStateNormal];
        bty.tag =1000+i+9;
        [bty addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [centView addSubview:bty];
    }
    
    
    
    UIButton *button_0 =[[UIButton alloc]initWithFrame:CGRectMake(35, self.view.frame.size.height-40, 55, 25)];
    button_0.backgroundColor =[UIColor clearColor];
    button_0.tag =2000;
    [button_0 addTarget:self action:@selector(tabBarClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button_0];
    
    
    float xJianju =(self.view.frame.size.width/2)/3;
    
    
    UIButton *button_1 =[[UIButton alloc]initWithFrame:CGRectMake(kDeviceWidth/2, kDeviceHeight-45, 25, 25)];
    [button_1 setImage:[UIImage imageNamed:@"hom_fujin"] forState:UIControlStateNormal];
    button_1.tag =2001;
    [button_1 addTarget:self action:@selector(tabBarClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button_1];
    
    
    UIButton *button_2 =[[UIButton alloc]initWithFrame:CGRectMake(kDeviceWidth/2+xJianju, kDeviceHeight-45, 25, 25)];
    [button_2 setImage:[UIImage imageNamed:@"hom_fenlei"] forState:UIControlStateNormal];
    button_2.tag =2002;
    [button_2 addTarget:self action:@selector(tabBarClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button_2];
    
    
    UIButton *button_3 =[[UIButton alloc]initWithFrame:CGRectMake(kDeviceWidth/2+xJianju*2, kDeviceHeight-45, 25, 25)];
    [button_3 setImage:[UIImage imageNamed:@"hom_my"] forState:UIControlStateNormal];
    button_3.tag =2003;
    [button_3 addTarget:self action:@selector(tabBarClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button_3];
    
}


#pragma mark 点击事件

-(void)buttonClick:(UIButton*)sender;
{
    
    NSInteger index =sender.tag-1000;
    
    if (index ==0) {
        /*** 特色美食 ***/
        //        [self jumpToWebUrl:webUrl(@"list_resource.aspx?z_isheadback=true&type=dining&setnew_head_search_shangjia=ture")];
        
        [self.navigationController pushViewController:[[NSClassFromString(@"ZKFoodViewController") alloc] init] animated:YES];
        [[BaiduMobStat defaultStat] logEvent:@"home_go_dining" eventLabel:@"首页-美食"];
        
    }else if (index ==1){
        /*** 休闲娱乐 ***/
        //        [self jumpToWebUrl:webUrl(@"list_resource.aspx?z_isheadback=true&type=recreation&setnew_head_search_shangjia=ture")];
        [[BaiduMobStat defaultStat] logEvent:@"home_go_recreation" eventLabel:@"首页-娱乐"];
        [self.navigationController pushViewController:[[NSClassFromString(@"ZKRecreationViewController") alloc] init] animated:YES];
    }else if (index ==2){
        
        /*** 自驾游 ***/
        [[BaiduMobStat defaultStat] logEvent:@"home_go_road" eventLabel:@"首页-线路 "];
        [self jumpToWebUrl:webUrl1(@"zjy/index.html")];
        
    }else if (index ==3){
        /*** 旅游资讯 ***/
        [self.navigationController pushViewController:[[NSClassFromString(@"ZKInformationViewController") alloc]init] animated:YES];
        [[BaiduMobStat defaultStat] logEvent:@"home_go_news" eventLabel:@"首页-资讯"];
        //        [self jumpToWebUrl:webUrl(@"list_news.aspx?z_isheadback=true&setnew_head_search_zixun=ture")];
        
    }else if (index ==4){
        /*** 酒店住宿 ***/
        
        //        NSString *url = @"HotelSale.aspx?z_isheadback=true&z_pagetitle=酒店住宿";
        //        [self jumpToWebUrl:webUrl(url)];
        [[BaiduMobStat defaultStat] logEvent:@"home_go_hotel" eventLabel:@"首页-酒店"];
        [self.navigationController pushViewController:[[NSClassFromString(@"ZKHotelViewController") alloc] init] animated:YES];
        
    }else if (index ==5){
        /*** 景区门票 ***/
        //        [self jumpToWebUrl:webUrl(@"list_scence.aspx?z_isheadback=true&z_pagetitle=景区门票")];
        [[BaiduMobStat defaultStat] logEvent:@"home_go_scenery" eventLabel:@"首页-景区"];
        [self.navigationController pushViewController:[[NSClassFromString(@"ZKSceneryTicketViewController") alloc] init]  animated:YES];
        
    }else if (index ==6){
        
        /*** 720全景 ***/
        [[BaiduMobStat defaultStat] logEvent:@"home_go_720" eventLabel:@"首页-全景 "];
        //        [self jumpToWebUrl:webUrl(@"_720.aspx?setnew_head_search_jqjd=true")];
        [self.navigationController pushViewController:[[NSClassFromString(@"ZK720ScenicViewController") alloc]init] animated:YES];
        
    }else if (index ==7){
        
        /*** 旅游季节 ***/
        [[BaiduMobStat defaultStat] logEvent:@"home_go_season" eventLabel:@"首页-季节"];
        [self.navigationController pushViewController:[[NSClassFromString(@"ZKTheTouristSeasonViewController") alloc]init]  animated:YES];
        
    }else if (index ==8){
        /*** 找旅行社 ***/
        
        [[BaiduMobStat defaultStat] logEvent:@"home_go_agency" eventLabel:@"首页-找旅行社"];
        ZKnavMapViewController *map = [[ZKnavMapViewController alloc] init];
        [self.navigationController pushViewController:map animated:YES];
        
        
    }else if (index ==9){
        /*** 特色购物 ***/
        [[BaiduMobStat defaultStat] logEvent:@"home_go_shopping" eventLabel:@"首页-购物"];
        //        [self jumpToWebUrl:webUrl(@"list_resource.aspx?z_isheadback=true&type=shopping&setnew_head_search_gouwu=ture")];
        
        [self.navigationController pushViewController:[[NSClassFromString(@"ZKShoppingViewController") alloc]init] animated:YES];
        
        
        
    }else if (index ==10){
        /*** 行程参考 ***/
        [self jumpToWebUrl:webUrl(@"trip.aspx?z_pagetitle=行程参考")];
        //[self.navigationController pushViewController:[[NSClassFromString(@"ZKTripViewController") alloc]init] animated:YES];
        
        
    }else if (index ==11){
        /*** 旅游攻略 ***/
        [[BaiduMobStat defaultStat] logEvent:@"home_go_strategy" eventLabel:@"首页-攻略 "];
        [self.navigationController pushViewController:[[NSClassFromString(@"ZKStrategyViewController") alloc]init] animated:YES];
        
        //        [self jumpToWebUrl:webUrl(@"lygl.aspx?z_isheadback=true&z_pagetitle=旅游攻略")];
        
    }else if (index ==12){
        /*** 私人定制 ***/

        [self.navigationController pushViewController:[[NSClassFromString(@"ZKsrdzViewController") alloc]init] animated:YES];
    }
    
    
}


- (void)jumpToWebUrl:(NSString *)webUrl
{
    
    ZKBasicViewController *web = [[ZKBasicViewController alloc] init];
    web.webToUrl = [webUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    web.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:web animated:YES];
}
/**
 *  下面的按钮
 *
 *  @param sender
 */
-(void)tabBarClick:(UIButton*)sender
{
    
    NSInteger index =sender.tag-2000;
    
    if (index>0) {
        
        self.tabBarController.tabBar.layer.opacity=1;
        
    }
    
    if (index ==0) {
        
        
    }else if (index ==1){
        
        self.tabBarController.selectedIndex =1;
        
    }else if (index ==2){
        
        self.tabBarController.selectedIndex =2;
        
    }else if (index ==3){
        
        self.tabBarController.selectedIndex =3;
        
    }
    
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
