//
//  DQSuperViewController.m
//  ChangYouYiBin
//
//  Created by Daqsoft-Mac on 14/11/26.
//  Copyright (c) 2014年 StrongCoder. All rights reserved.
//

#import "ZKBaseTableViewController.h"

@interface ZKBaseTableViewController ()<UIScrollViewDelegate>
{
    
    UIView *viewHT;

}
@end

@implementation ZKBaseTableViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.backgroundColor =YJCorl(249, 249, 249);
    
    self.tableView.contentInset = UIEdgeInsetsMake(30, 0, 0, 0);
    
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gesture)];
//    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(gesture)];
//    [self.tableView addGestureRecognizer:tap];
//    [self.tableView addGestureRecognizer:pan];

    
//    self.tableView.scrollEnabled = NO;
    
    self.navigationBarView = [[UIView alloc] initWithFrame:CGRectMake(0, -50, self.tableView.frame.size.width,navHeight+1)];
    self.navigationBarView.backgroundColor = viewsBackCorl;
    [self.view addSubview:self.navigationBarView];
    self.navigationBarView.layer.borderColor =YJCorl(231, 231, 231).CGColor;
    self.navigationBarView.layer.borderWidth =0.4;
    
    self.leftBarButtonItem = [[UIButton alloc]initWithFrame:CGRectMake(2, 20, buttonItemWidth, buttonItemWidth)];
    [self.leftBarButtonItem setImage:[UIImage imageNamed:@"backimage"] forState:UIControlStateNormal];
    self.leftBarButtonItem.backgroundColor =[UIColor clearColor];
    [self.leftBarButtonItem addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    
    
    self.titeLabel = [[UILabel alloc]initWithFrame:CGRectMake(40, 8, self.tableView.frame.size.width-80, navigationHeghit)];
    self.titeLabel.font =[UIFont systemFontOfSize:20];
    self.titeLabel.font =[UIFont boldSystemFontOfSize:20];
    self.titeLabel.textColor =CYBColorGreen;
    self.titeLabel.textAlignment =NSTextAlignmentCenter;
    self.titeLabel.backgroundColor =[UIColor clearColor];
    
    [self.navigationBarView  addSubview:self.titeLabel];
    [self.navigationBarView  addSubview:self.leftBarButtonItem];
    
    
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        
        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
        
    }
    
    [self.navigationItem setHidesBackButton:YES];
    
    
}


- (void)gesture
{
    [self.tableView endEditing:YES];

}

-(void)back
{
    [self.navigationBarView removeFromSuperview];
    [self.navigationController popViewControllerAnimated:YES];
    
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    self.navigationBarView.y = scrollView.contentOffset.y;

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
