//
//  DQVoiceView.h
//  changyouyibin
//
//  Created by Daqsoft-Mac on 15/1/13.
//  Copyright (c) 2015年 WangXiaoLa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MusicPlay.h"

@interface ZKVoiceView : UIView<UIGestureRecognizerDelegate,MusicPlayDelegate>


@property (nonatomic, strong) UILabel *elapsedTime;
@property (nonatomic,strong)  UIImageView *lefView;
@property (nonatomic, assign) BOOL isInView;

-(void)pause;

- (id)initWithFrame:(CGRect)frame Path:(NSString*)path Titi:(NSString*)titi Image:(NSString *)imageUrl;


@end
