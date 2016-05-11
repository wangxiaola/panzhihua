//
//  ZKAnnounView.m
//  CYmiangzhu
//
//  Created by 王小腊 on 16/4/15.
//  Copyright © 2016年 WangXiaoLa. All rights reserved.
//

#import "ZKAnnounView.h"

@implementation ZKAnnounView

- (instancetype)initWithFrame:(CGRect)frame
{

    self = [super initWithFrame:frame];
    if (self) {
        
        UIImageView *vies = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetHeight(frame)/2, CGRectGetWidth(frame)/2)];
        vies.image = [UIImage imageNamed:@"police_call"];
        vies.layer.masksToBounds = YES;
        vies.center = self.center;
        [self addSubview:vies];
        [self heart:vies];
    }
    
    return self;
}

/**
 *  心跳
 *
 *  @param view
 */
- (void)heart:(UIView*)view
{
    
    CABasicAnimation * animation = [CABasicAnimation animation];
    animation.keyPath =@"transform.scale";
    animation.fromValue = [NSNumber numberWithFloat:0.7];
    animation.toValue = [NSNumber numberWithFloat:1.0];
    animation.duration = 1.5f;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
    animationGroup.duration = 1.0f;
    animationGroup.autoreverses = YES;   //是否重播，原动画的倒播
    animationGroup.repeatCount = NSNotFound;//HUGE_VALF;     //HUGE_VALF,源自math.h
    [animationGroup setAnimations:[NSArray arrayWithObjects:animation, nil]];
    //将上述两个动画编组
    [view.layer addAnimation:animationGroup forKey:@"animationGroup"];
}

-(void)drawRect:(CGRect)rect {
    
    [super drawRect:rect];
    
    [[UIColor clearColor] setFill];
    
    UIRectFill(rect);
    NSInteger pulsingCount = 3;
    double animationDuration = 3;
    CALayer * animationLayer = [CALayer layer];
    
    for (int i = 0; i < pulsingCount; i++) {
        CALayer * pulsingLayer = [CALayer layer];
        pulsingLayer.frame = CGRectMake(0, 0, rect.size.width, rect.size.height);
        pulsingLayer.borderColor = [UIColor whiteColor].CGColor;
        pulsingLayer.borderWidth = 1;
        pulsingLayer.cornerRadius = rect.size.height / 2;
        
        CAMediaTimingFunction * defaultCurve = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
        
        CAAnimationGroup * animationGroup = [CAAnimationGroup animation];
        animationGroup.fillMode = kCAFillModeBackwards;
        animationGroup.beginTime = CACurrentMediaTime() + (double)i * animationDuration / (double)pulsingCount;
        animationGroup.duration = animationDuration;
        animationGroup.repeatCount = HUGE;
        animationGroup.timingFunction = defaultCurve;
        
        CABasicAnimation * scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        scaleAnimation.fromValue = @1.4;
        scaleAnimation.toValue = @2.2;
        
        CAKeyframeAnimation * opacityAnimation = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
        opacityAnimation.values = @[@1, @0.9, @0.8, @0.7, @0.6, @0.5, @0.4, @0.3, @0.2, @0.1, @0];
        opacityAnimation.keyTimes = @[@0, @0.1, @0.2, @0.3, @0.4, @0.5, @0.6, @0.7, @0.8, @0.9, @1];
        
        animationGroup.animations = @[scaleAnimation, opacityAnimation];
        [pulsingLayer addAnimation:animationGroup forKey:@"plulsing"];
        [animationLayer addSublayer:pulsingLayer];
    }
    [self.layer addSublayer:animationLayer];
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
