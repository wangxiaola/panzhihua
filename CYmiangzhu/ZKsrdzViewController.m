//
//  ZKsrdzViewController.m
//  CYmiangzhu
//
//  Created by Daqsoft-Mac on 15/10/28.
//  Copyright © 2015年 WangXiaoLa. All rights reserved.
//

#import "ZKsrdzViewController.h"
#import "ZKBasicViewController.h"
#import "ZKregisterViewController.h"
@interface ZKsrdzViewController ()

@end

@implementation ZKsrdzViewController

-(id)init;
{
    self =[super init];
    if (self) {
        
//        self.hidesBottomBarWhenPushed =YES;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.navigationBarView removeFromSuperview];
    
//    self.leftBarButtonItem = [[UIButton alloc]initWithFrame:CGRectMake(2, 20, buttonItemWidth, buttonItemWidth)];
//    [self.leftBarButtonItem setImage:[UIImage imageNamed:@"backimage_white"] forState:UIControlStateNormal];
//    self.leftBarButtonItem.backgroundColor =[UIColor clearColor];
//    [self.leftBarButtonItem addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
//    [self.view  addSubview:self.leftBarButtonItem];
    
}

//-(void)back
//{
//    
//    [self.navigationController popViewControllerAnimated:YES];
//    
//}

- (IBAction)zdyButton:(UIButton *)sender {
    
   
    
    if ([ZKUserInfo sharedZKUserInfo].ID == nil) {
        
  
        ZKregisterViewController *reg =[[ZKregisterViewController alloc]init];
        reg.isMy =YES;
        reg.view.backgroundColor =[UIColor orangeColor];
        reg.updateAlertBlock = ^() {
            
            NSLog(@"调用了block");
            
        };
        
        UINavigationController *nav =[[UINavigationController alloc]initWithRootViewController:reg];
        nav.navigationBarHidden =YES;
        [self presentViewController:nav animated:YES completion:^{
            
        }];

        
    }else{
        
     NSInteger dex =sender.tag-2000;
        
        if (dex ==0) {
            
            
            
            [self jumpToWebUrl:webUrl1(@"s_customsindex.aspx?&z_pagetitle=自定义行程")]
            ;
            [[BaiduMobStat defaultStat] logEvent:@"self_diy" eventLabel:@"自定义行程"];
            
        }
        if (dex ==1) {
            
            [self jumpToWebUrl:webUrl1(@"s_customs.aspx?&z_pagetitle=私人定制")];
            [[BaiduMobStat defaultStat] logEvent:@"self_made" eventLabel:@"定制行程"];
        }
        
        if (dex ==2) {
            
             [self jumpToWebUrl:webUrl1(@"s_mydz.aspx?&z_pagetitle=我的定制")];
            [[BaiduMobStat defaultStat] logEvent:@"self_custom_made" eventLabel:@"我的定制"];
        }
    
      
        
    }


    
}


- (void)jumpToWebUrl:(NSString *)webUrl
{
    ZKBasicViewController *web = [[ZKBasicViewController alloc] init];
    web.webToUrl = [webUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    web.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:web animated:YES];
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
