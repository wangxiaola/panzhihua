//
//  ZKVideoViewController.m
//  CYmiangzhu
//
//  Created by Daqsoft-Mac on 15/7/21.
//  Copyright (c) 2015年 WangXiaoLa. All rights reserved.
//

#import "ZKVideoViewController.h"
#import "KrVideoPlayerController.h"

@interface ZKVideoViewController ()

@property (nonatomic, strong) KrVideoPlayerController  *videoController;

@end

@implementation ZKVideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    self.titeLabel.text =self.videoName;
    self.view.backgroundColor =[UIColor blackColor];
    [self playVideo];
    
}


- (void)playVideo{
    
    NSURL *url = [NSURL URLWithString:self.url];
    [self addVideoPlayerWithURL:url];
}

- (void)addVideoPlayerWithURL:(NSURL *)url{
    
    if (!self.videoController) {
        
        CGFloat width = [UIScreen mainScreen].bounds.size.width;
        
        self.videoController = [[KrVideoPlayerController alloc] initWithFrame:CGRectMake(0, 64, width, width*(9.0/16.0))];
        self.videoController.view.center =self.view.center;
        
        __weak typeof(self) weakSelf = self;
        
        [self.videoController setDimissCompleteBlock:^{
            weakSelf.videoController = nil;
        }];
        [self.videoController setWillBackOrientationPortrait:^{
            
            [weakSelf toolbarHidden:NO];
        }];
        [self.videoController setWillChangeToFullscreenMode:^{
            [weakSelf toolbarHidden:YES];
        }];
        [self.view addSubview:self.videoController.view];
    }
    self.videoController.contentURL = url;
    
    [self.videoController setDeviceOrientationLandscapeRight];
 
}


//隐藏navigation tabbar 电池栏
- (void)toolbarHidden:(BOOL)Bool{
    
    self.navigationController.navigationBar.hidden = Bool;
    self.tabBarController.tabBar.hidden = YES;
    [[UIApplication sharedApplication] setStatusBarHidden:Bool withAnimation:UIStatusBarAnimationFade];
    
}
-(void)dealloc
{
    [self.videoController dismiss];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
