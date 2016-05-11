//
//  ViewController.m
//  HelloAmap
//
//  Created by xiaoming han on 14-10-21.
//  Copyright (c) 2014年 AutoNavi. All rights reserved.
//

#import "ZKMapViewController.h"
#import <AMapNaviKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchAPI.h>
#import "ZKUtil.h"
#import "ZKMoreReminderView.h"



//#import "ZKParticularData.h"
#define kDefaultLocationZoomLevel       16.1
#define kDefaultControlMargin           22
#define kDefaultCalloutViewMargin       -8

@interface ZKMapViewController ()<MAMapViewDelegate, UIGestureRecognizerDelegate,AMapSearchDelegate>
{
    MAMapView *_mapView;
    CLLocation *_currentLocation;

    UITapGestureRecognizer *_PressGesture;
    MAPointAnnotation *_destinationPoint;
    AMapSearchAPI *_search;
    
    UIButton *_zoomButton;
    
        float  zoomF;
    double lat;
    double lon;
    
    NSString *titles;
    
    UILabel *_addressLabel;
    
    NSString *_dis;
    
    BOOL isShowMOre;//是否第一次弹出
    
}
@end

@implementation ZKMapViewController


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.view makeToast:@"长按以选取新的位置" duration:1 position:nil];

}

-(void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];

    _mapView.showsUserLocation =NO;
    [_mapView removeAnnotation:_destinationPoint];
    [_mapView removeOverlays:_mapView.overlays];
    _mapView.delegate =nil;
    if (!strIsEmpty(_dis)) {
       
        if ([self.delegate respondsToSelector:@selector(site:Lon:Lat:)]) {
            [self.delegate site:_dis Lon:[NSString stringWithFormat:@"%f",lon] Lat:[NSString stringWithFormat:@"%f",lat]];
        }

    }
    
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    isShowMOre =YES;//是第一次弹出
    
    zoomF =10;
    [self initMapView];
    [self initAttributes];
    [self locateAction];
    
    NSString *latt = [ZKUtil ToTakeTheKey:@"Latitude"];
    NSString *lont = [ZKUtil ToTakeTheKey:@"Longitude"];
    
    if (latt) {
        
        CLLocationCoordinate2D  loc;
        loc.latitude = [latt doubleValue];
        loc.longitude = [lont doubleValue];
        lat = loc.latitude;
        lon = loc.longitude;
        [_mapView setCenterCoordinate:loc animated:YES];
       [self initsearch];
        
    }
       _mapView.showsUserLocation =YES;
    
 
    
}

-(void)initsearch
{

    //初始化检索对象

    _search.language = AMapSearchLanguage_zh_CN;
    //构造AMapReGeocodeSearchRequest对象，location为必选项，radius为可选项
    AMapReGeocodeSearchRequest *regeoRequest = [[AMapReGeocodeSearchRequest alloc] init];
    regeoRequest.searchType = AMapSearchType_ReGeocode;
    regeoRequest.location = [AMapGeoPoint locationWithLatitude:lat longitude:lon];
    regeoRequest.radius = 1000;
    regeoRequest.requireExtension = YES;
    //发起逆地理编码
    [_search AMapReGoecodeSearch: regeoRequest];

}
- (void)initMapView
{
    self.titeLabel.text =@"地址选择";
    
    _search = [[AMapSearchAPI alloc] initWithSearchKey:gaodeKEY Delegate:self];
    
    [MAMapServices sharedServices].apiKey = gaodeKEY;
    _mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, navigationHeghit, CGRectGetWidth(self.view.bounds), TabelHeghit)];
    _mapView.userInteractionEnabled =YES;
    _mapView.delegate = self;
    _mapView.compassOrigin = CGPointMake(_mapView.compassOrigin.x, kDefaultControlMargin);
    _mapView.scaleOrigin = CGPointMake(_mapView.scaleOrigin.x, kDefaultControlMargin);
    
    [self.view addSubview:_mapView];
    
    _mapView.showsUserLocation = YES;
    
    
    
    for (int i=0; i<2; i++) {
        _zoomButton =[[UIButton alloc]initWithFrame:CGRectMake(_mapView.frame.size.width-50, self.view.frame.size.height-120+(40*i), 40, 40)];
        [_zoomButton setImage:[UIImage imageNamed:[NSString stringWithFormat:@"sx_%d",i]] forState:UIControlStateNormal];
        _zoomButton.tag =2000+i;
        _zoomButton.backgroundColor =[UIColor whiteColor];
        _zoomButton.layer.opacity =0.7;
        _zoomButton.layer.borderColor =[UIColor grayColor].CGColor;
        _zoomButton.layer.borderWidth =0.5;
        [_zoomButton addTarget:self action:@selector(zoomClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_zoomButton];
    }
    
    
    _addressLabel =[[UILabel alloc]initWithFrame:CGRectMake(_mapView.frame.size.width/2-100, 25, 200, 60)];
    _addressLabel.textColor =CYBColorGreen;
    _addressLabel.textAlignment =NSTextAlignmentCenter;
    _addressLabel.numberOfLines =3;
    _addressLabel.font =[UIFont systemFontOfSize:16];
    _addressLabel.backgroundColor =[UIColor clearColor];
    [_mapView addSubview:_addressLabel];
    
    
}


