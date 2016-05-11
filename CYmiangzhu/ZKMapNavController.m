//
//  RoutePlanViewController.m
//  officialDemoNavi
//
//  Created by LiuX on 14-9-1.
//  Copyright (c) 2014年 AutoNavi. All rights reserved.
//

#import "ZKMapNavController.h"
#import "NavPointAnnotation.h"
#import "ZKPlaceholderTextView.h"
#import <AMapSearchKit/AMapSearchAPI.h>
#import "GSLocationTool.h"
#import "ZKmyCityArrayView.h"
#import "ZKExplainView.h"
#import "MMLocationManager.h"
#import "CommonUtility.h"
#import "MANaviRoute.h"
//#import "ZKGIHUD.h"
#define kSetingViewHeight   64

//typedef NS_ENUM(NSInteger, NavigationTypes)
//{
//    NavigationTypeNone = 0,
//    NavigationTypeSimulator, // 模拟导航
//    NavigationTypeGPS,       // 实时导航
//};


typedef NS_ENUM(NSInteger, busAdder)
{
    busOne    = 0, //bus
    busTwo ,    //  第一个textView
    busThree,    //    第二个textView
    
};



typedef NS_ENUM(NSInteger, TravelTypes)
{
    TravelTBus    = 0, //bus
    TravelTypeCar ,    // 驾车方式
    TravelTypeWalk,    // 步行方式
    
};

typedef NS_ENUM(NSInteger, isBianji)
{
    bianjiOne    = 0, //nil
    bianjiTwo ,    // 第一个textView
    bianThree,    // 第二个textView
};

typedef NS_ENUM(NSInteger, MapSelectPointState)
{
    MapSelectPointStateNone = 0,
    MapSelectPointStateStartPoint, // 当前操作为选择起始点
    MapSelectPointStateEndPoint,   // 当前操作为选择终止点
};

@interface ZKMapNavController ()<AMapNaviViewControllerDelegate,CLLocationManagerDelegate,AMapSearchDelegate,UITextViewDelegate,UIGestureRecognizerDelegate,ZKmyCityArrayViewDelegate>
{
    //经度
    double Klongitude;
    //纬度
    double Klatitude;
    
    NSString *onsetAdder;
    
    //经度
    double Wlongitude;
    //纬度
    double Wlatitude;
    
    NSString *finishAdder;
    
    /**
     *  保存初始的位置信息
     */
    double fixationLon;
    
    double fixationLan;
    
    NSString *fixationAdd;
    
    
    ZKPlaceholderTextView *qidianField;
    
    ZKPlaceholderTextView *zhongdianField;
    
    float  zoomF;
    
    UIView *zoomView;
    
    AMapSearchAPI *_search;
//    AMapNavigationSearchRequest *naviRequest;
    AMapBusStopSearchRequest *stopRequest;
    AMapGeocodeSearchRequest *addQuest;
    
    /**
     *  是否转换了路线
     */
    BOOL isLuxian;
    
    MapSelectPointState _selectPointState;
    
    
    UITapGestureRecognizer *_mapViewTapGesture;
    
    NSString *myCity;
    
    NSString *zhongCity;
    
    NSMutableArray *busArray;
    
    NSArray *_pathPolylines;
    
    
    UIButton *bty_0; //导航标记
    
    
    UIButton * locanButton;
    
    BOOL isLocan;
    
    NSString *currentcity;//当前城市
    
    
}


/* 用于显示当前路线方案. */
@property (nonatomic) MANaviRoute * naviRoute;

@property (nonatomic, strong) AMapNaviPoint* startPoint;
@property (nonatomic, strong) AMapNaviPoint* endPoint;

@property (nonatomic, strong) NSArray *annotations;

@property (nonatomic, strong) MAPolyline *polyline;

@property (nonatomic) BOOL calRouteSuccess; // 指示是否算路成功

//@property (nonatomic) NavigationTypes naviType;
@property (nonatomic) TravelTypes travelType;
@property (nonatomic, strong) NavPointAnnotation *beginAnnotation;

@property (nonatomic, strong) NavPointAnnotation *endAnnotation;

@property (nonatomic) isBianji isbianji;

@property (nonatomic) busAdder isBus;

@property (nonatomic ,strong) UIView *navigationBarView;
@property (nonatomic ,strong) UIButton *leftBarButtonItem;
@property (nonatomic ,strong) UIButton *rightBarButtonItem;
@property (nonatomic ,strong) UIButton *motoring;
@property (nonatomic ,strong) UIButton *walk;
@property (nonatomic ,strong) UIButton *zoomButton;

@end

@implementation ZKMapNavController


#pragma mark - Life Cycle



