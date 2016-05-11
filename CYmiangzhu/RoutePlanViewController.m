//
//  RoutePlanViewController.m
//  officialDemoNavi
//
//  Created by LiuX on 14-9-1.
//  Copyright (c) 2014年 AutoNavi. All rights reserved.
//

#import "RoutePlanViewController.h"
#import "NavPointAnnotation.h"


//#import "ZKGIHUD.h"
#define kSetingViewHeight   64

typedef NS_ENUM(NSInteger, NavigationTypes)
{
    NavigationTypeNone = 0,
    NavigationTypeSimulator, // 模拟导航
    NavigationTypeGPS,       // 实时导航
};

typedef NS_ENUM(NSInteger, TravelTypes)
{
    TravelTypeCar = 0,    // 驾车方式
    TravelTypeWalk,       // 步行方式
};

@interface RoutePlanViewController ()<AMapNaviViewControllerDelegate,CLLocationManagerDelegate>
{
    //经度
    double Klongitude;
    //纬度
    double Klatitude;
    
    
    //经度
    double Wlongitude;
    //纬度
    double Wlatitude;
    
    
    UILabel *navigation;
    UILabel *navInformationnac;
    
    NSString *kilometre;
    NSString *minute;
    NSString *money;
    
    UIButton *setButton;
    
    float  zoomF;
    
    UIView *zoomView;
    
    
}
@property (nonatomic, strong) AMapNaviPoint* startPoint;
@property (nonatomic, strong) AMapNaviPoint* endPoint;

@property (nonatomic, strong) NSArray *annotations;

@property (nonatomic, strong) MAPolyline *polyline;

@property (nonatomic) BOOL calRouteSuccess; // 指示是否算路成功

@property (nonatomic) NavigationTypes naviType;
@property (nonatomic) TravelTypes travelType;


@property (nonatomic ,strong) UIView *navigationBarView;
@property (nonatomic ,strong) UIButton *leftBarButtonItem;
@property (nonatomic ,strong) UIButton *rightBarButtonItem;
@property (nonatomic ,strong) UIButton *motoring;
@property (nonatomic ,strong) UIButton *walk;
@property (nonatomic ,strong) UIButton *zoomButton;

@end

@implementation RoutePlanViewController


#pragma mark - Life Cycle

-(id)initKLat:(double)Klat KLon:(double)Klon WLat:(double)Wlat WLon:(double)Wlon;
{
    
    self = [super init];
    if (self)
    {
        Klongitude =Klon;
        
        Klatitude =Klat;
        
        Wlongitude =Wlon;
        
        Wlatitude =Wlat;
        
        zoomF =10;
        
        self.hidesBottomBarWhenPushed =YES;
        // 初始化travel方式为驾车方式
        self.travelType = TravelTypeCar;
    }
    return self;
    
    
}


- (void)viewDidLoad
{
   
    [self.navigationBarView removeFromSuperview];
    kilometre =@"0";
    minute =@"0";
    money =@"0";
    [super viewDidLoad];
    [self initNaviPoints];
    [self configSubViews];
    
    [self configMapView];
    [self routeCal];
    
    
}



