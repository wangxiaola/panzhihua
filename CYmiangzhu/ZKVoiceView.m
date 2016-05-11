//
//  DQVoiceView.m
//  changyouyibin
//
//  Created by Daqsoft-Mac on 15/1/13.
//  Copyright (c) 2015年 WangXiaoLa. All rights reserved.
//

#import "ZKVoiceView.h"

#import "ZKAppDelegate.h"




@implementation ZKVoiceView


{

    
    UILabel *nameLabel;
    
    UIView *view;
    
    NSString *pathYp;
    
    NSString *statePath;

    UIActivityIndicatorView *_activityView;

    UIView *routeLabel;
    
    float ViewHeighit;
    
    BOOL isPay;
}




- (id)initWithFrame:(CGRect)frame Path:(NSString*)path Titi:(NSString*)titi Image:(NSString *)imageUrl;{
    
    self = [super initWithFrame:frame];
    if (self) {
        
        ViewHeighit = frame.size.height;
        pathYp=[NSString stringWithFormat:@"%@%@",imageUrlPrefix,path];
        statePath =path;
        self.backgroundColor =[UIColor whiteColor];
        self.clipsToBounds =YES;
        _lefView =[[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 40, 40)];
        _lefView.backgroundColor =[UIColor clearColor];
        _lefView.layer.masksToBounds =YES;
        _lefView.layer.cornerRadius =20;
        _lefView.userInteractionEnabled =YES;
         [ZKUtil UIimageView:_lefView NSSting:[NSString stringWithFormat:@"%@%@",imageUrlPrefix,imageUrl]];
        [self addSubview:_lefView];
        //添加动画
        CABasicAnimation *monkeyAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        monkeyAnimation.toValue = [NSNumber numberWithFloat:2.0 *M_PI];
        monkeyAnimation.duration = 1.5f;
        monkeyAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
        monkeyAnimation.cumulative = NO;
        monkeyAnimation.removedOnCompletion = NO; //No Remove
        
        monkeyAnimation.repeatCount = FLT_MAX;
        [self.lefView.layer addAnimation:monkeyAnimation forKey:@"AnimatedKey"];
        [self.lefView stopAnimating];
        // 加载动画 但不播放动画
        self.lefView.layer.speed = 0.0;
        
        UIButton *vis =[[UIButton alloc]initWithFrame:CGRectMake(8, 8, 24, 24)];
        vis.backgroundColor =[UIColor clearColor];
        [vis setImage:[UIImage imageNamed:@"play.jpg"] forState:0];
        vis.layer.masksToBounds =YES;
        vis.layer.cornerRadius = 12;
        vis.layer.borderWidth = 0.5;
        vis.selected = NO;
        vis.layer.borderColor =[UIColor whiteColor].CGColor;
        [vis addTarget:self action:@selector(imageTap:) forControlEvents:UIControlEventTouchUpInside];
        [_lefView addSubview:vis];
        
        
        
        nameLabel =[[UILabel alloc]initWithFrame:CGRectMake(ViewHeighit, 5, self.frame.size.width -ViewHeighit, 18)];
        nameLabel.font =[UIFont systemFontOfSize:12];
        nameLabel.text =[NSString stringWithFormat:@"%@语音",titi];
        nameLabel.textColor =[UIColor blackColor];
        [self addSubview:nameLabel];
        
        routeLabel =[[UIView alloc]initWithFrame:CGRectMake(ViewHeighit, ViewHeighit-20, kDeviceWidth-ViewHeighit-10, 4)];
        routeLabel.backgroundColor =YJCorl(216, 216, 216);
        [self addSubview:routeLabel];
        
        self.elapsedTime =[[UILabel alloc]initWithFrame:CGRectMake(0, -4 , 40, 12)];
        self.elapsedTime.backgroundColor =[UIColor whiteColor];
        self.elapsedTime.textColor =[UIColor grayColor];
        self.elapsedTime.text =@"00:00";
        self.elapsedTime.textAlignment =NSTextAlignmentCenter;
        self.elapsedTime.font =[UIFont systemFontOfSize:8];
        self.elapsedTime.layer.masksToBounds =YES;
        self.elapsedTime.layer.cornerRadius =4;
        self.elapsedTime.layer.borderColor =YJCorl(216, 216, 216).CGColor;
        self.elapsedTime.layer.borderWidth =0.6;
        [routeLabel addSubview:self.elapsedTime];
        
       
        [MusicPlay shareMusic].delegate = self;
        [[MusicPlay shareMusic] preparePlayMusicWithUrl:pathYp];
        
        
        
    }
    return self;
}


#pragma  mark mus代理

-(void)playHeperCurrenTime:(NSString *)currenTime totaTime:(NSString *)totalTime progress:(CGFloat)progress;
{
    

    if (progress>0) {
        
        float p = (routeLabel.frame.size.width-40)*progress;
        self.elapsedTime.frame = CGRectMake(p, -4, 40, 12);
        self.elapsedTime.text =currenTime;
    }

    
    
}
-(void)playNextMusic;
{
    [SVProgressHUD showSuccessWithStatus:@"语音播放完毕" duration:1];
    [self stopAnimation];
    isPay = YES;
    
}



-(void) startAnimation
{
    
    self.lefView.layer.speed = 1.0;
    self.lefView.layer.beginTime = 0.0;
    CFTimeInterval pausedTime = [self.lefView.layer timeOffset];
    CFTimeInterval timeSincePause = [self.lefView.layer convertTime:CACurrentMediaTime() fromLayer:nil] - pausedTime;
    self.lefView.layer.beginTime = timeSincePause;
}


-(void)stopAnimation
{

    CFTimeInterval pausedTime = [self.lefView.layer convertTime:CACurrentMediaTime() fromLayer:nil];
    self.lefView.layer.speed = 0.0;
    self.lefView.layer.timeOffset = pausedTime;
}



-(void)imageTap:(UIButton*)sender
{
   
    [[BaiduMobStat defaultStat] logEvent:@"playOrPauseMusic" eventLabel:@"播放或暂停音乐"];
    
    if (strIsEmpty(statePath)==1) {
        
        [[APPDELEGATE window] makeToast:@"该景区暂没有语音介绍." duration:1 position:nil];
        return ;

    }else if ([statePath isEqualToString:@"没网"]){
    
    
        
        [[APPDELEGATE window] makeToast:@"没有网络，语音播放失败!" duration:1 position:nil];
        return ;
    
    }
    
    if (sender.selected == NO) {
        
        sender.selected = YES;
        //播放
        
        if (isPay ==YES) {
            isPay = NO;
            [[MusicPlay shareMusic] preparePlayMusicWithUrl:pathYp];
              [[MusicPlay shareMusic] play];
            
        }else{

            [[MusicPlay shareMusic] play];
            
            [self startAnimation];
        }
 

        
    }else{
       //暂停
        sender.selected = NO;
        [[MusicPlay shareMusic] pause];
        
        [self stopAnimation];
    
    }

    
}


-(void)pause;
{
    
     [self stopAnimation];
     [[MusicPlay shareMusic] pause];
}








/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
