//
//  ZKActivitiesShareViewController.m
//  weipeng
//
//  Created by Daqsoft-Mac on 15/2/12.
//  Copyright (c) 2015年 WangXiaoLa. All rights reserved.
//

#import "ZKActivitiesShareViewController.h"
#import <ShareSDK/ShareSDK.h>
#import "WXApi.h"
#import "WeiboSDK.h"
#import <TencentOpenAPI/QQApiInterface.h>

@interface ZKActivitiesShareViewController ()
{

    NSString *imagUrl;
    
    NSString *theme;
    
    NSString *designation;
    
    NSNumber *spId;
    
    NSString *shareUrl;
    
    float BWidth;
    
    float SWidth;
    NSArray *tits;
}
@end

@implementation ZKActivitiesShareViewController

-(id)initImageUrl:(NSString*)url Theme:(NSString*)str Name:(NSString*)name Lurl:(NSString*)lur;
{
    
    self =[super init];
    if (self) {
        self.hidesBottomBarWhenPushed =YES;
        imagUrl =url;
        
        theme =str;
        
        designation =name;
        
        shareUrl =lur;
        
    }
    return self;
}
- (void)viewDidLoad {
    
    [super viewDidLoad];
    

    self.titeLabel.text =@"告诉小伙伴";

    self.view.backgroundColor =TabelBackCorl;

    [self initView];
    
}


-(void)initView
{
    UIView *conteView =[[UIView alloc]initWithFrame:CGRectMake(0, navigationHeghit, self.view.frame.size.width, 100)];
    conteView.backgroundColor =[UIColor whiteColor];
    [self.view addSubview:conteView];
    
    UIImageView *headImage =[[UIImageView alloc]initWithFrame:CGRectMake(6, 6, 94, 88)];
    headImage.backgroundColor =[UIColor whiteColor];
    [ZKUtil UIimageView:headImage NSSting:imagUrl duImage:@"zz"];
    [conteView addSubview:headImage];
    
    UILabel *contLabel =[[UILabel alloc]initWithFrame:CGRectMake(106, 8, 200, 20)];
    contLabel.backgroundColor =[UIColor whiteColor];
    contLabel.text =theme;
    contLabel.textAlignment =NSTextAlignmentLeft;
    contLabel.font =[UIFont systemFontOfSize:16];
    contLabel.textColor =[UIColor blackColor];
    [conteView addSubview:contLabel];
    
    UILabel *nameLabel =[[UILabel alloc]initWithFrame:CGRectMake(106, 30, kDeviceWidth-110, 65)];
    nameLabel.backgroundColor =[UIColor whiteColor];
    nameLabel.textAlignment =NSTextAlignmentLeft;
    nameLabel.textColor =[UIColor orangeColor];
    nameLabel.numberOfLines =4;
    nameLabel.font =[UIFont systemFontOfSize:13];
    nameLabel.text = [NSString stringWithFormat:@"地址: %@",designation];
    [conteView addSubview:nameLabel];

    UIView *shareView =[[UIView alloc]initWithFrame:CGRectMake(0,navigationHeghit+ 110, self.view.frame.size.width, 150)];
    shareView.backgroundColor =[UIColor whiteColor];
    [self.view addSubview:shareView];
    UILabel *huntLabel =[[UILabel alloc]initWithFrame:CGRectMake(6, 0, 200, 30)];
    huntLabel.textAlignment =NSTextAlignmentLeft;
    huntLabel.textColor =[UIColor blackColor];
    huntLabel.text =@"将该商品分享到 :";
    huntLabel.font =[UIFont systemFontOfSize:16];
    [shareView addSubview:huntLabel];
    
    UIView *lin =[[UIView alloc]initWithFrame:CGRectMake(0, 30, self.view.frame.size.width, 0.5)];
    lin.backgroundColor =TabelBackCorl;
    [shareView addSubview:lin];
    
    
    
    
     BWidth =50;
     SWidth =(self.view.frame.size.width-BWidth*4)/5;
    
    
    tits =@[@"新浪微博",@"QQ空间",@"微信好友",@"朋友圈"];
    
    NSInteger dex =0;
    
    for (int i =0; i<4; i++) {
        
        if (i ==0) {
            
            dex =0;
            
            [self shareBUtton:i fame:dex contenView:shareView];
            
        }else if (i ==1){
           

              dex++;
             [self shareBUtton:i fame:dex contenView:shareView];
                
        

        
        }else if (i ==2){
        

            dex++;
            [self shareBUtton:i fame:dex contenView:shareView];
            

            
        }else if (i ==3){
          

               dex ++;
                 [self shareBUtton:i fame:dex contenView:shareView];
            

        }
    }
    

}

/**
 *  分享按钮排布
 *
 *  @param tag   按钮tag
 *  @param index 排列第几个
 *  @param views 俯视图
 */
