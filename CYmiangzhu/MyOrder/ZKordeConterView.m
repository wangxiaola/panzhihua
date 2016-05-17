//
//  ZKordeConterView.m
//  CYmiangzhu
//
//  Created by 王小腊 on 15/12/11.
//  Copyright © 2015年 WangXiaoLa. All rights reserved.
//

#import "ZKordeConterView.h"
#import "MJRefresh.h"
#import "ZKmyOrdeMode.h"
#import "ZKOrderPaymentViewController.h"
#import "ZKMoreReminderView.h"

#import "ZKOrderDetailsViewController.h"

#import "Order.h"
#import "DataSigner.h"
#import <AlipaySDK/AlipaySDK.h>

#import "APAuthV2Info.h"

@implementation ZKordeConterView

@synthesize page;
@synthesize type;

-(id)initWithFrame:(CGRect)frame type:(NSString*)str;

{
    
    self =[super initWithFrame:frame];
    
    if (self) {
        type =str;
        [self initView];
        [self.tableView.mj_header beginRefreshing];
    }
    
    return self;
    
}

-(void)initView
{
    NSInteger bdType = type.integerValue;
    
    switch (bdType) {
        case 0:
            [[BaiduMobStat defaultStat] logEvent:@"order_staypay" eventLabel:@"待付款"];
            break;
        case 1:
            [[BaiduMobStat defaultStat] logEvent:@"order_notUse" eventLabel:@"未使用"];
            break;
        case 2:
            [[BaiduMobStat defaultStat] logEvent:@"order_complete" eventLabel:@"完成交易"];
            break;
        case 3:
            [[BaiduMobStat defaultStat] logEvent:@"order_refund" eventLabel:@"退款单"];
            break;
            
        default:
            break;
    }
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,0, self.bounds.size.width, self.bounds.size.height) style:UITableViewStylePlain];
    _tableView.separatorStyle = NO;
    _tableView.backgroundColor = YJCorl(249, 249, 249);
    //去掉plain样式下多余的分割线
    _tableView.tableFooterView = [[UIView alloc] init];
    //设置分割线左边无边距，默认是15
    _tableView.separatorInset = UIEdgeInsetsZero;
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    _tableView.dataSource =self;
    _tableView.delegate =self;
    _tableView.estimatedRowHeight=120; //预估行高 可以提高性能
    _tableView.rowHeight = 120;
    [self addSubview:_tableView];
    
    //注册表格单元
    [self.tableView registerNib:[UINib nibWithNibName:@"ZKOredViewCell" bundle:nil] forCellReuseIdentifier:ZKOredViewCellID];
    
    
}

#pragma mark  -----tabel代理
/*
 返回多少行
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //因为是我们自定义的数据 所以 这里写arr而不是arrModel  因为只有这样才会调用arr的懒加载犯法
    return 1;
}
/*
 返回多少区
 */
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.listData.count;
}
/*
 返回表格单元
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //取出模型
    ZKmyOrdeMode *model=self.listData[indexPath.section];
    
    ZKOredViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ZKOredViewCellID];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.state =type;
    cell.delegate =self;
    //传递模型给cell
    cell.ordeModel=model;
    //    NSLog(@" -- %@",model.img);
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //取出模型
    ZKmyOrdeMode *model=self.listData[indexPath.section];
    ZKOrderDetailsViewController *order = [[ZKOrderDetailsViewController alloc] initData:model];
    [[self.contess navigationController] pushViewController:order animated:YES];
    
}
/*
 *  返回每一个表格单元的高度
 */

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return    120;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 8;
}
-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [[UIView alloc]init];
}