-(id)initKLat:(double)Klat KLon:(double)Klon Kadder:(NSString*)kadder WLat:(double)Wlat WLon:(double)Wlon WAdder:(NSString*)wadder code:(NSString*)city;
{
    
    self = [super init];
    if (self)
    {
        
        fixationAdd =kadder;
        
        fixationLan =Klat;
        
        fixationLon =Klon;
        
        Klongitude =Klon;
        
        Klatitude =Klat;
        
        onsetAdder =kadder;
        
        Wlongitude =Wlon;
        
        Wlatitude =Wlat;
        
        finishAdder =wadder;
        
        zoomF =10;
        
        myCity =city;
        
        self.hidesBottomBarWhenPushed =YES;
        // 初始化travel方式为驾车方式
        
        
        self.travelType = TravelTypeCar;
    }
    return self;
    
    
}


-(void)viewWillDisappear:(BOOL)animated
{
    [self.iFlySpeechSynthesizer stopSpeaking];
    self.iFlySpeechSynthesizer.delegate =nil;
    self.iFlySpeechSynthesizer =nil;
    
}
- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    [[BaiduMobStat defaultStat] logEvent:@"btn_go_navi" eventLabel:@"导航"];
    
    self.isbianji =bianjiOne;
    _isBus =busOne;
    zhongCity =finishAdder;
    busArray =[[NSMutableArray alloc]initWithCapacity:0];
    
    currentcity =[ZKUtil ToTakeTheKey:@"myCity"];
    //公交路线查询
    _search = [[AMapSearchAPI alloc] initWithSearchKey:gaodeKEY Delegate:self];
    //公交查询
    stopRequest = [[AMapBusStopSearchRequest alloc] init];
    
    
    if (Wlatitude ==0||Wlongitude==0) {
        
        /**
         *  发起公交站查询
         */
        
        addQuest =[[AMapGeocodeSearchRequest alloc]init];
        addQuest.address =finishAdder;
        addQuest.city =@[myCity];
        self.isBus =bianThree;
        [_search AMapGeocodeSearch:addQuest];
        
    }else{
        
        [self initNaviPoints];
        
        [self routeCal];
        
    }
    
    
    [self configSubViews];
    
    [self configMapView];
    
    
    
    [self initGestureRecognizer];
    
    
    
}



