//
//  DQSuperViewController.h
//  ChangYouYiBin
//
//  Created by Daqsoft-Mac on 14/11/26.
//  Copyright (c) 2014年 StrongCoder. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZKUtil.h"
#import "ZKHttp.h"
#import "UIImageView+WebCache.h"

#import "Toast+UIView.h"

#define navigationHeghit self.navigationBarView.frame.size.height
#define TabelHeghit self.view.frame.size.height - self.navigationBarView.frame.size.height

#define buttonItemWidth 40
#define navHeight 64.0

@class DQAnimationIndicator;

@interface ZKSuperViewController : UIViewController

@property(strong,nonatomic)UIView * navigationBarView;

@property(strong,nonatomic)UIButton *leftBarButtonItem;

@property(strong,nonatomic)UIButton *rittBarButtonItem;

@property (strong,nonatomic) UIButton *rittBarButtonItem2;

@property(strong,nonatomic)UILabel *titeLabel;


@end
