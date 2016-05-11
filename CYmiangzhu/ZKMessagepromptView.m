//
//  ZKMessagepromptView.m
//  wpJieBanYou
//
//  Created by Daqsoft-Mac on 15/3/27.
//  Copyright (c) 2015年 WangXiaoLa. All rights reserved.
//

#import "ZKMessagepromptView.h"

@implementation ZKMessagepromptView
{
    
    //NSString *str;
    
    UIView *contentView;

    NSNumber *Id;
    
    NSString *toName;
}

-(void)show;
{
    self.alpha = 1;
    [[APPDELEGATE window] addSubview:self];
    [UIView animateWithDuration:0.4 animations:^{
        
        contentView.frame =CGRectMake(0, 0, kDeviceWidth, 60);
    }];
    
}



-(id)initImage:(NSString*)url Message:(NSString*)message Fid:(NSNumber*)fid Name:(NSString*)name;
{
    
    self =[super initWithFrame:APPDELEGATE.window.bounds];
    if (self) {
        
        Id =fid;
        toName =name;
        
        self.backgroundColor =[UIColor clearColor];
        self.userInteractionEnabled =YES;
        contentView = [[UIView alloc] initWithFrame:CGRectMake(0, -60,kDeviceWidth , 60)];
        contentView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        [self addSubview:contentView];
        
        UIImageView *fotImage =[[UIImageView alloc]initWithFrame:CGRectMake(10, 20, 35, 35)];
        fotImage.layer.masksToBounds =YES;
        fotImage.layer.cornerRadius =5;
        [ZKUtil UIimageView:fotImage NSSting:url];
        [contentView addSubview:fotImage];
        
        UILabel *messLabel =[[UILabel alloc]initWithFrame:CGRectMake(60, 10, kDeviceWidth -70, 40)];
        messLabel.backgroundColor =[UIColor clearColor];
        messLabel.font =[UIFont systemFontOfSize:15];
        messLabel.textColor =[UIColor whiteColor];
        messLabel.numberOfLines =2;
        messLabel.text =[NSString stringWithFormat:@"%@\n%@",name,message];
        [contentView addSubview:messLabel];
        
        int64_t delayInSeconds = 5;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            
            [self  hideButtonClick];
        });
        
        UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped)];
        [contentView addGestureRecognizer:tapGr];
        
        
    }
    return self;
}
-(void)viewTapped
{

    //创建通知
    NSNotification *notification =[NSNotification notificationWithName:@"notifClick" object:self.url];
    //通过通知中心发送通知
    [[NSNotificationCenter defaultCenter] postNotification:notification];

    [self hideButtonClick];
    

    
}
-(void)hideButtonClick{
    
    [UIView animateWithDuration:0.4 animations:^{
        
        contentView.frame =CGRectMake(0, -60, kDeviceWidth, 60);
        
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