- (void)configSubViews
{
    
    
    self.navigationBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width,64)];
    self.navigationBarView.backgroundColor = CYBColorGreen;
    [self.view addSubview:self.navigationBarView];
    
    self.leftBarButtonItem = [[UIButton alloc]initWithFrame:CGRectMake(2, 16, 50, 50)];
    [self.leftBarButtonItem setImage:[UIImage imageNamed:@"backimage_white"] forState:UIControlStateNormal];
    self.leftBarButtonItem.backgroundColor =[UIColor clearColor];
    [self.leftBarButtonItem addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    
    self.rightBarButtonItem =[[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width-2-60,16,50,50)];
    self.rightBarButtonItem.backgroundColor =[UIColor clearColor];
    [self.rightBarButtonItem setImage:[UIImage imageNamed:@"hunt"] forState:UIControlStateNormal];
    
    [self.rightBarButtonItem addTarget:self action:@selector(shousuo) forControlEvents:UIControlEventTouchUpInside];
    //    NSLayoutConstraint
    [self.navigationBarView  addSubview:self.rightBarButtonItem];
    [self.navigationBarView  addSubview:self.leftBarButtonItem];
    
    UISegmentedControl *segCtrl = [[UISegmentedControl alloc] initWithItems:@[@"",@"",@""]];
    
    segCtrl.tintColor = [UIColor whiteColor];
    [segCtrl setBounds:CGRectMake (0 ,0 ,130 ,33)];
    [segCtrl addTarget:self action:@selector(segCtrlClick:) forControlEvents:UIControlEventValueChanged];
    [segCtrl setTitleTextAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:17]}
                           forState:UIControlStateNormal];
    
    segCtrl.left                 = (self.view.width - 130) / 2;
    segCtrl.top                  = 22;
    segCtrl.selectedSegmentIndex = 1;
    
    [segCtrl setImage:[UIImage imageNamed:@"bus_0"] forSegmentAtIndex:0];
    
    [segCtrl setImage:[UIImage imageNamed:@"che_0"] forSegmentAtIndex:1];
    [segCtrl setImage:[UIImage imageNamed:@"ren_0"] forSegmentAtIndex:2];
    
    [self.view addSubview:segCtrl];
    
    
    UIView *bannerView =[[UIView alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, 100)];
    bannerView.backgroundColor =[UIColor whiteColor];
    [self.view addSubview:bannerView];
    
    
    UIButton *zhuanghuanButton =[[UIButton alloc]initWithFrame:CGRectMake(5, 30, 40, 40)];
    [zhuanghuanButton setBackgroundImage:[UIImage imageNamed:@"zhuanghuan"] forState:UIControlStateNormal];
    [zhuanghuanButton addTarget:self action:@selector(zhuanghuan) forControlEvents:UIControlEventTouchUpInside];
    [bannerView addSubview:zhuanghuanButton];
    
    UILabel *lin_0 =[[UILabel alloc]initWithFrame:CGRectMake(50, 50, bannerView.frame.size.width-50, 0.5)];
    lin_0.backgroundColor =TabelBackCorl;
    [bannerView addSubview:lin_0];
    
    
    qidianField =[[ZKPlaceholderTextView alloc]initWithFrame:CGRectMake(80, 5,bannerView.frame.size.width-140,40)];
    qidianField.backgroundColor =[UIColor clearColor];
    qidianField.textColor =[UIColor blackColor];
    //输入框中叉号编辑时出现
    
    qidianField.font =[UIFont systemFontOfSize:14];
    qidianField.placeholderFont =[UIFont systemFontOfSize:14];
    qidianField.textAlignment =NSTextAlignmentLeft;
    qidianField.keyboardType =UIKeyboardTypeDefault;
    qidianField.delegate =self;
    qidianField.tag =5000;
    qidianField.returnKeyType =UIReturnKeySearch;
    qidianField.text =onsetAdder;
    
    [bannerView addSubview:qidianField];
    
    
    zhongdianField =[[ZKPlaceholderTextView alloc]initWithFrame:CGRectMake(80,50,  bannerView.frame.size.width-140,40)];
    zhongdianField.backgroundColor =[UIColor clearColor];
    zhongdianField.textColor =[UIColor blackColor];
    //输入框中叉号编辑时出现
    
    zhongdianField.font =[UIFont systemFontOfSize:14];
    zhongdianField.placeholderFont =[UIFont systemFontOfSize:14];
    zhongdianField.textAlignment =NSTextAlignmentLeft;
    zhongdianField.keyboardType =UIKeyboardTypeDefault;
    zhongdianField.delegate =self;
    zhongdianField.tag =5001;
    zhongdianField.text =finishAdder;
    zhongdianField.returnKeyType =UIReturnKeySearch;
    [bannerView addSubview:zhongdianField];
    
    
    
    
    bty_0 =[[UIButton alloc]initWithFrame:CGRectMake(self.mapView.frame.size.width-55, 20+55*0+164,45, 45)];
    bty_0.backgroundColor =[UIColor colorWithWhite:0 alpha:0.4];
    bty_0.layer.cornerRadius =4;
    bty_0.tag =0+3000;
    [bty_0 addTarget:self action:@selector(mapFunction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bty_0];
    
    UIButton *bty_1 =[[UIButton alloc]initWithFrame:CGRectMake(self.mapView.frame.size.width-55, 20+55*1+164,45, 45)];
    bty_1.backgroundColor =[UIColor colorWithWhite:0 alpha:0.4];
    bty_1.layer.cornerRadius =4;
    bty_1.tag =1+3000;
    [bty_1 addTarget:self action:@selector(mapFunction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bty_1];
    
    
    for (int i=0; i<2; i++) {
        
        
        UIImageView *biaojiImage =[[UIImageView alloc]initWithFrame:CGRectMake(60, 22+40*i, 16, 16)];
        biaojiImage.image =[UIImage imageNamed:[NSString stringWithFormat:@"daohang_%d",i]];
        [bannerView addSubview:biaojiImage];
        
        UILabel *lin_1 =[[UILabel alloc]initWithFrame:CGRectMake(bannerView.frame.size.width-50, 10+50*i, 0.5, 30)];
        lin_1.backgroundColor =TabelBackCorl;
        [bannerView addSubview:lin_1];
        
        
        UIButton *sectUIbutton =[[UIButton alloc]initWithFrame:CGRectMake(bannerView.frame.size.width-50, 50*i, 50, 50)];
        [sectUIbutton setImage:[UIImage imageNamed:@"dibaio"] forState:UIControlStateNormal];
        sectUIbutton.tag =7000+i;
        [sectUIbutton addTarget:self action:@selector(search:) forControlEvents:UIControlEventTouchUpInside];
        [bannerView addSubview:sectUIbutton];
        
        
        _zoomButton =[[UIButton alloc]initWithFrame:CGRectMake(self.mapView.frame.size.width-50, self.view.frame.size.height-100+(40*i), 40, 40)];
        [_zoomButton setImage:[UIImage imageNamed:[NSString stringWithFormat:@"sx_%d",i]] forState:UIControlStateNormal];
        _zoomButton.tag =2000+i;
        _zoomButton.backgroundColor =[UIColor whiteColor];
        _zoomButton.layer.opacity =0.7;
        _zoomButton.layer.borderColor =[UIColor grayColor].CGColor;
        _zoomButton.layer.borderWidth =0.5;
        [_zoomButton addTarget:self action:@selector(zoomClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_zoomButton];
        
        
        
        UIImageView *popImage =[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 18, 18)];
        popImage.backgroundColor =[UIColor clearColor];
        popImage.image =[UIImage imageNamed:[NSString stringWithFormat:@"bangzhu_%d",i]];
        popImage.center =CGPointMake(45/2, 45/3-2);
        
        
        
        UILabel *nameLabel =[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 40, 20)];
        nameLabel.backgroundColor =[UIColor clearColor];
        
        
        nameLabel.center =CGPointMake(45/2, 45/3*2+2);
        nameLabel.textColor =[UIColor whiteColor];
        nameLabel.font =[UIFont systemFontOfSize:13];
        nameLabel.textAlignment =NSTextAlignmentCenter;
        
        if (i ==0) {
            
            nameLabel.text =@"导航";
            [bty_0 addSubview:nameLabel];
            [bty_0 addSubview:popImage];
            
        }else{
            
            nameLabel.text =@"帮助";
            [bty_1 addSubview:nameLabel];
            [bty_1 addSubview:popImage];
            
        }
        
    }
    
    locanButton =[[UIButton alloc]initWithFrame:CGRectMake(15, self.view.frame.size.height-65, 40, 40)];
    locanButton.backgroundColor =[UIColor clearColor];
    [locanButton setImage:[UIImage imageNamed:@"map_location_icon"] forState:UIControlStateNormal];
    [locanButton setImage:[UIImage imageNamed:@"map_location_icon_select"] forState:UIControlStateHighlighted];
    
    [locanButton addTarget:self action:@selector(locanClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:locanButton];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged) name: UITextViewTextDidChangeNotification object:nil];
    
    
    
}