-(void)ZKOredViewCellbutton:(ZKmyOrdeMode*)list;
{
    NSInteger index =self.type.integerValue;
    
    
    if (index ==0) {
        
        if (![ZKUserInfo sharedZKUserInfo].ID) {
            [self makeToast:@"请先登录！"];
            
        }else{
            [[BaiduMobStat defaultStat] logEvent:@"btn_pay" eventLabel:@"付款"];
            /*
             *生成订单信息及签名
             */
            //将商品信息赋予AlixPayOrder的成员变量
            Order *order = [[Order alloc] init];
            order.partner = PARTNER;
            order.seller = SELLER;
            order.tradeNO = list.orderCode; //订单ID（由商家自行制定）
            order.productName = list.name; //商品标题
            order.productDescription = [NSString stringWithFormat:@"%@-总价%@",list.name ,list.total]; //商品描述
            order.amount = list.total; //商品价格
            order.notifyURL =  @"http://pzh.geeker.com.cn/planFrontNotify.jkb"; //回调URL
            
            order.service = @"mobile.securitypay.pay";
            order.paymentType = @"1";
            order.inputCharset = @"utf-8";
            order.itBPay = @"30m";
            order.showUrl = @"m.alipay.com";
            
            //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
            NSString *appScheme = @"CYmiangzhu";
            
            //将商品信息拼接成字符串
            NSString *orderSpec = [order description];
            NSLog(@"orderSpec = %@",orderSpec);
            
            //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
            id<DataSigner> signer = CreateRSADataSigner(PRIVATEKEY);
            NSString *signedString = [signer signString:orderSpec];
            
            //将签名成功字符串格式化为订单字符串,请严格按照该格式
            NSString *orderString = nil;
            if (signedString != nil) {
                orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                               orderSpec, signedString, @"RSA"];
                
                [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
                    
                    NSString *result =[resultDic valueForKey:@"result"];
                    NSLog(@" 支付宝  ＝＝  %@\n",resultDic);
                    
                    if (strIsEmpty(result) ==0) {
                        
                        [SVProgressHUD showSuccessWithStatus:@"支付成功" duration:1.5];
                        
                        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                        [dic setObject:[ZKUtil timeStamp] forKey:@"TimeStamp"];
                        [dic setObject:@"60" forKey:@"interfaceId"];
                        [dic setObject:list.orderCode forKey:@"out_trade_no"];
                        [dic setObject:@"" forKey:@"trade_no"];
                        
                        [ZKHttp post:universalServerUrl params:dic success:^(id responseObj) {
                            NSLog(@"服务器 == %@\n",responseObj);
                            [self loadNewData];
                            self.toView(2);
                            
                        } failure:^(NSError *error) {
                            
                            [self makeToast:@"网络错误!"];
                        }];
                        
                    }else{
                        
                       [SVProgressHUD showErrorWithStatus:@"支付失败" duration:1.5];
                        
                    }
                    
                }];
            }
            
            
            
        }
        
    }else if (index ==1){
        
        if (list.validConsumeSize.integerValue == 0) {
            
            [SVProgressHUD showErrorWithStatus:@"订单已失效" duration:1.5];
            return;
        }
        ZKMoreReminderView *more =[[ZKMoreReminderView alloc]initTs:@"温馨提示" MarkedWords:@"亲，是否执行退款操作？"];
        [more show];
        [more sectec:^(int pgx) {
            
            if (pgx ==1) {
                
                [self tukuanPost:list];
                
            }
        }];
        
    }
    
}


-(void)chooseView:(selctView)view;
{

    self.toView =view;
}
#pragma mark  --- 数据处理

-(void)loadNewData
{
    
    page = 1;
    if (_errDataView) {
        [_errDataView removeFromSuperview];
        _errDataView = nil;
    }
    [self postData];
    
}

-(void)loadMoreData
{
    
    page++;
    [self postData];
    
}

-(void)updata;
{
    
    if (self.listData.count>0&&[type isEqualToString:@"0"]) {
        
        [self loadNewData];
    }
    
}

-(void)postData;

