//
//  ZKOrderDetailsViewController.m
//  CYmiangzhu
//
//  Created by 王小腊 on 16/5/17.
//  Copyright © 2016年 WangXiaoLa. All rights reserved.
//

#import "ZKOrderDetailsViewController.h"
#import "ZKmyOrdeMode.h"
#import "ZKOrderDetailsMode.h"

#import "ZKOrderDetailsDDCell.h"
#import "ZKOrderDetailsSpJdCell.h"
#import "ZKOrderDetailsSPCell.h"
#import "ZKOrderDetailsQPCell.h"

@interface ZKOrderDetailsViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong)ZKmyOrdeMode *listData;
@property (nonatomic, strong) ZKOrderDetailsMode *dataList;
@property (nonatomic, strong) UIImageView *errDataView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *lefTitisArray;
@property (nonatomic, assign) NSInteger type;
@end

@implementation ZKOrderDetailsViewController

- (instancetype)initData:(ZKmyOrdeMode*)data;
{
    self = [super init];
    if (self) {
        
        self.listData = data;
    }
    
    return self;
}

- (UIImageView *)errDataView
{
    
    if (_errDataView == nil) {
        UIImageView *emptyDataView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"errData"]];
        CGSize t = emptyDataView.frame.size;
        emptyDataView.frame =CGRectMake((self.view.frame.size.width-t.width)/2, (self.view.frame.size.height-t.height)/2, t.width, t.height);
        emptyDataView.userInteractionEnabled =YES;
        [self.view addSubview:emptyDataView];
        self.errDataView = emptyDataView;
        UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(postData)];
        [emptyDataView addGestureRecognizer:tapGr];
        
    }
    return _errDataView;
}

- (UITableView *)tableView
{
    if (!_tableView) {
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kDeviceWidth, kDeviceHeight - 64) style:UITableViewStylePlain];
        _tableView.tableFooterView = [[UIView alloc] init];
        _tableView.dataSource = self;
        _tableView.delegate   = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableView.separatorInset = UIEdgeInsetsZero;
        _tableView.estimatedRowHeight = 100;
        _tableView.backgroundColor = YJCorl(249, 249, 249);
        
        [_tableView registerNib:[UINib nibWithNibName:@"ZKOrderDetailsDDCell" bundle:nil] forCellReuseIdentifier:ZKOrderDetailsDDCellID];
        [_tableView registerNib:[UINib nibWithNibName:@"ZKOrderDetailsQPCell" bundle:nil] forCellReuseIdentifier:ZKOrderDetailsQPCellID];
        
        [_tableView registerNib:[UINib nibWithNibName:@"ZKOrderDetailsSpJdCell" bundle:nil] forCellReuseIdentifier:ZKOrderDetailsSpJdCellID];
        [_tableView registerNib:[UINib nibWithNibName:@"ZKOrderDetailsSPCell" bundle:nil] forCellReuseIdentifier:ZKOrderDetailsSPCellID];
        
        
    }
    return _tableView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.titeLabel.text = @"订单详情";
    self.lefTitisArray = @[@"订单信息",@"商品信息",@"取票信息"];
    self.type =  (arc4random() % 2) + 1;

    
    [self.view addSubview:self.tableView];
    self.tableView.tableFooterView = [self cjFooterView];
    
}

- (void)postData
{
    NSMutableDictionary *pic = [NSMutableDictionary dictionary];
    
    [ZKHttp Post:@"" params:pic success:^(id responseObj) {
        
        NSMutableArray <ZKOrderDetailsMode*>*dataArray = [ZKOrderDetailsMode objectArrayWithKeyValuesArray:responseObj[@"rows"]];
        
        [self.tableView reloadData];
        
        //根据数据个数判断是否要显示提示没有数据的图片
        self.errDataView.hidden = dataArray.count > 0;
        
    } failure:^(NSError *error) {
        
        self.errDataView.hidden = NO;
        [SVProgressHUD showErrorWithStatus:@"网络连接错误！" duration:1];
        
    }];
    
    
    
}

