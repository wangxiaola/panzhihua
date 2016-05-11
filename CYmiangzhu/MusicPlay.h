//
//  MusicPlay.h
//  播放器- 2
//
//  Created by Daqsoft-Mac on 15/7/21.
//  Copyright (c) 2015年 WangXiaoLa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@protocol MusicPlayDelegate <NSObject>

//currenTime;//当前时间
// totalTime;//总时间
// progress;//滑块
-(void)playHeperCurrenTime:(NSString *)currenTime totaTime:(NSString *)totalTime progress:(CGFloat)progress;

-(void)playNextMusic;
@end



@interface MusicPlay : NSObject

@property (nonatomic ,assign ) id<MusicPlayDelegate>delegate;


+(MusicPlay *)shareMusic;

//准备播放
-(void)preparePlayMusicWithUrl:(NSString *)url;

//暂停
-(void)pause;
//播放
-(void)play;
//是否在播放
-(BOOL)isPlaying;


//通过滑块改变进程
-(void)bySliderValueToChangeMusicProgress:(CGFloat)progress;

@end
