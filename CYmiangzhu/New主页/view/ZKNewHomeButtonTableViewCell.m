//
//  ZKNewHomeButtonTableViewCell.m
//  CYmiangzhu
//
//  Created by 王小腊 on 16/5/12.
//  Copyright © 2016年 WangXiaoLa. All rights reserved.
//

#import "ZKNewHomeButtonTableViewCell.h"
#import "ZKnavMapViewController.h"

NSString *const ZKNewHomeButtonTableViewCellID = @"ZKNewHomeButtonTableViewCellID";

@implementation ZKNewHomeButtonTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.centerLin.constant = 0.5;
    self.ritLin.constant = 0.5;
    self.lefLin.constant = 0.5;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)newHomeButtonClick:(UIButton *)sender {
    
    
    NSInteger index = sender.tag - 1000;
    
    if (index == 0)
    {
        
        
        
    }
    else if (index == 1)
    {
        /*** 自驾 ***/
        [[BaiduMobStat defaultStat] logEvent:@"home_go_road" eventLabel:@"首页-线路 "];
        [self jumpToWebUrl:webUrl1(@"zjy/index.html")];
        
    
    }
    else if (index == 2)
    {
        
        /*** 720全景 ***/
        [[BaiduMobStat defaultStat] logEvent:@"home_go_720" eventLabel:@"首页-全景 "];
        //        [self jumpToWebUrl:webUrl(@"_720.aspx?setnew_head_search_jqjd=true")];
        [self.controller navigationController].navigationBarHidden = YES;
        [[self.controller navigationController] pushViewController:[[NSClassFromString(@"ZK720ScenicViewController") alloc]init] animated:YES];
    }
    else if (index == 3)
    {
        
        /*** 找旅行社 ***/
        
        [[BaiduMobStat defaultStat] logEvent:@"home_go_agency" eventLabel:@"首页-找旅行社"];
        ZKnavMapViewController *map = [[ZKnavMapViewController alloc] init];
        [self.controller navigationController].navigationBarHidden = YES;
        [[self.controller navigationController] pushViewController:map animated:YES];
    }
    else if (index == 4)
    {
        /*** 行程参考 ***/
        [self jumpToWebUrl:webUrl(@"trip.aspx?z_pagetitle=行程参考")];
        //[self.navigationController pushViewController:[[NSClassFromString(@"ZKTripViewController") alloc]init] animated:YES];
        
    }
    else if (index == 5)
    {
        
        /*** 旅游季节 ***/
        [[BaiduMobStat defaultStat] logEvent:@"home_go_season" eventLabel:@"首页-季节"];
        [self.controller navigationController].navigationBarHidden = YES;
        [[self.controller navigationController] pushViewController:[[NSClassFromString(@"ZKTheTouristSeasonViewController") alloc]init]  animated:YES];
    }

    
}


- (void)jumpToWebUrl:(NSString *)webUrl
{
    
    ZKBasicViewController *web = [[ZKBasicViewController alloc] init];
    web.webToUrl = [webUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    web.hidesBottomBarWhenPushed = YES;
    [self.controller navigationController].navigationBarHidden = YES;
    [[self.controller navigationController] pushViewController:web animated:YES];
}

@end