- (UIView*)cjFooterView
{
    
    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, 120)];
    footerView.backgroundColor = YJCorl(249, 249, 249);
    
    UIButton *dhBtton =[[UIButton alloc]initWithFrame:CGRectMake(10, 10, kDeviceWidth-20, 34)];
    dhBtton.layer.masksToBounds =YES;
    dhBtton.layer.cornerRadius = 4;
    dhBtton.backgroundColor = [UIColor whiteColor];
    [dhBtton setTitle:@"导 航" forState:UIControlStateNormal];
    dhBtton.titleLabel.font =[UIFont systemFontOfSize:14];
    [dhBtton setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    dhBtton.tag = 1000;
    [dhBtton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:dhBtton];
    
    UIButton *kfBtton =[[UIButton alloc]initWithFrame:CGRectMake(10, 54, kDeviceWidth-20, 34)];
    kfBtton.layer.masksToBounds =YES;
    kfBtton.layer.cornerRadius = 4;
    kfBtton.backgroundColor = [UIColor whiteColor];
    [kfBtton setTitle:@"客服电话" forState:UIControlStateNormal];
    kfBtton.titleLabel.font =[UIFont systemFontOfSize:14];
    [kfBtton setTitleColor:CYBColorGreen forState:UIControlStateNormal];
    kfBtton.tag = 1001;
    [kfBtton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:kfBtton];

    return footerView;
}


#pragma mark tableView 代理

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row == 0)
    {
        
        return 44;
    }
    else
    {
        return UITableViewAutomaticDimension;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{

    return 8;
    
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    return [[UIView alloc] init];
        
    
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell;

    
    if (indexPath.row == 0)
    {
        static NSString *indentfier = @"cell";
        UITableViewCell *oneCell = [tableView dequeueReusableCellWithIdentifier:indentfier];
        if (!oneCell) {
            
            oneCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:indentfier];
        }
        oneCell.textLabel.font = [UIFont systemFontOfSize:14];
        oneCell.textLabel.textColor = [UIColor blackColor];
        oneCell.textLabel.text = self.lefTitisArray[indexPath.section];
        if (indexPath.section == 0) {
            
            oneCell.detailTextLabel.text = @"订单状态";
            oneCell.detailTextLabel.font = [UIFont systemFontOfSize:14];
            oneCell.detailTextLabel.textColor = [UIColor orangeColor];
        }
        cell = oneCell;
        
    }
    else
    {
    
        if (indexPath.section == 0) {
            
            ZKOrderDetailsDDCell *ddCell = [tableView dequeueReusableCellWithIdentifier:ZKOrderDetailsDDCellID];
            cell = ddCell;
        }
        else if (indexPath.section == 1)
        {
            
            if (self.type == 1) {
                //酒店
                 ZKOrderDetailsSpJdCell *spjdCell = [tableView dequeueReusableCellWithIdentifier:ZKOrderDetailsSpJdCellID];
                cell = spjdCell;
            }
            else
            {
                 ZKOrderDetailsSPCell *spCell = [tableView dequeueReusableCellWithIdentifier:ZKOrderDetailsSPCellID];
                cell = spCell;
            }
     
        }
        else
        {
        
            ZKOrderDetailsQPCell *qpCell = [tableView dequeueReusableCellWithIdentifier:ZKOrderDetailsQPCellID];
            cell = qpCell;
        }
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

#pragma mark button
- (void)buttonClick:(UIButton*)sender
{
    
    NSMutableDictionary *pic = [NSMutableDictionary dictionary];
    
    [ZKHttp Post:@"" params:pic success:^(id responseObj) {
        
        
    } failure:^(NSError *error) {
        
        [SVProgressHUD showErrorWithStatus:@"网络连接错误！" duration:1];
        
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