- (void)configSubViews
{
    
    
    self.navigationBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width,64)];
    self.navigationBarView.backgroundColor = [UIColor colorWithRed:231/255.0 green:231/255.0 blue:231/255.0 alpha:1];
    [self.view addSubview:self.navigationBarView];
    
    self.leftBarButtonItem = [[UIButton alloc]initWithFrame:CGRectMake(2, 16, 50, 50)];
    [self.leftBarButtonItem setImage:[UIImage imageNamed:@"backimage"] forState:UIControlStateNormal];
    self.leftBarButtonItem.backgroundColor =[UIColor clearColor];
    [self.leftBarButtonItem addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    
    self.rightBarButtonItem =[[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width-2-50, 20, 40, 35)];
    self.rightBarButtonItem.backgroundColor = [UIColor colorWithRed:68/255.0 green:206/255.0 blue:0/255.0 alpha:1];
    [self.rightBarButtonItem setTitle:@"导航" forState:UIControlStateNormal];
    self.rightBarButtonItem.titleLabel.font =[UIFont systemFontOfSize:12];
    [self.rightBarButtonItem setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.rightBarButtonItem.layer.cornerRadius =5;
    [self.rightBarButtonItem addTarget:self action:@selector(gpsNavi) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.rightBarButtonItem];
    [self.view addSubview:self.leftBarButtonItem];
    
    UISegmentedControl *segCtrl = [[UISegmentedControl alloc] initWithItems:@[@"驾车" , @"步行"]];
    segCtrl.tintColor = [UIColor grayColor];
    [segCtrl setBounds:CGRectMake (0 ,0 ,180 ,30)];
    [segCtrl addTarget:self action:@selector(segCtrlClick:) forControlEvents:UIControlEventValueChanged];
    [segCtrl setTitleTextAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:17]}
                           forState:UIControlStateNormal];
    
    segCtrl.left                 = (self.view.width - 180) / 2;
    segCtrl.top                  = 25;
    segCtrl.selectedSegmentIndex = 0;
    [self.view addSubview:segCtrl];
    
    UIView *foortView =[[UIView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height -64, self.view.frame.size.width, 64)];
    foortView.backgroundColor =[UIColor colorWithRed:231/255.0 green:231/255.0 blue:231/255.0 alpha:1];
    [self.view addSubview:foortView];
    
    navigation =[[UILabel alloc]initWithFrame:CGRectMake(5, 5, 100, 20)];
    navigation.backgroundColor =[UIColor clearColor];
    navigation.text =@"导航方案:驾车";
    navigation.textColor =[UIColor blackColor];
    navigation.font =[UIFont systemFontOfSize:12];
    [foortView addSubview:navigation];
    
    navInformationnac =[[UILabel alloc]initWithFrame:CGRectMake(5, 25, self.view.frame.size.width -10, 30)];
    navInformationnac.backgroundColor =[UIColor clearColor];
    navInformationnac.textColor =[UIColor blackColor];
    navInformationnac.text =[NSString stringWithFormat:@"%@公里/%@分钟/花费%@元",kilometre,minute,money];
    [foortView addSubview:navInformationnac];
    
    for (int i=0; i<2; i++) {
        _zoomButton =[[UIButton alloc]initWithFrame:CGRectMake(self.mapView.frame.size.width-50, self.view.frame.size.height-164+(40*i), 40, 40)];
        [_zoomButton setImage:[UIImage imageNamed:[NSString stringWithFormat:@"sx_%d",i]] forState:UIControlStateNormal];
        _zoomButton.tag =2000+i;
        _zoomButton.backgroundColor =[UIColor whiteColor];
        _zoomButton.layer.opacity =0.7;
        _zoomButton.layer.borderColor =[UIColor grayColor].CGColor;
        _zoomButton.layer.borderWidth =0.5;
        [_zoomButton addTarget:self action:@selector(zoomClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_zoomButton];
    }
    

    
}



- (void)configMapView
{
    
    [self.mapView setDelegate:self];
    [self.mapView showsUserLocation];
    [self.mapView setFrame:CGRectMake(0, kSetingViewHeight,
                                      self.view.bounds.size.width,
                                      self.view.bounds.size.height - kSetingViewHeight*2)];
    [self.view insertSubview:self.mapView atIndex:0];
    
    if (_calRouteSuccess)
    {
        [self.mapView addOverlay:_polyline];
    }
    
    if (self.annotations.count > 0)
    {
        [self.mapView addAnnotations:self.annotations];
    }
    [self showRouteWithNaviRoute:self.naviManager.naviRoute];
    [self.mapView showAnnotations:self.annotations animated:YES];

    
    
    
    
}



#pragma mark - Construct and Inits

- (void)initNaviPoints
{
    
    
    _startPoint = [AMapNaviPoint locationWithLatitude:Klatitude longitude:Klongitude];
    _endPoint   = [AMapNaviPoint locationWithLatitude:Wlatitude longitude:Wlongitude];
    
    [self initAnnotations];
}


- (void)initAnnotations
{
    NavPointAnnotation *beginAnnotation = [[NavPointAnnotation alloc] init];
    
    [beginAnnotation setCoordinate:CLLocationCoordinate2DMake(_startPoint.latitude, _startPoint.longitude)];
    beginAnnotation.title        = @"起始点";
    beginAnnotation.navPointType = NavPointAnnotationStart;
    
    NavPointAnnotation *endAnnotation = [[NavPointAnnotation alloc] init];
    
    [endAnnotation setCoordinate:CLLocationCoordinate2DMake(_endPoint.latitude, _endPoint.longitude)];
    
    endAnnotation.title        = @"终点";
    endAnnotation.navPointType = NavPointAnnotationEnd;
    
    self.annotations = @[beginAnnotation, endAnnotation];
//    [self.mapView showAnnotations:self.annotations animated:YES];
    
}



#pragma mark - Utils Methods
-(void)backClick
{
    
    
    [self returnAction];
    
}