{
    
    NSMutableDictionary *list = [NSMutableDictionary dictionary];
    [list setObject:@"get_orderlist" forKey:@"method"];
    [list setObject:@"0" forKey:@"state"];
    [list setObject:[NSNumber numberWithInteger:page] forKey:@"page"];
    [list setObject:@"15" forKey:@"pagesize"];
    [list setObject:[ZKUtil timeStamp] forKey:@"TimeStamp"];
    [list setObject:type forKey:@"payState"];
    [list setObject:@"8" forKey:@"interfaceId"];
    [list setObject:@"1" forKey:@"distributor"];
    [list setObject:[ZKUserInfo sharedZKUserInfo].ID forKey:@"customer"];

    [ZKHttp post:universalServerUrl params:list success:^(id responseObj) {
        
        NSLog(@" \n 数据 = %@ \n ",responseObj);

        
        NSMutableArray<ZKmyOrdeMode *> *dataArray = [ZKmyOrdeMode objectArrayWithKeyValuesArray:responseObj[@"root"][@"rows"]];
        
        if (dataArray.count>0) {
            
            /**
             *  加数据
             */
            
            if (self.page == 1) {
                
                self.listData = dataArray;
                
            }else {
                [self.listData addObjectsFromArray:dataArray];
            }
            
            
            [self endRefreshAccordingTotalCount:[responseObj[@"root"][@"totalCount"] intValue]];
            
            if (dataArray.count == 0 && self.page > 1) {
                self.page--;
            }
            
            [self.tableView reloadData];
  
        }else{
        
         [self.tableView.mj_header endRefreshing];
        }
              //根据数据个数判断是否要显示提示没有数据的图片
        self.errDataView.hidden = self.listData.count > 0;
        
        
        
    } failure:^(NSError *error) {
        
        [self endRefreshAccordingTotalCount:-1];
        //当前页码减1，当请求第一页的数据时，保持页码为1不变，跳过if语句
        if (self.page > 1) {
            self.page--;
        }
        //提示
        [SVProgressHUD showErrorWithStatus:@"网络连接错误！"];
        //根据数据个数判断是否要显示提示没有数据的图片
        self.errDataView.hidden = self.listData.count > 0;
        
    }];
    
}

/**
 *  退款
 *
 *  @param list
 */
-(void)tukuanPost:(ZKmyOrdeMode*)data;
{
    [SVProgressHUD showWithStatus:@"正在退款..."];
    
    NSMutableDictionary *list = [NSMutableDictionary dictionary];
    [list setObject:@"52" forKey:@"interfaceId"];
    [list setObject:@"orderRefund" forKey:@"method"];
    [list setObject:data.oid forKey:@"oid"];
    [list setObject:[ZKUtil timeStamp] forKey:@"TimeStamp"];
    [list setObject:[ZKUserInfo sharedZKUserInfo].ID forKey:@"memberid"];
    
    [ZKHttp post:universalServerUrl params:list success:^(id responseObj) {
        
        if ([[responseObj valueForKey:@"success"] isEqualToString:@"true"])
        {
            
            [SVProgressHUD dismissWithSuccess:@"提示退款申请已提交，待审核"];
            [self loadNewData];
            self.toView(3);

        }else
        {
        
            [SVProgressHUD showErrorWithStatus:@"有未处理的退款信息" duration:2];
           
        }

        
    } failure:^(NSError *error)
     {
        
        [SVProgressHUD dismissWithError:@"退款失败,网络出错了."];
        
    }];
    
    
    
}


- (NSMutableArray<ZKmyOrdeMode *> *)listData
{
    if (_listData == nil) {
        
        _listData = [NSMutableArray array];
        
    }
    return _listData;
}


- (void)endRefreshAccordingTotalCount:(int)totalCount
{
    
    
    [self.tableView.mj_header endRefreshing];
    if (totalCount != -1 && self.listData.count == totalCount) {
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    }else {
        [self.tableView.mj_footer endRefreshing];
    }
}


- (UIImageView *)errDataView
{
    
    if (_errDataView == nil) {
        UIImageView *emptyDataView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"errData"]];
        CGSize t = emptyDataView.frame.size;
        emptyDataView.frame =CGRectMake((self.frame.size.width-t.width)/2, (self.frame.size.height-t.height)/2, t.width, t.height);
        emptyDataView.userInteractionEnabled =YES;
        [self addSubview:emptyDataView];
        self.errDataView = emptyDataView;
        UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(loadNewData)];
        [emptyDataView addGestureRecognizer:tapGr];
        
    }
    return _errDataView;
}


/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
