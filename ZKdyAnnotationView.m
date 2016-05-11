//
//  ZKdyAnnotationView.m
//  CYmiangzhu
//
//  Created by Daqsoft-Mac on 15/10/15.
//  Copyright (c) 2015年 WangXiaoLa. All rights reserved.
//

#import "ZKdyAnnotationView.h"

@implementation ZKdyAnnotationView

- (id)initWithAnnotation:(id<MKAnnotation>)annotation
         reuseIdentifier:(NSString *)reuseIdentifier

{
    self = [super initWithAnnotation:annotation
                     reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.canShowCallout = NO;
        self.centerOffset = CGPointMake(0, -88);
        self.frame = CGRectMake(0, 0, 275, 135);
        
        UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        contentView.backgroundColor = [UIColor clearColor];
        [self addSubview:contentView];
        self.contentView = contentView;
    }
    return self;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
