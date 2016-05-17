//
//  ZKEventQueryListViewController.m
//  CYmiangzhu
//
//  Created by 王小腊 on 16/5/17.
//  Copyright © 2016年 WangXiaoLa. All rights reserved.
//

#import "ZKEventQueryListViewController.h"
#import "ZKEventQueryStateMode.h"

//cell
#import "ZKEventQueryListThreeCell.h"
#import "ZKEventQueryListOneCell.h"
#import "ZKEventQueryListTwoCell.h"

#import "ZKEventQueryDetailsMode.h"

@interface ZKEventQueryListViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) ZKEventQueryStateMode *list;
@property (nonatomic, strong) ZKEventQueryDetailsMode *dataList;
@property (nonatomic, strong) UIImageView *errDataView;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation ZKEventQueryListViewController

- (instancetype)initData:(ZKEventQueryStateMode*)mode;
{
    self = [super init];
    if (self) {
        
        self.list = mode;
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
        
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.tableFooterView = [[UIView alloc] init];
        _tableView.dataSource = self;
        _tableView.delegate   = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.separatorInset = UIEdgeInsetsZero;
        _tableView.estimatedRowHeight = 100;
        _tableView.backgroundColor = YJCorl(249, 249, 249);
        
        [_tableView registerNib:[UINib nibWithNibName:@"ZKEventQueryListThreeCell" bundle:nil] forCellReuseIdentifier:ZKEventQueryListThreeCellID];
        [_tableView registerNib:[UINib nibWithNibName:@"ZKEventQueryListOneCell" bundle:nil] forCellReuseIdentifier:ZKEventQueryListOneCellID];
        [_tableView registerNib:[UINib nibWithNibName:@"ZKEventQueryListTwoCell" bundle:nil] forCellReuseIdentifier:ZKEventQueryListTwoCellID];
        
    }
    return _tableView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"事件详情";
    [self.view addSubview:self.tableView];
    
    _tableView.tableFooterView = [self cjFooterView];;
}

- (void)postData
{
    NSMutableDictionary *pic = [NSMutableDictionary dictionary];
    
    [ZKHttp Post:@"" params:pic success:^(id responseObj) {
        
        NSMutableArray <ZKEventQueryDetailsMode*>*dataArray = [ZKEventQueryDetailsMode objectArrayWithKeyValuesArray:responseObj[@"rows"]];
        
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
    UIButton *tsBtton =[[UIButton alloc]initWithFrame:CGRectMake(20, 20, kDeviceWidth-40, 34)];
    tsBtton.layer.masksToBounds =YES;
    tsBtton.layer.cornerRadius =8;
    tsBtton.backgroundColor = [UIColor orangeColor];
    [tsBtton setTitle:@"取消上报" forState:UIControlStateNormal];
    tsBtton.titleLabel.font =[UIFont systemFontOfSize:14];
    [tsBtton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [tsBtton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [tsBtton addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:tsBtton];
    
    return footerView;
}


#pragma mark tableView 代理

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    if (section == 2) {
        
        return 4;
    }
    else
    {
        return 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (indexPath.section == 0) {
        
        return UITableViewAutomaticDimension;
    }
    else if (indexPath.section == 1)
    {
        return 148;
    }
    else
    {
    
        return 44;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
   
    return 5;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{

    if (section == 2) {
        
        return 44;
    }
    else
    {
        return 5;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 2) {
        
        UIView *views = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 44)];
        views.backgroundColor = [UIColor whiteColor];
        
        UIImageView *lefImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, 15, 14, 14)];
        lefImage.image = [UIImage imageNamed:@"after"];
        [views addSubview:lefImage];

        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(34, 12, 80, 20)];
        label.font = [UIFont systemFontOfSize:14];
        label.textColor = [UIColor blackColor];
        label.text = @"事件跟踪";
        [views addSubview:label];
        
        UIView*lin = [[UIView alloc] initWithFrame:CGRectMake(8, 43, kDeviceWidth-8, 0.6)];
        lin.backgroundColor = [UIColor lightGrayColor];
        [views addSubview:lin];

        return views;
    }
    else
    {
    
        return [[UIView alloc] init];
    
    }
    
}
- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [[UIView alloc] init];
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    UITableViewCell *cell;
    if (indexPath.section == 0) {
        
        ZKEventQueryListOneCell *oneCell = [tableView dequeueReusableCellWithIdentifier:ZKEventQueryListOneCellID];
        oneCell.list = self.dataList;
        cell = oneCell;
        
    }
   else if (indexPath.section == 1)
   {
   
       ZKEventQueryListTwoCell * twoCell = [tableView dequeueReusableCellWithIdentifier:ZKEventQueryListTwoCellID];
        twoCell.list = self.dataList;
       cell = twoCell;
   }
    else
    {
        ZKEventQueryListThreeCell * threeCell = [tableView dequeueReusableCellWithIdentifier:ZKEventQueryListThreeCellID];
        [threeCell updata:self.dataList select:indexPath.row];
        cell = threeCell;
    
    }

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

#pragma mark button
- (void)cancelClick
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
