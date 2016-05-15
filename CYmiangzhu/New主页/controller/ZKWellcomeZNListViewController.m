//
//  ZKWellcomeZNListViewController.m
//  CYmiangzhu
//
//  Created by 王小腊 on 16/5/13.
//  Copyright © 2016年 WangXiaoLa. All rights reserved.
//

#import "ZKWellcomeZNListViewController.h"
#import "ZKWellcomeZNMode.h"
#import "MONActivityIndicatorView.h"
@interface ZKWellcomeZNListViewController ()<UIWebViewDelegate>

@property (nonatomic, strong) ZKWellcomeZNMode *list;
@property (nonatomic, strong) UIImageView *errDataView;
@property (nonatomic, strong) UIWebView *contenWebView;
@property (nonatomic, strong) MONActivityIndicatorView * activityView;
@end

@implementation ZKWellcomeZNListViewController

- (instancetype)initData:(ZKWellcomeZNMode*)data;
{
    self = [super init];
    if (self) {
        
        self.list = data;
    }

    return self;
}

- (UIImageView *)errDataView
{

    if (!_errDataView) {
        
        _errDataView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"errData"]];
        CGSize t = _errDataView.frame.size;
        _errDataView.frame =CGRectMake((self.contenWebView.frame.size.width-t.width)/2, (self.contenWebView.frame.size.height-t.height)/2, t.width, t.height);
        _errDataView.userInteractionEnabled =YES;
        
        UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(loadNewData)];
        [_errDataView addGestureRecognizer:tapGr];
        
       [self.contenWebView addSubview:_errDataView];
    }
    
    return _errDataView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"康养指南详情";

    _contenWebView =[[UIWebView alloc]initWithFrame:self.view.bounds];
    _contenWebView.backgroundColor =[UIColor whiteColor];
    _contenWebView.opaque = NO;
    _contenWebView.delegate = self;
    _contenWebView.scrollView.scrollEnabled =YES;
    _contenWebView.contentScaleFactor =1;
    [self.view addSubview:_contenWebView];

    _activityView = [[MONActivityIndicatorView alloc] init];
    _activityView.numberOfCircles = 4;
    _activityView.radius = 10;
    _activityView.internalSpacing = 5;
    _activityView.center =self.view.center;
    [self.view addSubview:_activityView];



    [self loadNewData];
}
#pragma mark 数据请求

- (void)loadNewData
{
    self.errDataView.hidden = YES;
    __weak typeof(self)selfWeek = self;
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [_activityView stopAnimating];
    [ZKHttp Post:@"" params:dic success:^(id responseObj) {
        [_activityView stopAnimating];
        
        [selfWeek.contenWebView loadHTMLString:@"" baseURL:nil];
        
    } failure:^(NSError *error) {
        [_activityView stopAnimating];
        selfWeek.errDataView.hidden = NO;
    }];

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
