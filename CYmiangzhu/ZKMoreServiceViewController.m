//
//  ZKMoreServiceViewController.m
//  CYmiangzhu
//
//  Created by Daqsoft-Mac on 15/8/17.
//  Copyright (c) 2015年 WangXiaoLa. All rights reserved.
//

#import "ZKMoreServiceViewController.h"
#import "ZKAppDelegate.h"


@interface ZKMoreServiceViewController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tabel;

@property (nonatomic, strong) NSArray  *dataArray;

@end

@implementation ZKMoreServiceViewController


- (UITableView *)tabel
{

    if (!_tabel) {
        
        _tabel = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, kDeviceWidth, kDeviceHeight-64) style:UITableViewStylePlain];
        _tabel.delegate = self;
        _tabel.dataSource = self;
        _tabel.tableFooterView = [UIView new];
        _tabel.estimatedRowHeight = 44;
    }
    
    return _tabel;
}

- (id)init
{
    
    self =[super init];
    
    if (self) {
        self.hidesBottomBarWhenPushed =YES;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.titeLabel.text =@"咨询服务";
    self.rittBarButtonItem =[[UIButton alloc]initWithFrame:CGRectMake(kDeviceWidth-2-40, 20, 40, 40)];
    self.rittBarButtonItem.backgroundColor =[UIColor clearColor];
    self.rittBarButtonItem.titleLabel.textColor =[UIColor whiteColor];
    self.rittBarButtonItem.titleLabel.font =[UIFont systemFontOfSize:12];
    self.rittBarButtonItem.titleLabel.font =[UIFont boldSystemFontOfSize:12];
    [self.rittBarButtonItem setImage:[UIImage imageNamed:@"hom"] forState:UIControlStateNormal];
    [self.rittBarButtonItem addTarget:self action:@selector(homClick) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationBarView addSubview: self.rittBarButtonItem];
    
    [self.view addSubview:self.tabel];
    
    [self postDate];
    
}

#pragma mark 数据请求
- (void)postDate
{
   [SVProgressHUD show];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:@"helpphone" forKey:@"method"];
    [dic setObject:@"json" forKey:@"format"];
    
    [ZKHttp Post:@"" params:dic success:^(id responseObj) {
        
        self.dataArray = [responseObj valueForKey:@"rows"];

        if (_dataArray.count > 0 ) {
            
            [self.tabel reloadData];
        }
        
        [SVProgressHUD dismiss];
        
    } failure:^(NSError *error) {
        
        [SVProgressHUD dismissWithError:@"网络错误!"];
    }];

    
}
#pragma mark tabel  代理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return self.dataArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 1;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        
    }

    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.dataArray.count > 0 ) {
        
        NSDictionary *dic = self.dataArray [indexPath .section];
        cell.textLabel.text = [NSString stringWithFormat:@"%@: %@",[dic valueForKey:@"name"],[dic valueForKey:@"phone"]];
    }
    
    cell.textLabel.font = [UIFont systemFontOfSize:13];
    cell.textLabel.textColor = CYBColorGreen;
    cell.accessoryView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"detail_call"]];


}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 44;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0.01;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{

    return 6;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    if (self.dataArray.count > 0 ) {
        
        NSDictionary *dic = self.dataArray [indexPath .section];
        
        NSString *str = [dic valueForKey:@"phone"];
        
        NSMutableString * str_0=[[NSMutableString alloc] initWithFormat:@"tel:%@",[str stringByReplacingOccurrencesOfString:@"—" withString:@""]];
        
        UIWebView * callWebview = [[UIWebView alloc] init];
        [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str_0]]];
        [[APPDELEGATE window] addSubview:callWebview];
        
    }

    
}

#pragma mark 点击事件
- (void)homClick
{
    self.tabBarController.selectedIndex =0;
}


@end