- (void)showRouteWithNaviRoute:(AMapNaviRoute *)naviRoute
{
    if (naviRoute == nil) return;
    
    // 清除旧的overlays
    if (_polyline)
    {
        [self.mapView removeOverlay:_polyline];
        self.polyline = nil;
        
    }
    
    NSUInteger coordianteCount = [naviRoute.routeCoordinates count];
    CLLocationCoordinate2D coordinates[coordianteCount];
    for (int i = 0; i < coordianteCount; i++)
    {
        AMapNaviPoint *aCoordinate = [naviRoute.routeCoordinates objectAtIndex:i];
        coordinates[i] = CLLocationCoordinate2DMake(aCoordinate.latitude, aCoordinate.longitude);
    }
    
    _polyline = [MAPolyline polylineWithCoordinates:coordinates count:coordianteCount];
    [self.mapView addOverlay:_polyline];
    [self.mapView setVisibleMapRect:[_polyline boundingMapRect] animated:NO];
    
        [self.mapView showAnnotations:self.annotations animated:YES];
}


#pragma mark - Button Actions

-(void)zoomClick:(UIButton*)sender
{


    if (sender.tag ==2000) {
        
        zoomF =zoomF+0.5;
        
    }else{
    
        zoomF =zoomF-0.5;
    }
    
    [self.mapView setZoomLevel:zoomF animated:YES];
}


- (void)routeCal
{
    NSArray *startPoints = @[_startPoint];
    NSArray *endPoints   = @[_endPoint];
   
    if (self.travelType == TravelTypeCar)
    {
        [self.naviManager calculateDriveRouteWithStartPoints:startPoints endPoints:endPoints wayPoints:nil drivingStrategy:0];
        
    }
    else
    {
        [self.naviManager calculateWalkRouteWithStartPoints:startPoints endPoints:endPoints];
    }
    
    
    
}


- (void)simulatorNavi:(id)sender
{
    if (_calRouteSuccess)
    {
        self.naviType = NavigationTypeSimulator;
        
        
        AMapNaviViewController *naviViewController = [[AMapNaviViewController alloc]
                                                      initWithMapView:self.mapView delegate:self];
        [self.naviManager presentNaviViewController:naviViewController animated:NO];
    }
    else
    {
        [self.view makeToast:@"路线规划规划失败，请打开定位服务！"
                    duration:1.0
                    position:[NSValue valueWithCGPoint:CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2)]];
    }
}

#pragma mark 导航
- (void)gpsNavi
{
    if (_calRouteSuccess)
    {
        self.naviType = NavigationTypeGPS;
        
        /**
         * 特别说明：因为导航sdk与demo中使用的是同一个地图，所以当进入导航界面（AMapNaviViewController）时，当前的地图
         * 状态（包括delegate属性、所有overlays、annotations等等）会被清除，所以在进入和退出导航界面时请根据自己的需要
         * 做好当前地图状态的保存和恢复工作。
         */
        
        AMapNaviViewController *naviViewController = [[AMapNaviViewController alloc]
                                                      initWithMapView:self.mapView delegate:self];
        
        
        
        [self.naviManager presentNaviViewController:naviViewController animated:YES];
        
    }
    else
    {
        [self.view makeToast:@" 正在规划路线，请稍等 ！"
                    duration:1.0
                    position:[NSValue valueWithCGPoint:CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2)]];
    }
}
//计算2点距离
-(NSString*)distanceLat:(double)lat Lon:(double)lon;

{

    //1.将两个经纬度点转成投影点
    
    if (!(lat>0)) {
        [[APPDELEGATE  window] makeToast:@"地图还未初始化"];
        
        return nil;
    }
    
    MAMapPoint point1 = MAMapPointForCoordinate(CLLocationCoordinate2DMake(Klatitude,Klongitude));
    
    MAMapPoint point2 = MAMapPointForCoordinate(CLLocationCoordinate2DMake(lat,lon));

    
    //2.计算距离
    
    CLLocationDistance distance = MAMetersBetweenMapPoints(point1,point2);
    
    NSString *l =[NSString stringWithFormat:@"%f",distance];
    
    return l;

}
#pragma mark - AMapNaviManager Delegate

- (void)AMapNaviManager:(AMapNaviManager *)naviManager onCalculateRouteFailure:(NSError *)error
{
//    [super AMapNaviManager:naviManager onCalculateRouteFailure:error];
}


- (void)AMapNaviManagerOnCalculateRouteSuccess:(AMapNaviManager *)naviManager
{
//    [super AMapNaviManagerOnCalculateRouteSuccess:naviManager];
    
    
    [self showRouteWithNaviRoute:[[naviManager naviRoute] copy]];
    navInformationnac.text =[NSString stringWithFormat: @"全程%.2f公里 / %d分钟/ 收费:%d元",
                             self.naviManager.naviRoute.routeLength / 1000.0, self.naviManager.naviRoute.routeTime / 60,self.naviManager.naviRoute.routeTollCost];
    
    _calRouteSuccess = YES;
}


