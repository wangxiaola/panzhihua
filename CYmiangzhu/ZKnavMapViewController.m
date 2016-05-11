//
//  DQNavViewController.m
//  changyouyibin
//
//  Created by Daqsoft-Mac on 14/12/16.
//  Copyright (c) 2014年 WangXiaoLa. All rights reserved.
//

#import "ZKnavMapViewController.h"
#import "MapView.h"
#import "TestMapCell.h"
#import "CallOutAnnotationView.h"
#import "ZKAppDelegate.h"

#import "BasicMapAnnotation.h"
#import "ZKMapNavController.h"
#import "ZKguideInforView.h"
#import "ZKPickDateView.h"

#import "ZKMapNavController.h"

#import "ListMapData.h"
#import "MONActivityIndicatorView.h"
#import "ZKregisterViewController.h"
@interface ZKnavMapViewController ()<MapViewDelegate,CLLocationManagerDelegate,MONActivityIndicatorViewDelegate>
{
    
    
    NSMutableArray *_annotations;
    TestMapCell *cell;
    
    NSString *myAdder;
    
    
    double mylat;
    double mylon;
    
    
    MONActivityIndicatorView *indicatorView;
    
    UIButton *locationButton;
    
}


@property (nonatomic,strong)MapView *mapView;

@property (nonatomic,strong)NSArray <ListMapData*>*restsArray;

@property (nonatomic, strong) CLLocationManager *locationManager;


@end


@implementation ZKnavMapViewController

@synthesize restsArray = restsArray;

-(id)init;
{
    self =[super init];
    if (self) {
        
        self.hidesBottomBarWhenPushed =YES;
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self locan];
    
    
    [[BaiduMobStat defaultStat] logEvent:@"btn_go_near" eventLabel:@"跳转到附近页面 "];
    
    [self.leftBarButtonItem removeFromSuperview];
    
    restsArray =[NSMutableArray arrayWithCapacity:0];
    _annotations =[NSMutableArray arrayWithCapacity:0];
    
    self.titeLabel.text =@"找旅行社";
    UIButton *lefButton = [[UIButton alloc]initWithFrame:CGRectMake(2, 20, 40, 40)];
    [lefButton setImage:[UIImage imageNamed:@"backimage"] forState:UIControlStateNormal];
    lefButton.backgroundColor =[UIColor clearColor];
    [lefButton addTarget:self action:@selector(lefBack) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:lefButton];
    
    
    
    [self initMapView];
    
    indicatorView = [[MONActivityIndicatorView alloc] init];
    indicatorView.numberOfCircles = 4;
    indicatorView.delegate =self;
    indicatorView.radius = 10;
    indicatorView.internalSpacing = 5;
    indicatorView.center =self.view.center;
    [self.view addSubview:indicatorView];
    
    [self.mapView.mapView setZoomEnabled:YES];
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
    
    
    [_locationManager stopUpdatingLocation];
    
    //放大地图到自身的经纬度位置。
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(currLocation.coordinate, self.mapView.span , self.mapView.span);
    
    [self.mapView.mapView setRegion:region animated:YES];
    
    mylat =currLocation.coordinate.latitude;
    mylon =currLocation.coordinate.longitude;
    
    [self postSearch];
    
    CLLocation *c = [[CLLocation alloc] initWithLatitude:mylat longitude:mylon];
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
                               [dict objectForKey:@"Name"]);
                         
                         NSString *str =[dict objectForKey:@"Name"];
                         
                         str =[str stringByReplacingOccurrencesOfString:@"中国" withString:@""];
                         
                         myAdder =str;
                         NSLog(@"  == %@",str);
                         
                         
                         
                     }
                     else
                     {
                         
                         myAdder =@"地址未查到";
                         NSLog(@"ERROR: %@", error); }
                 }];
    
    
    
    
}

-(NSMutableDictionary*)dataList;

{
    
    NSMutableDictionary *dic =[NSMutableDictionary dictionary];
    
    [dic setObject:[NSString stringWithFormat:@"%f",mylon] forKey:@"lon"];
    [dic setObject:[NSString stringWithFormat:@"%f",mylat] forKey:@"lat"];
    [dic setObject:@"5" forKey:@"count"];
    [dic setObject:@"resoureNearbyLatLng" forKey:@"method"];
    
    return dic;
    
}




#pragma mark  搜索请求

-(void)postSearch;
{
    
    [indicatorView startAnimating];
    
    [ZKHttp Post:@"" params:[self dataList] success:^(id responseObj) {
        
        [indicatorView stopAnimating];
        NSLog(@"  附近---   %@",responseObj);
        
        
        NSMutableArray<ListMapData *> *dataArray = [ListMapData objectArrayWithKeyValuesArray:responseObj[@"rows"]];
        
        [ZKUtil dictionaryToJson:responseObj File:@"ZKnavMapViewController"];
        restsArray =dataArray;
        if (restsArray.count ==0) {
            
            [self.view makeToast:@"附近没找到旅行社!"];
        }else{
            
            [self  dataRefresh:restsArray selcet:2];
        }
        
        
    } failure:^(NSError *error) {
        
        [indicatorView stopAnimating];
        NSDictionary *dic =[ZKUtil  File:@"ZKnavMapViewController"];
        
        
        if (dic.count>0) {
            
            [self.view makeToast:@"当前为缓存数据!"];
            
            NSMutableArray<ListMapData *> *dataArray = [ListMapData objectArrayWithKeyValuesArray:dic[@"rows"]];
            
            restsArray =dataArray;
            
            [self  dataRefresh:restsArray selcet:2];
            
            
        }else{
            
            [self.view makeToast:@"亲！没有缓存可取。"];
            
        }
        
        
    }];
    
    
}



