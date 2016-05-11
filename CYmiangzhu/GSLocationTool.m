//
//  GSLocationTool.m
//  Location
//
//  Created by 小怪兽 on 14/10/28.
//  Copyright (c) 2014年 小怪兽. All rights reserved.
//

#define SYSTEM_VERSION              [[[UIDevice currentDevice] systemVersion] floatValue]

#import "GSLocationTool.h"

@implementation GSLocationTool


+(GSLocationTool *)sharedLocationTool
{
    static GSLocationTool *locationTool = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        locationTool = [[self alloc]init];
    });
    return locationTool;
}

- (void)getLocation
{
    //判断定位服务是否可用
    if ([CLLocationManager locationServicesEnabled]){
        
        //创建一个定位管理对象
        self.locationManager=[[CLLocationManager alloc] init];
        //设置精确度
        self.locationManager.desiredAccuracy=kCLLocationAccuracyBest;
        //距离过滤，超过这个设置才会返回定位的信息
        //locationManager.distanceFilter=10;
        
        //设置代理
        self.locationManager.delegate = self;
        //开始定位
        if (SYSTEM_VERSION >= 8)
        {
            [self.locationManager requestWhenInUseAuthorization];
        }
        [self.locationManager startUpdatingLocation];
        
    }else{
        
        self.errorBlock(@"该设备不支持定位服务");
    }
}



- (void)getLocationAndCompletion:(getLocation)newBlock error:(error)errorBlock
{
    _isGetLocation = YES;
    self.locationBlock = newBlock;
    self.errorBlock = errorBlock;
    [self getLocation];
}

- (void)getProvinceAndCompletion:(getProvinceAndCity)newBlock error:(error)errorBlock
{
    
    self.provinceBlock = newBlock;
    self.errorBlock = errorBlock;
    [self getLocation];
    
}

#pragma mark-------------------CLLocationManagerDelegate------------------------------

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    
    static BOOL isSuccessed = NO;
    //获取到一个最新的位置对象
    CLLocation *location=[locations lastObject];
    //获取纬度
    float lat=location.coordinate.latitude;
    //获取经度
    float lng=location.coordinate.longitude;
    //    NSLog(@"%f,%f",lat,lng);
    if (_isGetLocation && lat && lng)
    {
        _isGetLocation = NO;
        self.locationBlock(lat,lng);
    }
    if (!isSuccessed && lat && lng && !_isGetLocation)
    {
        //    定位一次,停止定位
        isSuccessed = YES;
        [manager stopUpdatingLocation];
        [self geocoderGetCityWith:location];
    }
    
}

- (void)geocoderGetCityWith:(CLLocation *)userLocation
{
    
    // 获取当前所在的城市名及省份
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    //根据经纬度反向地理编译出地址信息
    [geocoder reverseGeocodeLocation:userLocation completionHandler:^(NSArray *array, NSError *error)
     {
         if (!error)
         {
             if (array.count > 0)
             {
                 CLPlacemark *placemark = [array objectAtIndex:0];
                 //获取省份
                 NSString *province = placemark.administrativeArea;
                 //获取城市,四大直辖市的城市信息无法通过locality获得，只能通过获取省份的方法来获得（如果city为空，则可知为直辖市）(上海，北京，重庆，天津)
                 NSString *city = placemark.locality?placemark.locality:province;
                 self.provinceBlock(province,city);
             }else{
                 self.errorBlock(@"当前位置获取不到省市信息");
             }
         }else{
             self.errorBlock([NSString stringWithFormat:@"%@",error]);
         }
     }];
}








@end