#pragma mark - Button Actions

-(void)zoomClick:(UIButton*)sender
{
    
    
    if (sender.tag ==2000) {
        
        zoomF =zoomF+1.5;
        
    }else{
        
        zoomF =zoomF-1.5;
    }
    
    [_mapView setZoomLevel:zoomF animated:YES];
}


//添加手势
- (void)initAttributes
{
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(pick:)];//添加手势
    longPress.delegate =self;
    [_mapView  addGestureRecognizer:longPress];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//定位
- (void)locateAction
{
    if (_mapView.userTrackingMode != MAUserTrackingModeFollow)
    {
        _mapView.userTrackingMode = MAUserTrackingModeFollow;
        [_mapView setZoomLevel:kDefaultLocationZoomLevel animated:YES];
    }
}

//实现逆地理编码的回调函数
- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response
{
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
    
    _dis =[NSString stringWithFormat:@"%@%@%@%@%@",titles,response.regeocode.addressComponent.district,response.regeocode.addressComponent.township,response.regeocode.addressComponent.neighborhood,response.regeocode.addressComponent.streetNumber.street];
    
   //会执行2次
    [self showMore:_dis];


}
-(void)showMore:(NSString*)str;
{
    if (isShowMOre ==YES) {
        
        isShowMOre =NO;
         _addressLabel.text =str;
        
        int64_t delayInSeconds = 0.9;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            
            ZKMoreReminderView *more =[[ZKMoreReminderView alloc]initTs:@" 是否选取当前地理位置..." MarkedWords:[NSString stringWithFormat:@"  地址:%@",str]];
            
            [more  sectec:^(int pgx) {
                
                isShowMOre =YES;
                
                if (pgx ==1) {
                    
                    [self.navigationController popViewControllerAnimated:YES];
                }
            }];
            [more show];

        });
        
        
    }


}

- (void)pick:(UILongPressGestureRecognizer *)gesture
{
   
    
    
    if (gesture.state == UIGestureRecognizerStateBegan)
    {
        CLLocationCoordinate2D coordinate = [_mapView convertPoint:[gesture locationInView:_mapView]
                                              toCoordinateFromView:_mapView];
        lon =coordinate.longitude;
        lat =coordinate.latitude;
        // 添加标注
        if (_destinationPoint != nil)
        {
            // 清理
            [_mapView removeAnnotation:_destinationPoint];
            _destinationPoint = nil;
            
        }
        
        _destinationPoint = [[MAPointAnnotation alloc] init];
        _destinationPoint.coordinate = coordinate;
      //  _destinationPoint.title = @"Destination";
        
        [_mapView addAnnotation:_destinationPoint];
    }
    
    [self initsearch];
    
    
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    
    return YES;
}

#pragma mark - MAMapViewDelegate

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    
    //    //
    if (annotation == _destinationPoint)
    {
        static NSString *reuseIndetifier = @"startAnnotationReuseIndetifier";
        MAPinAnnotationView *annotationView = (MAPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:reuseIndetifier];
        if (annotationView == nil)
        {
            annotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:reuseIndetifier];
        }
        
        annotationView.canShowCallout = YES;
        annotationView.animatesDrop = YES;
        
        return annotationView;
    }
    
    
    return nil;
}

@end
