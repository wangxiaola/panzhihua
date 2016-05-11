//
//  ZKAnnounciatorView.m
//  CYmiangzhu
//
//  Created by 王小腊 on 16/4/15.
//  Copyright © 2016年 WangXiaoLa. All rights reserved.
//

#import "ZKAnnounciatorView.h"
#import "ZKAnnounView.h"

@implementation ZKAnnounciatorView

{
    click  _click;
    
    UIImageView *_lefView;

    
    ZKAnnounView  *_announView;
    
}




- (instancetype)initWithFrame:(CGRect)frame;
{

    self = [super initWithFrame:frame];
    
    if (self) {
        
        float imageW = frame.size.width;
        
        self.backgroundColor =[UIColor clearColor];
        self.clipsToBounds =YES;
        _lefView =[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, imageW, imageW)];
        _lefView.center = self.center;
        _lefView.backgroundColor =[UIColor clearColor];
        _lefView.layer.masksToBounds =YES;
        _lefView.layer.cornerRadius =imageW/2;
        _lefView.userInteractionEnabled =YES;
        _lefView.image = [UIImage imageNamed:@"police_anim_all"];
        [self addSubview:_lefView];
        
        //添加动画
        CABasicAnimation *monkeyAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        monkeyAnimation.toValue = [NSNumber numberWithFloat:2.0 *M_PI];
        monkeyAnimation.duration = 1.5f;
        monkeyAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
        monkeyAnimation.cumulative = NO;
        monkeyAnimation.removedOnCompletion = NO; //No Remove
        monkeyAnimation.repeatCount = FLT_MAX;
        [_lefView.layer addAnimation:monkeyAnimation forKey:@"AnimatedKey"];
        [_lefView startAnimating];


        
        _announView = [[ZKAnnounView alloc] initWithFrame:CGRectMake(0, 0, imageW/2, imageW/2)];
        _announView.backgroundColor = [UIColor clearColor];
        _announView.center = _lefView.center;
        [self addSubview:_announView];
        
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
        
        [_announView addGestureRecognizer:singleTap];
        
    }

    return self;

}

-(void)handleSingleTap:(UITapGestureRecognizer *)sender

{
  _click();
    
}


- (void)selClick:(void (^) ())sel;
{

    _click = sel;
}


-(void)scaleBegin:(CALayer *)layer
{
    const float maxScale=120;
    if (layer.transform.m11<maxScale) {
        if (layer.transform.m11==1.0) {
            [layer setTransform:CATransform3DMakeScale( 1.1, 1.1, 1.0)];
        }else{
            [layer setTransform:CATransform3DScale(layer.transform, 1.1, 1.1, 1.0)];
        }
        [self performSelector:_cmd withObject:layer afterDelay:0.06];
    }else [layer removeFromSuperlayer];
}




/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