- (void)AMapNaviManager:(AMapNaviManager *)naviManager didPresentNaviViewController:(UIViewController *)naviViewController
{
//    [super AMapNaviManager:naviManager didPresentNaviViewController:naviViewController];
    
    [self initIFlySpeech];
    
    if (self.naviType == NavigationTypeGPS)
    {
        [self.naviManager startGPSNavi];
    }
    else if (self.naviType == NavigationTypeSimulator)
    {
        [self.naviManager startEmulatorNavi];
    }
    
    
}

#pragma mark - AManNaviViewController Delegate

/*!
 @brief 导航界面关闭按钮点击时的回调函数
 */

- (void)AMapNaviViewControllerCloseButtonClicked:(AMapNaviViewController *)naviViewController
{
    if (self.naviType == NavigationTypeGPS)
    {
        [self.iFlySpeechSynthesizer stopSpeaking];
        
        self.iFlySpeechSynthesizer.delegate = nil;
        self.iFlySpeechSynthesizer          = nil;
        
        [self.naviManager stopNavi];
    }
    else if (self.naviType == NavigationTypeSimulator)
    {
        [self.iFlySpeechSynthesizer stopSpeaking];
        
        self.iFlySpeechSynthesizer.delegate = nil;
        self.iFlySpeechSynthesizer          = nil;
        
        [self.naviManager stopNavi];
    }
    
    [self.naviManager dismissNaviViewControllerAnimated:YES];
    
    // 退出导航界面后恢复地图的状态
    [self configMapView];
    
    
    
}

/*!
 @brief 导航界面更多按钮点击时的回调函数
 */
- (void)AMapNaviViewControllerMoreButtonClicked:(AMapNaviViewController *)naviViewController
{
    
    if (naviViewController.viewShowMode == AMapNaviViewShowModeCarNorthDirection)
    {
        naviViewController.viewShowMode = AMapNaviViewShowModeMapNorthDirection;
    }
    else
    {
        naviViewController.viewShowMode = AMapNaviViewShowModeCarNorthDirection;
    }
    
    
}

/*!
 @brief 导航界面转向指示View点击时的回调函数
 */
- (void)AMapNaviViewControllerTrunIndicatorViewTapped:(AMapNaviViewController *)naviViewController
{
    NSLog(@"zhixiao");
    
    [self.naviManager readNaviInfoManual];
}


#pragma mark - MAMapView Delegate

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[NavPointAnnotation class]])
    {
        static NSString *annotationIdentifier = @"annotationIdentifier";
        
        MAPinAnnotationView *pointAnnotationView = (MAPinAnnotationView*)[self.mapView dequeueReusableAnnotationViewWithIdentifier:annotationIdentifier];
        if (pointAnnotationView == nil)
        {
            pointAnnotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation
                                                                  reuseIdentifier:annotationIdentifier];
        }
        
        pointAnnotationView.animatesDrop   = NO;
        pointAnnotationView.canShowCallout = NO;
        pointAnnotationView.draggable      = NO;
        
        NavPointAnnotation *navAnnotation = (NavPointAnnotation *)annotation;
        
        if (navAnnotation.navPointType == NavPointAnnotationStart)
        {
            pointAnnotationView.image =[UIImage imageNamed:@"startpoint"];
            pointAnnotationView.center =CGPointMake(0, -18);
        }
        else if (navAnnotation.navPointType == NavPointAnnotationEnd)
        {
            pointAnnotationView.image =[UIImage imageNamed:@"endpoint"];
            pointAnnotationView.centerOffset =CGPointMake(0, -18);

        }
        return pointAnnotationView;
    }
    
    return nil;
}


- (MAOverlayView *)mapView:(MAMapView *)mapView viewForOverlay:(id<MAOverlay>)overlay
{
    if ([overlay isKindOfClass:[MAPolyline class]])
    {
        MAPolylineView *polylineView = [[MAPolylineView alloc] initWithPolyline:(MAPolyline*)overlay];
        
        polylineView.lineWidth    = 8.f;
        [polylineView loadStrokeTextureImage:[UIImage imageNamed:@"arrowTexture"]];
        

        
        return polylineView;
    }
    return nil;
}


#pragma mark - SegCtrl Event

-(void)segCtrlClick:(id)sender
{
    UISegmentedControl *segCtrl = (UISegmentedControl *)sender;
    
    TravelTypes travelType = segCtrl.selectedSegmentIndex == 0 ? TravelTypeCar : TravelTypeWalk;
    if (travelType != self.travelType)
    {
        self.travelType      = travelType;
        self.calRouteSuccess = NO;
        
        if (_polyline)
        {
            
            
            [self.mapView removeOverlay:_polyline];
            self.polyline = nil;
            [self routeCal];
            
        }else{
            
            [self.mapView removeOverlay:_polyline];
            self.polyline = nil;
            [self routeCal];
            
        }
    }
}

@end
