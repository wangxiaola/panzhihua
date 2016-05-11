//
//  GSLocationTool.h
//  Location
//
//  Created by 小怪兽 on 14/10/28.
//  Copyright (c) 2014年 小怪兽. All rights reserved.
//





#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

typedef void(^getLocation)(float lat, float lng);

typedef void(^getProvinceAndCity)(NSString *province, NSString *city);

typedef void(^error)(NSString *error);

@interface GSLocationTool : NSObject
<CLLocationManagerDelegate>
{
    BOOL _isGetLocation;
}
@property(strong, nonatomic)CLLocationManager *locationManager;

@property(copy,nonatomic)getLocation locationBlock;

@property(nonatomic,copy)getProvinceAndCity provinceBlock;

@property(nonatomic,copy)error errorBlock;


+(GSLocationTool *)sharedLocationTool;

- (void)getLocationAndCompletion:(getLocation)newBlock error:(error)errorBlock;

- (void)getProvinceAndCompletion:(getProvinceAndCity)newBlock error:(error)errorBlock;

@end
