//
//  ZKdyAnnotationView.h
//  CYmiangzhu
//
//  Created by Daqsoft-Mac on 15/10/15.
//  Copyright (c) 2015年 WangXiaoLa. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface ZKdyAnnotationView : MKAnnotationView

@property (nonatomic,strong)UIView *contentView;

- (id)initWithAnnotation:(id<MKAnnotation>)annotation
         reuseIdentifier:(NSString *)reuseIdentifier;

@end