/**
 *  <#Description#>
 */
- (void)configMapView
{
    
    [self.mapView setDelegate:self];
    
    self.mapView.showsScale =NO;
    self.mapView.showsCompass =NO;
    
    float  mapjianju = kSetingViewHeight+100;
    [self.mapView setFrame:CGRectMake(0, mapjianju,
                                      self.view.bounds.size.width,
                                      self.view.bounds.size.height-mapjianju)];
    [self.view insertSubview:self.mapView atIndex:0];
    
    
    
    if (_calRouteSuccess)
    {
        [self.mapView addOverlay:_polyline];
    }
    
    if (self.annotations.count > 0)
    {
        [self.mapView addAnnotations:self.annotations];
        [self.mapView showAnnotations:self.annotations animated:YES];
    }
    
    
    
    
}


- (void)initGestureRecognizer
{
    _mapViewTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                 action:@selector(handleSingleTap:)];
    
    [self.mapView addGestureRecognizer:_mapViewTapGesture];
}

#pragma mark - Gesture Action

- (void)handleSingleTap:(UITapGestureRecognizer *)theSingleTap
{
    
    
    
    [zhongdianField resignFirstResponder];
    [qidianField resignFirstResponder];
    
    if ( _selectPointState ==MapSelectPointStateNone) {
        
        return;
        
    }
    
    CLLocationCoordinate2D coordinate = [self.mapView convertPoint:[theSingleTap locationInView:self.mapView]
                                              toCoordinateFromView:self.mapView];
    
    
    
    
    if (_selectPointState == MapSelectPointStateStartPoint)
        
    {
        
        isLocan =NO;
        
        Klatitude =coordinate.latitude;
        Klongitude =coordinate.longitude;
        
        
        [self.mapView removeAnnotation:_beginAnnotation];
        _beginAnnotation = [[NavPointAnnotation alloc] init];
        [_beginAnnotation setCoordinate:coordinate];
        _beginAnnotation.title        = @"起始点";
        
        
        if (isLuxian ==NO) {
            
            _beginAnnotation.navPointType = NavPointAnnotationStart;
            
            
        }else{
            
            _beginAnnotation.navPointType = NavPointAnnotationEnd;
            
        }
        
        
        
        [self.mapView addAnnotation:_beginAnnotation];
        
        
        
    }
    
    else if (_selectPointState == MapSelectPointStateEndPoint)
    {
        
        Wlatitude =coordinate.latitude;
        Wlongitude =coordinate.longitude;
        
        
        [self.mapView removeAnnotation:_endAnnotation];
        
        _endAnnotation = [[NavPointAnnotation alloc] init];
        [_endAnnotation setCoordinate:coordinate];
        _endAnnotation.title        = @"终 点";
        
        if (isLuxian ==NO) {
            
            _endAnnotation.navPointType = NavPointAnnotationEnd;
            
        }else{
            
            _endAnnotation.navPointType = NavPointAnnotationStart;
            
        }
        
        
        [self.mapView addAnnotation:_endAnnotation];
        
        
        
    }
    
#pragma mark 逆地理
    _search.language = AMapSearchLanguage_zh_CN;
    //构造AMapReGeocodeSearchRequest对象，location为必选项，radius为可选项
    AMapReGeocodeSearchRequest *regeoRequest = [[AMapReGeocodeSearchRequest alloc] init];
    regeoRequest.searchType = AMapSearchType_ReGeocode;
    regeoRequest.location = [AMapGeoPoint locationWithLatitude:coordinate.latitude longitude:coordinate.longitude];
    regeoRequest.radius = 1000;
    regeoRequest.requireExtension = YES;
    //发起逆地理编码
    [_search AMapReGoecodeSearch: regeoRequest];
    
    
}

