//
//  MusicPlay.m
//  播放器- 2
//
//  Created by Daqsoft-Mac on 15/7/21.
//  Copyright (c) 2015年 WangXiaoLa. All rights reserved.
//

#import "MusicPlay.h"
#import <AVFoundation/AVFoundation.h>


@interface MusicPlay ()
@property (nonatomic ,strong)AVPlayer *player;

@property (nonatomic, strong) NSTimer *time;


@end



@implementation MusicPlay




+(MusicPlay *)shareMusic
{
    static  MusicPlay *play =nil;
  
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        play = [[MusicPlay alloc]init];
    });
  
    return play;
}

//初始化并重写
-(instancetype)init
{
    self = [super  init];
    if (self) {
        
        _player = [[AVPlayer alloc]init];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playNextMusic) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
        
        
    }
    return self;
}

-(void)playNextMusic {
    
    if ([self.delegate respondsToSelector:@selector(playNextMusic)]){
        
        [self.delegate playNextMusic];
    }
    
    
}


//播放
-(void)play
{
    [self.player play];
    
    
    if (self.time == nil) {
        
        //自动开启
        self.time = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(star) userInfo:nil repeats:YES];
    }
    else {
        return;
    }
    
}



//暂停
-(void)pause {
    
    [self.player pause];
    
    [self stop];
}

//准备播放
-(void)preparePlayMusicWithUrl:(NSString *)url
{
    
    AVPlayerItem *item = [[AVPlayerItem alloc]initWithURL:[NSURL URLWithString:url]];
    [self.player replaceCurrentItemWithPlayerItem:item];
    
    
}

//是否在播放
-(BOOL)isPlaying
{
    return self.player.rate;
    
}


//获取当前时间
-(NSInteger)currentTime
{
    
    CMTime time = self.player.currentTime;
    
    if (time.timescale == 0) {
        return 0;
    }
    
     return (int)time.value/time.timescale;
    
}

//总时间
-(NSInteger)totalTime
{
    CMTime time = self.player.currentItem.duration;
    if (time.timescale == 0) {
        return 0;
    }

    
     return (int)time.value/time.timescale;
}
//把时间转化为字符串
-(NSString *)changeSecondToTime:(NSInteger)second {
    
    NSInteger min = second /60;
    NSInteger sed = second %60;
    
    return [NSString stringWithFormat:@"%02ld:%02ld",(long)min,(long)sed];
    
    
}


//定时器方法
-(void)star
{
    if ([self.delegate respondsToSelector:@selector(playHeperCurrenTime:totaTime:progress:)]) {
        
        NSString * curren = [self changeSecondToTime:[self currentTime]];
        NSString *total = [self changeSecondToTime:[self totalTime]];
        CGFloat progress = [self fechTotalTime];
        
        [self.delegate playHeperCurrenTime:curren totaTime:total progress:progress];
        
    }
    
}

//关闭定时器
-(void)stop
{
    [self.time invalidate ];
     self.time = nil;
    
}

//滑块
-(CGFloat)fechTotalTime
{
    CGFloat current = (CGFloat)[self currentTime];
    CGFloat total = (CGFloat)[self totalTime];
    
    return current/total;
}

//通过滑块改变进程
-(void)bySliderValueToChangeMusicProgress:(CGFloat)progress
{
    [self pause];
    
    [self.player seekToTime:CMTimeMake(progress * [self totalTime], 1) completionHandler:^(BOOL finished) {
        if (finished) {
            
            [self play];
        }
        
    }];
    
    
}














@end