-(void)shareBUtton:(NSInteger)tag fame:(NSInteger)index  contenView:(UIView*)views;
{
    

    UIButton *bty =[[UIButton alloc]initWithFrame:CGRectMake(SWidth+(SWidth+BWidth)*index, 50, BWidth, BWidth)];
    bty.backgroundColor =[UIColor blackColor];
    bty.layer.masksToBounds =YES;
    bty.layer.cornerRadius =4;
    
    [bty setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"share_%d",tag]] forState:UIControlStateNormal];
    [bty setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"share_%d%d",tag,tag]] forState:UIControlStateHighlighted];
    bty.tag =2000+tag;
    [bty addTarget:self action:@selector(sharaButton:) forControlEvents:UIControlEventTouchUpInside];
    [views addSubview:bty];
    
    UILabel *la =[[UILabel alloc]initWithFrame:CGRectMake(SWidth-10+(SWidth+BWidth)*index, 110, BWidth+20, 20)];
    la.backgroundColor =[UIColor whiteColor];
    la.textAlignment =NSTextAlignmentCenter;
    la.font =[UIFont systemFontOfSize:14];
    la.textColor =[UIColor blackColor];
    la.text =tits[tag];
    [views addSubview:la];

}

-(void)sharaButton:(UIButton*)sender
{

    NSInteger j =sender.tag -2000;
    
    if (strIsEmpty(shareUrl)==1) {
        
        shareUrl = @"http://www.daqsoft.com";
    }
    
    
    //构造分享内容
    id<ISSContent> publishContent = [ShareSDK content:@"想说点什么吗？"
                                       defaultContent:[NSString stringWithFormat:@" %@", theme]
                                                image:[ShareSDK imageWithUrl:imagUrl]
                                                title:theme
                                                  url:shareUrl
                                          description:designation
                                            mediaType:SSPublishContentMediaTypeNews];
    
    if (j ==0) {
     NSLog(@"新浪微博");

        [ShareSDK shareContent:publishContent
                          type:ShareTypeSinaWeibo
                   authOptions:nil
                  shareOptions:nil
                 statusBarTips:YES
                        result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                            if (state == SSPublishContentStateSuccess)
                            {
                                NSLog(NSLocalizedString(@"TEXT_SHARE_SUC", @"发表成功"));
                                [self.view makeToast:@"分享成功"];
                                [self success];
                            }
                            else if (state == SSPublishContentStateFail)
                            {
                                NSLog(NSLocalizedString(@"TEXT_SHARE_FAI", @"发布失败!error code == %d, error code == %@"), [error errorCode], [error errorDescription]);
                                [self.view makeToast:@"分享失败"];

                                
                            }
                            
                        }];
        
        
    }else if (j ==1){
        
        NSLog(@"QQ空间");
        
        [ShareSDK shareContent:publishContent
                          type:ShareTypeQQSpace
                   authOptions:nil
                  shareOptions:nil
                 statusBarTips:YES
                        result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                            if (state == SSPublishContentStateSuccess)
                            {
                                NSLog(NSLocalizedString(@"TEXT_SHARE_SUC", @"发表成功"));
                                [self.view makeToast:@"分享成功"];
                                [self success];
                            }
                            else if (state == SSPublishContentStateFail)
                            {
                                NSLog(NSLocalizedString(@"TEXT_SHARE_FAI", @"发布失败!error code == %d, error code == %@"), [error errorCode], [error errorDescription]);
                                [self.view makeToast:@"分享失败"];
                            }
                            
                        }];
        

        


    
    }else if (j ==2){
  
        NSLog(@"微信");
        
        [ShareSDK shareContent:publishContent
                          type:ShareTypeWeixiSession
                   authOptions:nil
                  shareOptions:nil
                 statusBarTips:YES
                        result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                            if (state == SSPublishContentStateSuccess)
                            {
                                NSLog(NSLocalizedString(@"TEXT_SHARE_SUC", @"发表成功"));
                                [self.view makeToast:@"分享成功"];
                                [self success];
                            }
                            else if (state == SSPublishContentStateFail)
                            {
                                NSLog(NSLocalizedString(@"TEXT_SHARE_FAI", @"发布失败!error code == %d, error code == %@"), [error errorCode], [error errorDescription]);
                                [self.view makeToast:@"分享失败"];
                            }
                            
                        }];
        

    }else if (j ==3){
     NSLog(@"朋友圈");
        
        [ShareSDK shareContent:publishContent
                          type:ShareTypeWeixiTimeline
                   authOptions:nil
                  shareOptions:nil
                 statusBarTips:YES
                        result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                            if (state == SSPublishContentStateSuccess)
                            {
                                NSLog(NSLocalizedString(@"TEXT_SHARE_SUC", @"发表成功"));
                                [self.view makeToast:@"分享成功"];
                                [self success];
                            }
                            else if (state == SSPublishContentStateFail)
                            {
                                NSLog(NSLocalizedString(@"TEXT_SHARE_FAI", @"发布失败!error code == %d, error code == %@"), [error errorCode], [error errorDescription]);
                                [self.view makeToast:@"分享失败"];
                            }
                            
                        }];
        

        
    }
}

-(void)shareSuccess:(shareSuccess)es;
{
    self.shareBlok =es;
    

}
-(void)success
{
    
    [[BaiduMobStat defaultStat] logEvent:@"btn_share" eventLabel:@"分享"];
    
    if (self.shareBlok) {
        
        self.shareBlok();
    }

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