#pragma mark  实现地理编码的回调函数

//实现正向地理编码的回调函数

- (void)onGeocodeSearchDone:(AMapGeocodeSearchRequest *)request response:(AMapGeocodeSearchResponse *)response;
{
    
    
    
    if (response.count ==0) {
        
        [self.view makeToast:@"未搜索到位置信息！"];
    }else{
        
        AMapGeocode *am =response.geocodes[0];
        
        if ( self.isBus == busTwo) {
            
            Klongitude = am.location.longitude;
            Klatitude = am.location.latitude;
        }else{
        
            Wlongitude = am.location.longitude;
            Wlatitude = am.location.latitude;
        }
       
        
       
         [self shousuo];
        
    }
    
    
    
    
    
}


- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response
{
    NSString *titles;
    
    
    if(response.regeocode != nil)
    {
        //通过AMapReGeocodeSearchResponse对象处理搜索结果
        titles = response.regeocode.addressComponent.city;
        if (titles.length == 0)
        {
            // 直辖市的city为空，取province
            titles = response.regeocode.addressComponent.province;
        }
        
        // NSLog(@"ReGeo: %@  %@", titles,response.regeocode.addressComponent);
    }
    NSString *_dis;
    
    _dis =[NSString stringWithFormat:@"%@%@%@%@%@",titles,response.regeocode.addressComponent.district,response.regeocode.addressComponent.township,response.regeocode.addressComponent.neighborhood,response.regeocode.addressComponent.streetNumber.street];
    
    
    if (_selectPointState ==MapSelectPointStateStartPoint) {
        
        qidianField.text =_dis;
        onsetAdder =_dis;
        [qidianField dism];
        
        
        if (_travelType ==TravelTBus) {
            
            myCity =_dis;
            currentcity =titles;
            stopRequest.keywords =_dis;
            stopRequest.city =@[currentcity];
            self.isBus =busTwo;
            //发起公交站查询
            [_search AMapBusStopSearch: stopRequest];
            
        }
        
        
    }else if (_selectPointState ==MapSelectPointStateEndPoint){
        
        zhongCity = _dis;
        zhongdianField.text =_dis;
        [zhongdianField dism];
        
        if (_travelType ==TravelTBus) {
            
            
            stopRequest.keywords =_dis;
            stopRequest.city =@[titles];
            self.isBus =busTwo;
            //发起公交站查询
            [_search AMapBusStopSearch: stopRequest];
            
            
        }
        
        
    }
    
    [self shousuo];
    
    
}



- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    
    return YES;
}



#pragma mark - Construct and Inits

- (void)initNaviPoints
{
    
    if (isLuxian ==NO) {
        
        _startPoint = [AMapNaviPoint locationWithLatitude:Klatitude longitude:Klongitude];
        _endPoint   = [AMapNaviPoint locationWithLatitude:Wlatitude longitude:Wlongitude];
    }else{
        
        
        _startPoint = [AMapNaviPoint locationWithLatitude:Wlatitude longitude:Wlongitude];
        _endPoint   = [AMapNaviPoint locationWithLatitude:Klatitude longitude:Klongitude];
        
    }
    
    
    [self initAnnotations];
}


