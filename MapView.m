//
//  MapView.m
//
//
//  Created by Jian-Ye on 12-10-16.
//  Copyright (c) 2012年 Jian-Ye. All rights reserved.
//

#import "MapView.h"
#import "CallOutAnnotationView.h"
#import "CalloutMapAnnotation.h"
#import "BasicMapAnnotation.h"
#import "ZKdyAnnotationView.h"

@interface MapView ()<MKMapViewDelegate,CallOutAnnotationViewDelegate>

@property (nonatomic,weak)id<MapViewDelegate> delegate;

@property (nonatomic,strong)CalloutMapAnnotation *calloutAnnotation;
@end

@implementation MapView

@synthesize mapView = _mapView;
@synthesize delegate = _delegate;

- (id)init
{
    if (self = [super init]) {
        self.backgroundColor = [UIColor clearColor];
        
        MKMapView *mapView = [[MKMapView alloc] initWithFrame:self.bounds];
        mapView.delegate = self;
        [self addSubview:mapView];
        self.mapView =  mapView;
        
        self.span = 100000;
    }
    return self;
}


- (id)initWithDelegate:(id<MapViewDelegate>)delegate
{
    if (self = [self init]) {
        
        self.anntionArray =[[NSMutableArray alloc]initWithCapacity:0];
        self.searchArray = [[NSMutableArray alloc]initWithCapacity:0];
        self.delegate = delegate;
    }
    return self;
}

- (void)setFrame:(CGRect)frame
{
    self.mapView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
    [super setFrame:frame];
}

-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation{
    CLLocationCoordinate2D loc = [userLocation coordinate];
    //放大地图到自身的经纬度位置。
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(loc, 100000, 100000);
    [self.mapView setRegion:region animated:YES];
}

- (void)beginLoad
{
    
    for (int i = 0; i < [_delegate numbersWithCalloutViewForMapView]; i++) {
        
        Item *item =[_delegate listDataIndex:i];
        
        
        CLLocationCoordinate2D location;
        
        location.longitude = [item.latitude doubleValue];
        location.latitude  = [item.longitude doubleValue];
        
        
//        MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(location,_span ,_span );
//        
//        MKCoordinateRegion adjustedRegion = [_mapView regionThatFits:region];
//        
//        [_mapView setRegion:adjustedRegion animated:YES];
        
        
        BasicMapAnnotation *annotation =[[BasicMapAnnotation alloc]initWithLatitude:location.latitude andLongitude:location.longitude data:item];
        
        annotation.type =item.tp;
        
        
        [_mapView  addAnnotation:annotation];
        
        [_mapView showAnnotations:_mapView.annotations animated:YES];
        
        if (item.poop ==2)
        {
            
            [self.searchArray addObject:annotation];
            
        }else if (item.poop ==1)
        {
            
            [self.anntionArray addObject:annotation];
            
        }
        
        
        
    }
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    
    
    
    if ([view.annotation isKindOfClass:[BasicMapAnnotation class]]) {
        
        BasicMapAnnotation *annotation = (BasicMapAnnotation *)view.annotation;
        
        if (_calloutAnnotation.coordinate.latitude == annotation.latitude&&
            _calloutAnnotation.coordinate.longitude == annotation.longitude)
        {
            return;
        }
        if (_calloutAnnotation) {
            [mapView removeAnnotation:_calloutAnnotation];
            self.calloutAnnotation = nil;
        }
        self.calloutAnnotation = [[CalloutMapAnnotation alloc]
                                  initWithLatitude:annotation.latitude
                                  andLongitude:annotation.longitude
                                  data:annotation.list];
        
        [mapView addAnnotation:_calloutAnnotation];
        
        /**
         *  中心坐标转换
         */
        CGPoint p =[mapView convertCoordinate:_calloutAnnotation.coordinate toPointToView:self.mapView];
        CGPoint k;
        k.x =p.x;
        
        if (_isAnnotationView ==YES) {
           k.y =p.y+40;
            
        }else{
            
           k.y =p.y-40;
        
        }

        [mapView setCenterCoordinate:[mapView convertPoint:k toCoordinateFromView:self.mapView] animated:YES];
        
      
    }
}

/**
 *  点击
 *
 *  @param view
 */
- (void)didSelectAnnotationView:(CallOutAnnotationView *)view
{

    
    CalloutMapAnnotation *annotation = (CalloutMapAnnotation *)view.annotation;
    
    
    if (annotation.callList.poop ==3) {
        
        return;
    }
    
    if([_delegate respondsToSelector:@selector(calloutViewDidSelectedWithIndex:)])
    {
        [_delegate calloutViewDidSelectedWithIndex:annotation.callList];
    }
    
    [self mapView:_mapView didDeselectAnnotationView:view];
}

- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view
{
    if (_calloutAnnotation)
    {
        if (_calloutAnnotation.coordinate.latitude == view.annotation.coordinate.latitude&&
            _calloutAnnotation.coordinate.longitude == view.annotation.coordinate.longitude)
        {
            [mapView removeAnnotation:_calloutAnnotation];
            self.calloutAnnotation = nil;
        }
    }
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    
    BasicMapAnnotation *basicMapAnnotation = (BasicMapAnnotation *)annotation;
    
    
    
    if ([annotation isKindOfClass:[CalloutMapAnnotation class]])
    {
         CalloutMapAnnotation *calloutAnnotation = (CalloutMapAnnotation *)annotation;
        if (_isAnnotationView ==NO) {
         
            CallOutAnnotationView *   annotationView = [[CallOutAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"CalloutView" delegate:self];
            for (UIView *view in  annotationView.contentView.subviews) {
                [view removeFromSuperview];
            }
            
            [annotationView.contentView addSubview:[_delegate mapViewCalloutContentViewWithIndex:calloutAnnotation.callList]];
            return annotationView;
            
        }else{
        
            ZKdyAnnotationView *annotationView =[[ZKdyAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:@"dyCalloutView"];
            
            for (UIView *view in  annotationView.contentView.subviews) {
                [view removeFromSuperview];
            }
            [_delegate mapViewViewWithIndex:calloutAnnotation.callList];
            
            return annotationView;
        }
      
        
    } else if ([annotation isKindOfClass:[BasicMapAnnotation class]])
    {
        
        
        
        MKAnnotationView *  annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation
                                                                          reuseIdentifier:@"CustomAnnotation"];
        annotationView.canShowCallout = NO;
        annotationView.image = [_delegate baseMKAnnotationViewImageWithIndex:basicMapAnnotation.list.tp];
        
        
        return annotationView;
    }
    return nil;
}

@end
