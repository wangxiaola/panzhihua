//
//  ZKPopImageView.m
//  CYmiangzhu
//
//  Created by 小腊 on 16/5/17.
//  Copyright © 2016年 WangXiaoLa. All rights reserved.
//

#import "ZKPopImageView.h"
#import "ZKAppDelegate.h"
@implementation ZKPopImageView
{
    
    UIImageView *contentView;
    
    
}

-(void)show;
{
    self.alpha = 1;
    
    contentView.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2 );
    [[APPDELEGATE window] addSubview:self];
    contentView.transform = CGAffineTransformMakeScale(0, 0);
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        contentView.transform = CGAffineTransformMakeScale(1.2, 1.2);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            contentView.transform = CGAffineTransformMakeScale(1, 1);
        } completion:^(BOOL finished) {
            
        }];
    }];
    
}


-(instancetype)initImage:(UIImage*)image;
{
    self =[super initWithFrame:APPDELEGATE.window.bounds];
    if (self) {
        
        
         [self initViews];
        contentView.image = image;
    }
    
    return self;
    

}
-(instancetype)initImageUrl:(NSString*)url;
{

    self =[super initWithFrame:APPDELEGATE.window.bounds];
    if (self) {
        
        
        [self initViews];
        [ZKUtil UIimageView:contentView NSSting:url];
    }
    
    return self;
    
}
- (void)initViews
{

    UIButton *hideButton = [[UIButton alloc] initWithFrame:self.bounds];
    hideButton.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    [hideButton addTarget:self action:@selector(hideButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:hideButton];

    contentView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth/2, kDeviceWidth/2)];
    contentView.backgroundColor = [UIColor whiteColor];
    [self addSubview:contentView];

    
    
}

-(void)hideButtonClick{
    
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        
        [self removeFromSuperview];
    }];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