- (void)initAnnotations
{
    _beginAnnotation = [[NavPointAnnotation alloc] init];
    
    [_beginAnnotation setCoordinate:CLLocationCoordinate2DMake(_startPoint.latitude, _startPoint.longitude)];
    _beginAnnotation.title        = @"起始点";
    _beginAnnotation.navPointType = NavPointAnnotationStart;
    
    _endAnnotation = [[NavPointAnnotation alloc] init];
    
    [_endAnnotation setCoordinate:CLLocationCoordinate2DMake(_endPoint.latitude, _endPoint.longitude)];
    
    _endAnnotation.title        = @"终点";
    _endAnnotation.navPointType = NavPointAnnotationEnd;
    
    self.annotations = @[_beginAnnotation, _endAnnotation];
    //[self.mapView showAnnotations:self.annotations animated:YES];
    
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

#pragma mark  路径规划
- (void)routeCal
{
    NSArray *startPoints;
    NSArray *endPoints;
    
    startPoints = @[_startPoint];
    endPoints   = @[_endPoint];
    
    
    if (self.travelType == TravelTypeCar)
    {
        [self.naviManager calculateDriveRouteWithStartPoints:startPoints endPoints:endPoints wayPoints:nil drivingStrategy:0];
        
    }else if (self.travelType ==TravelTypeWalk)
    {
        
        
        [self.naviManager calculateWalkRouteWithStartPoints:startPoints endPoints:endPoints];
        
    }else if (self.travelType ==TravelTBus){
        
        if ( _search == nil)
        {
            [[APPDELEGATE window] makeToast:@"信息不足"];
            return;
        }
        
        
        
        AMapNavigationSearchRequest *navi = [[AMapNavigationSearchRequest alloc] init];
        navi.searchType       = AMapSearchType_NaviBus;
        navi.requireExtension = YES;
        navi.city             = currentcity;
        
        /* 出发点. */
        navi.origin = [AMapGeoPoint locationWithLatitude:Klatitude
                                               longitude:Klongitude];
        /* 目的地. */
        navi.destination = [AMapGeoPoint locationWithLatitude:Wlatitude
                                                    longitude:Wlongitude];
        
        [_search AMapNavigationSearch:navi];
        
        
        
        
    }
    
    
}

#pragma mark 点击事件
/**
 *  自身定位
 */
-(void)locanClick
{
    /**
     *  起点就是自己
     */
    if (isLocan ==YES) {
        
        CLLocationCoordinate2D pc;
        pc.latitude =Klatitude;
        pc.longitude =Klongitude;
        
        [self.mapView setCenterCoordinate:pc];
        
        
        
    }else{
        
        /**
         *  起点不是自己
         */
        
        isLocan =YES;
        [[APPDELEGATE window] makeToast:@"起点为自身位置"];
        CLLocationCoordinate2D coordinate;
        coordinate.latitude =fixationLan;
        coordinate.longitude =fixationLon;
        qidianField.text =fixationAdd;
        //        myCity =fixationAdd;
        [qidianField dism];
        Klatitude =fixationLan;
        Klongitude =fixationLon;
        
        _selectPointState = MapSelectPointStateStartPoint;
        
        if (_beginAnnotation)
        {
            _beginAnnotation.coordinate = coordinate;
        }
        else
        {
            _beginAnnotation = [[NavPointAnnotation alloc] init];
            [_beginAnnotation setCoordinate:coordinate];
            _beginAnnotation.title        = @"起始点";
            _beginAnnotation.navPointType = NavPointAnnotationStart;
            [self.mapView addAnnotation:_beginAnnotation];
        }
        
        
        /**
         *  规划路线
         */
        [self.mapView removeOverlay:_polyline];
        [self.mapView removeAnnotations:self.mapView.annotations];
        
        [self initNaviPoints];
        
        [self   routeCal];
        
        if (self.annotations.count > 0)
        {
            [self.mapView addAnnotations:self.annotations];
        }
        
        _selectPointState =MapSelectPointStateNone;
        
    }
    
}
-(void)zhuanghuan
{
    
    NSString *po =qidianField.text;
    NSString *pt =zhongdianField.text;
    
    qidianField.text =pt;
    zhongdianField.text =po;
    
    //    NSLog(@"   0000  %hhd",isLuxian);
    
    
    isLuxian =!isLuxian;
    
    //    NSLog(@"   1111  %hhd",isLuxian);
    
    
    
    [self.mapView removeAnnotations:self.mapView.annotations];
    
    
    [self initNaviPoints ];
    
    [self configMapView];
    [self routeCal];
    
    
}


#pragma mark 搜素
-(void)shousuo
{
    
    [qidianField setText:onsetAdder];
    
    [zhongdianField setText:zhongCity];
    
    [qidianField dism];
    [zhongdianField dism];
    
    [self.mapView removeOverlay:_polyline];
    [self.mapView removeAnnotations:self.mapView.annotations];
    
    [self initNaviPoints ];
    
    [self   routeCal];
    
    if (self.annotations.count > 0)
    {
        [self.mapView addAnnotations:self.annotations];
    }
    
    _selectPointState =MapSelectPointStateNone;
    
    
}
- (void)mapFunction:(UIButton*)sender
{
    
    if (sender.tag ==3000) {
        
        [self gpsNavi];
        
    }else{
        
        ZKExplainView *expView =[[ZKExplainView alloc]initTs:@"线路查询说明 :" MarkedWords:@"1、文字查询、公交查询仅支持同城操作;\n2、若要跨市查询请在地图点选起点及目的地;"];
        [expView show];
        
    }
}
#pragma mark  点击定位按钮
- (void)search:(UIButton*)sender
{
    
    
    
    if (sender.tag ==7000) {
        
        
        [self.view makeToast:@"请在地图上选择起点位置..."];
        if (isLuxian ==NO) {
            
            _selectPointState =MapSelectPointStateStartPoint;
            
            
            
        }else{
            
            _selectPointState =MapSelectPointStateEndPoint;
        }
        
        
    }else{
        
        [self.view makeToast:@"请在地图上选择终点位置..."];
        if (isLuxian ==NO) {
            
            _selectPointState =MapSelectPointStateEndPoint;
        }else{
            
            _selectPointState =MapSelectPointStateStartPoint;
        }
        
        
    }
    
    
}


#pragma mark 导航



- (void)gpsNavi
{
    if (_calRouteSuccess)
    {
        
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

#pragma mark - AMapNaviManager Delegate


- (void)naviManager:(AMapNaviManager *)naviManager error:(NSError *)error
{
    
    
}


- (void)naviManagerOnCalculateRouteSuccess:(AMapNaviManager *)naviManager
{
    //    [super AMapNaviManagerOnCalculateRouteSuccess:naviManager];
    
    
    [self showRouteWithNaviRoute:[[naviManager naviRoute] copy]];
    
    _calRouteSuccess = YES;
}


- (void)naviManager:(AMapNaviManager *)naviManager didPresentNaviViewController:(UIViewController *)naviViewController
{
    
    
    [self initIFlySpeech];
    
    
    [self.naviManager startGPSNavi];
    
    
}


#pragma mark - AManNaviViewController Delegate

/*!
 @brief 导航界面关闭按钮点击时的回调函数
 */

- (void)AMapNaviViewControllerCloseButtonClicked:(AMapNaviViewController *)naviViewController
{
    
    
    [self.iFlySpeechSynthesizer stopSpeaking];
    
    self.iFlySpeechSynthesizer.delegate = nil;
    self.iFlySpeechSynthesizer          = nil;
    
    [self.naviManager stopNavi];
    
    
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
            //[pointAnnotationView setPinColor:MAPinAnnotationColorGreen];
            
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
    
    if (self.travelType !=TravelTBus) {
        
        [self.mapView removeOverlays:self.mapView.overlays];
        [self.naviRoute removeFromMapView];
        
    }
    
    
    if ([overlay isKindOfClass:[MAPolyline class]])
    {
        MAPolylineView *polylineView = [[MAPolylineView alloc] initWithPolyline:(MAPolyline*)overlay];
        polylineView.lineWidth    = 8.f;
        [polylineView loadStrokeTextureImage:[UIImage imageNamed:@"arrowTexture"]];
        
        return polylineView;
    }
    
    if ([overlay isKindOfClass:[MANaviPolyline class]])
    {
        MANaviPolyline *naviPolyline = (MANaviPolyline *)overlay;
        MAPolylineView *polylineView = [[MAPolylineView alloc] initWithPolyline:naviPolyline.polyline];
        
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
    
    TravelTypes travelType = segCtrl.selectedSegmentIndex;
    
    if ( travelType ==TravelTBus) {
        
        bty_0.layer.opacity =0;
        
        
    }else{
        
        bty_0.layer.opacity =1;
    }
    
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

#pragma mark bus 搜索路线
/**
 *  错误回调
 */
- (void)searchRequest:(id)request didFailWithError:(NSError *)error;
{
    
    [[APPDELEGATE window] makeToast:@"路径规划失败"];
    
    
}
//实现公交站查询的回调函数
-(void)onBusStopSearchDone:(AMapBusStopSearchRequest*)request response:(AMapBusStopSearchResponse *)response
{
    
    
    if(response.busstops.count == 0)
    {
        
        return;
    }
    
    //通过AMapBusStopSearchResponse对象处理搜索结果
    NSString *strStop = @"";
    for (AMapBusStop *p in response.busstops) {
        strStop = [NSString stringWithFormat:@"\nStop: %@", p.location];
        NSString *la =[NSString stringWithFormat:@"%f",p.location.latitude];
        NSString *lo =[NSString stringWithFormat:@"%f",p.location.longitude];
        NSArray *cp =@[p.name,la,lo];
        [busArray addObject:cp];
    }
    
    ZKmyCityArrayView *busView =[[ZKmyCityArrayView alloc]initNames:busArray sect:0 reminder:@"选择公交站点" tp:0];
    busView.delegate =self;
    [busView show];
    
}



- (CLLocationCoordinate2D *)coordinatesForString:(NSString *)string
                                 coordinateCount:(NSUInteger *)coordinateCount
                                      parseToken:(NSString *)token
{
    if (string == nil)
    {
        return NULL;
    }
    
    if (token == nil)
    {
        token = @",";
    }
    
    NSString *str = @"";
    if (![token isEqualToString:@","])
    {
        str = [string stringByReplacingOccurrencesOfString:token withString:@","];
    }
    
    else
    {
        str = [NSString stringWithString:string];
    }
    
    NSArray *components = [str componentsSeparatedByString:@","];
    NSUInteger count = [components count] / 2;
    if (coordinateCount != NULL)
    {
        *coordinateCount = count;
    }
    CLLocationCoordinate2D *coordinates = (CLLocationCoordinate2D*)malloc(count * sizeof(CLLocationCoordinate2D));
    
    for (int i = 0; i < count; i++)
    {
        coordinates[i].longitude = [[components objectAtIndex:2 * i]     doubleValue];
        coordinates[i].latitude  = [[components objectAtIndex:2 * i + 1] doubleValue];
    }
    
    
    return coordinates;
}


/**
 *  解析公交路线
 *
 *  @param path 方案
 *
 *  @return poly
 */
- (NSArray *)polylinesForPath:(AMapTransit*)path
{
    if (path == nil || path.segments.count == 0)
    {
        return nil;
    }
    
    
    NSMutableArray *polylines = [NSMutableArray array];
    
    
    
    for (int i=0; i<path.segments.count; i++) {
        
        AMapSegment *seg =path.segments[i];
        AMapWalking *king =seg.walking;
        
        [king.steps enumerateObjectsUsingBlock:^(AMapStep *step, NSUInteger idx, BOOL *stop) {
            
            NSUInteger count = 0;
            CLLocationCoordinate2D *coordinates = [self coordinatesForString:step.polyline
                                                             coordinateCount:&count
                                                                  parseToken:@";"];
            
            MAPolyline *polyline = [MAPolyline polylineWithCoordinates:coordinates count:count];
            [polylines addObject:polyline];
            
            free(coordinates), coordinates = NULL;
        }];
        
        
    }
    
    return polylines;
    
}


//实现路径搜索的回调函数
/* 导航搜索回调. */
- (void)onNavigationSearchDone:(AMapNavigationSearchRequest *)request
                      response:(AMapNavigationSearchResponse *)response
{
    
    
    if (response.count > 0)
    {
        [self.mapView removeOverlays:_pathPolylines];
        
        [self.mapView removeOverlays:self.mapView.overlays];
        [self.naviRoute removeFromMapView];
        
        _pathPolylines = nil;
        
        self.naviRoute= [MANaviRoute naviRouteForTransit:response.route.transits[0]];
        
        [self.naviRoute addToMapView:self.mapView];
        
        [self.mapView showAnnotations:self.annotations animated:YES];
        
        
    }else{
        
        
        [[APPDELEGATE window] makeToast:@"查询不到公交路线"];
    }
    
    
    
    
    
}

#pragma mark  bus  data
-(void)Cityconfirm:(NSInteger)sect tp:(NSInteger)k;
{
    
    
    NSArray *loc =[busArray objectAtIndex:sect];
    
    if ( _isBus ==busTwo ) {
        
        Klatitude =[[loc objectAtIndex:1] doubleValue];
        Klongitude =[[loc objectAtIndex:2] doubleValue];
        qidianField.text =[loc objectAtIndex:0];
        
        
        
    }else if (_isBus ==busThree){
        
        Wlatitude =[[loc objectAtIndex:1] doubleValue];
        Wlongitude =[[loc objectAtIndex:2] doubleValue];
        zhongdianField.text =[loc objectAtIndex:0];
        
        
    }
    
    [self initNaviPoints];
    
}
#pragma mark textfild

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text;
{
    
    
    
    
    if (textView.tag ==5000) {
        onsetAdder = qidianField.text;
        stopRequest.keywords =qidianField.text;
        stopRequest.city = @[currentcity];
        self.isBus =busTwo;
        NSLog(@"——————222");
        
        
    }else if (textView.tag ==5001){
        zhongCity = zhongdianField.text;
        stopRequest.keywords =zhongdianField.text;
        self.isBus =busThree;
        stopRequest.city =@[zhongCity];
        NSLog(@"——————333");
        
        
    }

    if ([text isEqualToString:@"\n"]) {
        
        if (self.travelType ==TravelTypeCar||self.travelType==TravelTypeWalk) {
            
            //构造AMapGeocodeSearchRequest对象，address为必选项，city为可选项
            AMapGeocodeSearchRequest *geo = [[AMapGeocodeSearchRequest alloc] init];
            geo.address = textView.text;
            //发起正向地理编码
            [_search AMapGeocodeSearch: geo];

            
            
        }else if (self.travelType ==TravelTBus){

            //发起公交站查询
            [_search AMapBusStopSearch: stopRequest];
            
        }
        
        [textView resignFirstResponder];
        
        return NO;
    }
    return YES;
}

-(void)textChanged
{
    
    
    if (qidianField) {
        
        self.isbianji =bianjiTwo;
        if ([qidianField.text length] ==0) {
            
            qidianField.placeholder =@"请输入起点！";
            
        }
        
    }
    
    if (zhongdianField){
        
        
        self.isbianji =bianThree;
        if ([zhongdianField.text length] ==0) {
            
            zhongdianField.placeholder =@"请输入终点！";
            
        }
        
    }
    
}
-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}


@end
