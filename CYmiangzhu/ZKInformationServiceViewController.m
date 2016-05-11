//
//  ZKInformationServiceViewController.m
//  CYmiangzhu
//
//  Created by Daqsoft-Mac on 15/8/17.
//  Copyright (c) 2015年 WangXiaoLa. All rights reserved.
//

#import "ZKInformationServiceViewController.h"

@interface ZKInformationServiceViewController ()
- (IBAction)callToShiLvYouJu;

- (IBAction)callToDongQuLvYouJu;
- (IBAction)callToRenHeLvYouJu;

@end

@implementation ZKInformationServiceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)callWithNumber:(NSString *)number{
    
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",number];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];

    
}

- (IBAction)callToShiLvYouJu {
    //0812-3335706
    [self callWithNumber:@"08123335706"];
}

- (IBAction)callToDongQuLvYouJu {
    //0812-2228145
    
    [self callWithNumber:@"08122228145"];
}

- (IBAction)callToRenHeLvYouJu {
    //0812-2900261
    
    [self callWithNumber:@"08122900261"];
}
@end
