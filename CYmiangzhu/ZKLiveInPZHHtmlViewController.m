//
//  ZKLiveInPZHHtmlViewController.m
//  CYmiangzhu
//
//  Created by 汤亮 on 15/12/28.
//  Copyright © 2015年 WangXiaoLa. All rights reserved.
//

#import "ZKLiveInPZHHtmlViewController.h"
#import "ZKcarrierViewController.h"
#import "MONActivityIndicatorView.h"
#import <JavaScriptCore/JavaScriptCore.h>

@interface ZKLiveInPZHHtmlViewController () <MONActivityIndicatorViewDelegate, UIWebViewDelegate>
@property (nonatomic, weak) UIWebView *webView;
@property (nonatomic, weak) UIImageView *errorImageView;
@property (nonatomic, weak) MONActivityIndicatorView *loadingPromptView;

//请求参数
@property (nonatomic, strong) NSMutableDictionary *params;
//请求到的数据
@property (nonatomic, strong) NSMutableDictionary *contents;
//已经请求到的数据个数
@property (atomic, strong) NSNumber *dataCount;
@end

@implementation ZKLiveInPZHHtmlViewController
- (NSMutableDictionary *)contents
{
    if (_contents == nil) {
        _contents = [NSMutableDictionary dictionary];
    }
    return _contents;
}

- (NSMutableDictionary *)params
{
    if (_params == nil) {
        _params = [NSMutableDictionary dictionary];
        _params[@"method"] = @"getChannelBycode";
        _params[@"seccode"] = @"9C1438BE6CF68E52E0B20C6C4259C250F6913438DABE0219";
    }
    return _params;
}

-(MONActivityIndicatorView *)loadingPromptView
{
    if (_loadingPromptView == nil) {
        MONActivityIndicatorView *loadingPromptView = [[MONActivityIndicatorView alloc] init];
        loadingPromptView.delegate = self;
        loadingPromptView.numberOfCircles = 4;
        loadingPromptView.radius = 10;
        loadingPromptView.internalSpacing = 5;
        loadingPromptView.center = self.webView.center;
        [self.view addSubview:loadingPromptView];
        self.loadingPromptView = loadingPromptView;
    }
    return _loadingPromptView;
}

- (UIImageView *)errorImageView
{
    if (_errorImageView == nil) {
        UIImageView *errorImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"html_error"]];
        errorImageView.bounds = CGRectMake(0, 0, 100, 100);
        errorImageView.center = CGPointMake(self.webView.frame.size.width / 2, self.webView.frame.size.height / 2);
        [self.webView addSubview:errorImageView];
        self.errorImageView = errorImageView;
    }
    return _errorImageView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureBase];
    [self setupWebView];
    [self loadData];
    [[BaiduMobStat defaultStat] logEvent:@"search_health_in_pzh" eventLabel:@"分类-康养在攀枝花"];
}

- (void)configureBase
{
    self.titeLabel.text = @"康养在攀枝花";
    
    [self addObserver:self forKeyPath:@"dataCount" options:NSKeyValueObservingOptionNew context:nil];
    
    if (self.isBanSwipeToReturn) {
        //禁用滑动返回
        if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
            self.navigationController.interactivePopGestureRecognizer.enabled = NO;
        }
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"dataCount"]) {
        NSString *dataCount = change[NSKeyValueChangeNewKey];
        if (dataCount.intValue == 2) {
            [self loadHtml];
        }
    }
}

- (void)loadData
{
    [self.loadingPromptView startAnimating];
    
    NSArray *channels = @[@"liudu", @"kyss"];
    
    for (NSString *channel in channels) {
        self.params[@"channel"] = channel;
        
        [ZKHttp post:postUrlPrefix params:self.params success:^(id responseObj) {
            NSString *content = [responseObj[@"content"] stringByReplacingOccurrencesOfString:@"\\" withString:@"\\\\"];
            [self.contents setObject:content forKey:channel];
            self.dataCount = @(self.dataCount.intValue + 1);
        } failure:^(NSError *error) {
            [self.loadingPromptView stopAnimating];
            self.errorImageView.hidden = NO;
        }];
    }
}

- (void)loadHtml
{
    NSURL *URL = [[NSBundle mainBundle] URLForResource:@"kyzpzh" withExtension:@"html"];
    [self.webView loadRequest:[NSURLRequest requestWithURL:URL]];
}

- (void)setupWebView
{
    UIWebView * webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, navigationHeghit, self.view.bounds.size.width, TabelHeghit)];
    webView.backgroundColor = [UIColor whiteColor];
    webView.opaque = NO;
    webView.dataDetectorTypes = UIDataDetectorTypeNone;
    webView.delegate = self;
    [self.view addSubview:webView];
    self.webView = webView;
    
    __weak typeof(self) weakSelf = self;
    JSContext *context = [self.webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    context[@"jsCalliOS"] = ^(NSString *identifier) {
        
        return weakSelf.contents[identifier];
    };
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self.loadingPromptView stopAnimating];
    self.errorImageView.hidden = YES;

    [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitUserSelect='none';"];
    [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitTouchCallout='none';"];
}

- (UIColor *)activityIndicatorView:(MONActivityIndicatorView *)activityIndicatorView circleBackgroundColorAtIndex:(NSUInteger)index
{
    CGFloat red   = (arc4random() % 256)/255.0;
    CGFloat green = (arc4random() % 256)/255.0;
    CGFloat blue  = (arc4random() % 256)/255.0;
    CGFloat alpha = 1.0f;
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

- (void)dealloc
{
    [self removeObserver:self forKeyPath:@"dataCount"];
}


/**
 *  覆盖父类的返回方法
 */
- (void)back {
    
    if (self.isBanSwipeToReturn) {
        ZKcarrierViewController *hom =[[ZKcarrierViewController alloc]init];
        UINavigationController *nav =[[UINavigationController alloc]initWithRootViewController:hom];
        nav.navigationBarHidden =YES;
        [[UIApplication sharedApplication].delegate window].rootViewController = nav;
    }else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}


@end