#pragma mark 加载数据
/**
 *  刷新标记
 *
 *  @param data 数据
 *  @param ty   类型
 */
-(void)dataRefresh:(NSArray*)data selcet:(NSInteger)dex;
{
    
    
    if (data.count>0) {
        
        
        for (int i=0; i<data.count; i++) {
            
            ListMapData *list =[data objectAtIndex:i];
            Item *item =[[Item alloc]init];
            item.longitude =[NSNumber numberWithDouble:list.latitude.doubleValue];
            item.latitude =[NSNumber numberWithDouble:list.longitude.doubleValue];
            item.tp =[NSString stringWithFormat:@"%d",i];
            
            if ([item.longitude isKindOfClass:[NSNumber class]]||[item.latitude isKindOfClass:[NSNumber class]]) {
                
                [_annotations addObject:item];
                
                
            }
        }
        
        NSLog(@"*******  %lu   ********\n",(unsigned long)_annotations.count);
        [_mapView beginLoad];
        
        
    }
    
}



-(void)initMapView
{
    
    self.mapView = [[MapView alloc] initWithDelegate:self];
    [self.view addSubview:_mapView];
    self.mapView.isAnnotationView =YES;
    [_mapView setFrame:CGRectMake(0, navigationHeghit, self.view.frame.size.width, TabelHeghit)];
    [_mapView shouldGroupAccessibilityChildren];
    
    
    locationButton =[[UIButton alloc]initWithFrame:CGRectMake(kDeviceWidth-50, _mapView.frame.size.height -50, 40, 40)];
    locationButton.backgroundColor =[UIColor clearColor];
    [locationButton setImage:[UIImage imageNamed:@"map_user"] forState:UIControlStateNormal];
    locationButton.selected =NO;
    [locationButton addTarget:self action:@selector(locationClick:) forControlEvents:UIControlEventTouchUpInside];
    [_mapView addSubview:locationButton];
    
}


#pragma mark -
#pragma mark delegate

-(Item *)listDataIndex:(NSInteger)index;
{
    Item *item = [_annotations objectAtIndex:index];
    
    return item;
    
}

- (NSInteger)numbersWithCalloutViewForMapView
{
    
    return [_annotations count];
}


- (UIImage *)baseMKAnnotationViewImageWithIndex:(NSString*)p;
{
    return [UIImage imageNamed:@"map_lxs"];
}

- (void )mapViewViewWithIndex:(Item*)plist;
{
    
    NSInteger dex =[plist.tp integerValue];
    ListMapData *list =[restsArray objectAtIndex:dex];
    
    ZKguideInforView *popView =[[ZKguideInforView alloc] initData:list];
    
    [popView click:^(ListMapData *list, int index) {
        
        if (index ==0) {
        
            NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",[list.phone stringByReplacingOccurrencesOfString:@"—" withString:@""]];
            
            UIWebView * callWebview = [[UIWebView alloc] init];
            [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
            [self.view addSubview:callWebview];
            
        }else if (index ==1){
            
            ZKMapNavController *mapvc =[[ZKMapNavController alloc]initKLat:mylat KLon:mylon Kadder:myAdder WLat:list.latitude.doubleValue WLon:list.longitude.doubleValue WAdder:list.address code:@""];
            [self.navigationController pushViewController:mapvc animated:YES];

            
        }
        
    }];
    
    [popView show];
    
    
}

#pragma mark UIBUTTON
#pragma mark 定位

-(void)locationClick:(UIButton*)sender
{
    
    
    if (sender.selected ==NO) {
        
        [self.mapView.mapView setShowsUserLocation:YES];
        
        CLLocationCoordinate2D loc ;
        loc.latitude =mylat;
        loc.longitude =mylon;
        //放大地图到自身的经纬度位置。
        MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(loc, self.mapView.span , self.mapView.span);
        [self.mapView.mapView setRegion:region animated:YES];
        sender.selected =YES;
    }
    else{
        
        sender.selected =NO;
        [self.mapView.mapView setShowsUserLocation:NO];
        [self.mapView.mapView showAnnotations:self.mapView.mapView.annotations animated:YES];
        
        
    }
    
    
    
}


-(void)lefBack
{
    
    self.mapView.mapView.showsUserLocation =NO;
    [self.mapView.mapView removeAnnotations:self.mapView.mapView.annotations];
    self.mapView.mapView.delegate = nil;
    
    [self.navigationController popViewControllerAnimated:YES];
    
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




@end
