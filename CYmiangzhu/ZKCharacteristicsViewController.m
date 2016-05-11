//
//  ZKGoods/Users/wangxiaola/Desktop/畅游眉山/CYmiangzhu/NavPointAnnotation.hDetailsViewController.m
//  CYmiangzhu
//
//  Created by 王小腊 on 16/1/7.
//  Copyright © 2016年 WangXiaoLa. All rights reserved.
//

#import "ZKCharacteristicsViewController.h"
#import "ZKActivitiesShareViewController.h"
#import "LSPaoMaView.h"
#import <CoreLocation/CoreLocation.h>
#import "MONActivityIndicatorView.h"
#import "ZKGoodsOneMode.h"
#import "ZKCommentModel.h"
#import "CYmiangzhu-Swift.h"
#import "ZKMapNavController.h"
#import "ZKCommentCell.h"
#import "ZKEvaluationViewController.h"
#import "ZKregisterViewController.h"
@interface ZKCharacteristicsViewController ()<CLLocationManagerDelegate,MONActivityIndicatorViewDelegate,UIWebViewDelegate,UITableViewDataSource,UITableViewDelegate>
{
    
    
    NSString *_ID;
    NSString *_type;
    
    /**
     *  头部
     */
    LSPaoMaView *lsPaoMaView;
    NSString *name;
    
    MONActivityIndicatorView *indicatorView;
    NSString *myAdder;
    double lat;
    double lon;
    
    float viewOne ;
    float viewTwo ;
    float imageHeghit;
    
    ZKGoodsOneMode *oneMode;
    ZKCommentModel *towMode;
    UILabel *jlLabel;
    
    UIScrollView *scroview;
    UIView *contView;
    UIView *pingjiaView;
    
    UIWebView *foodwebview;
    UIView *foodView;
    
    UITableView *tabelView;

    
    NSInteger pag;
    
    
    UIButton *plButton ;
    
}
@property (nonatomic, strong) CLLocationManager  *locationManager;
@property (nonatomic,strong) NSMutableArray <ZKCommentModel*>*listData;

@end

@implementation ZKCharacteristicsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor =[UIColor whiteColor];
    self.rittBarButtonItem =[[UIButton alloc]initWithFrame:CGRectMake(kDeviceWidth-2-40, 20, 40, 40)];
    self.rittBarButtonItem.backgroundColor =[UIColor clearColor];
    self.rittBarButtonItem.titleLabel.textColor =[UIColor whiteColor];
    self.rittBarButtonItem.titleLabel.font =[UIFont systemFontOfSize:12];
    self.rittBarButtonItem.titleLabel.font =[UIFont boldSystemFontOfSize:12];
    [self.rittBarButtonItem addTarget:self action:@selector(enterClick) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationBarView addSubview: self.rittBarButtonItem];
    
    self.rittBarButtonItem2 =[[UIButton alloc]initWithFrame:CGRectMake(kDeviceWidth-2-70, 20, 40, 40)];
    self.rittBarButtonItem2.backgroundColor =[UIColor clearColor];
    self.rittBarButtonItem2.titleLabel.textColor =[UIColor whiteColor];
    self.rittBarButtonItem2.titleLabel.font =[UIFont systemFontOfSize:12];
    self.rittBarButtonItem2.titleLabel.font =[UIFont boldSystemFontOfSize:12];
    [self.rittBarButtonItem2 addTarget:self action:@selector(enterClick2) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationBarView addSubview: self.rittBarButtonItem2];
    
    [self.rittBarButtonItem setImage:[UIImage imageNamed:@"my_for_0"] forState:UIControlStateNormal];
    [self.rittBarButtonItem2 setImage:[UIImage imageNamed:@"my_for_1"] forState:UIControlStateNormal];
    [self.titeLabel removeFromSuperview];
    lat = [ZKUtil ToTakeTheKey:@"Latitude"].doubleValue;
    lon = [ZKUtil ToTakeTheKey:@"Longitude"].doubleValue;
    myAdder = [ZKUtil ToTakeTheKey:@"adder"];
    pag =0;
    

    
    scroview =[[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, kDeviceWidth, TabelHeghit)];
    scroview.pagingEnabled =NO;
    scroview.contentOffset =CGPointMake(0, 0);
    scroview.contentSize =CGSizeMake(kDeviceWidth, TabelHeghit);
    scroview.backgroundColor =YJCorl(250, 250, 250);
    [self.view addSubview:scroview];
    
    indicatorView = [[MONActivityIndicatorView alloc] init];
    indicatorView.delegate = self;
    indicatorView.numberOfCircles = 4;
    indicatorView.radius = 10;
    indicatorView.internalSpacing = 5;
    indicatorView.center =self.view.center;
    scroview.bounces =NO;
    [scroview addSubview:indicatorView];
    
}


-(void)updata:(NSString*)goodsID type:(NSString*)goodsType name:(NSString*)goodsName;
{
    viewOne = 0;
    viewTwo = 0;
    
    name =goodsName;
    [self nameGD];
    [self postData:goodsID goodsType:goodsType];
    
    
}

#pragma mark  数据请求
-(void)postData:(NSString*)ID goodsType:(NSString*)type
{
    
    _ID =ID;
    _type =type;
    
    NSMutableDictionary *list = [NSMutableDictionary dictionary];
    
    [list setObject:type forKey:@"type"];
    [list setObject:@"resoureDetail" forKey:@"method"];
    [list setObject:ID forKey:@"id"];
    [indicatorView startAnimating];
    
    [ZKHttp Post:@"" params:list success:^(id responseObj) {
        
        [indicatorView stopAnimating];
        NSLog(@" === %@",responseObj);
        oneMode = [ZKGoodsOneMode objectWithKeyValues:responseObj];
        [self viewOne];
        [self locan];
        
    } failure:^(NSError *error) {
        [indicatorView stopAnimating];
        [self.view makeToast:@"网络出错了!"];
        
    }];
    
    
    //NSTimeInterval time=[str doubleValue]+28800;
    
    NSMutableDictionary *info = [NSMutableDictionary dictionary];
    [info setObject:type forKey:@"type"];
    [info setObject:@"commentlist" forKey:@"method"];
    [info setObject:ID forKey:@"id"];
    [indicatorView startAnimating];
    
    [ZKHttp Post:@"" params:info success:^(id responseObj) {
        
        [indicatorView stopAnimating];
        NSLog(@"  ---- %@",responseObj);
        NSMutableArray<ZKCommentModel*>*dataArray =[ZKCommentModel objectArrayWithKeyValuesArray:[responseObj valueForKey:@"rows"]];
        self.listData = dataArray;
        
        if (dataArray.count>3) {
            
            pag =3;
         
            
        }else{
            pag =dataArray.count;
       
        }
        
        [self viewTow];
        
        
    } failure:^(NSError *error) {
        self.listData =nil;
        pag =0;
        [self viewTow];
        [indicatorView stopAnimating];
       
    }];
    
    
    
    
    
}

#pragma mark 视图布局
-(void)viewOne
{
    contView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, 400)];
    contView.backgroundColor =YJCorl(250, 250, 250);
    [scroview addSubview:contView];
    
    if (IsIOS8) {
        
        imageHeghit =160;
        
        
    }else{
        
        
        imageHeghit =130;
        
    }
    

    
    {
        UIImageView *headerIamge =[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, imageHeghit)];
        [ZKUtil UIimageView:headerIamge NSSting:[NSString stringWithFormat:@"%@%@",imageUrlPrefix,oneMode.logosmall]];
        [contView addSubview:headerIamge];
        
        UIView * ztlView = [[UIView alloc]initWithFrame:CGRectMake(0, imageHeghit-46, kDeviceWidth, 46)];
        ztlView .backgroundColor =[UIColor colorWithWhite:0 alpha:0.5];
        [headerIamge addSubview:ztlView];
        
        UILabel *nameLabel =[[UILabel alloc]initWithFrame:CGRectMake(9, 4, 200, 12)];
        nameLabel.textColor =[UIColor whiteColor];
        nameLabel.font =[UIFont systemFontOfSize:11];
        nameLabel.text =oneMode.name;
        [ztlView addSubview:nameLabel];
        
        RatingBar *ratingBar = [[RatingBar alloc] init];
        ratingBar.frame =CGRectMake(8, 22, 100, 14);
        ratingBar.isIndicator = YES;
        ratingBar.numStars = 5;
        ratingBar.ratingMax = 5;
        ratingBar.rating=[oneMode.exponent floatValue];
        [ztlView addSubview:ratingBar];
        
        UILabel *exponentLabel =[[UILabel alloc]initWithFrame:CGRectMake(120, 24, 60, 14)];
        exponentLabel.textColor =[UIColor orangeColor];
        exponentLabel.font =[UIFont systemFontOfSize:10];
        exponentLabel.text =[NSString stringWithFormat:@"%ld.0分",(long)oneMode.exponent.integerValue];
        [ztlView addSubview:exponentLabel];
    }
    
    
    {
        UIView *adderView =[[UIView alloc]initWithFrame:CGRectMake(0, imageHeghit, kDeviceWidth, 60)];
        [contView addSubview:adderView];
        [self layeBode:adderView];
        
        UIImageView *addvew =[[UIImageView alloc]initWithFrame:CGRectMake(8, 17, 14, 16)];
        addvew.image =[UIImage imageNamed:@"detail_dingwei"];
        [adderView addSubview:addvew];
        
        UILabel *adderLabel =[[UILabel alloc]initWithFrame:CGRectMake(30, 2, 220, 36)];
        adderLabel.font =[UIFont systemFontOfSize:12];
        adderLabel.numberOfLines =2;
        adderLabel.textColor =[UIColor blackColor];
        [adderView addSubview:adderLabel];
        adderLabel.text =oneMode.address;
        
        jlLabel =[[UILabel alloc]initWithFrame:CGRectMake(30, 38, 200, 15)];
        jlLabel.textColor =[UIColor grayColor];
        jlLabel.font =[UIFont systemFontOfSize:12];
        jlLabel.text =@"正在计算...";
        [adderView addSubview:jlLabel];
        
        UIView *lin =[[UIView alloc]initWithFrame:CGRectMake(kDeviceWidth-50, 7, 0.4, 46)];
        lin.backgroundColor =TabelBackCorl;
        [adderView addSubview:lin];
        
        UIButton *callButton =[[UIButton alloc]initWithFrame:CGRectMake(kDeviceWidth-50, 5, 50, 50)];
        [callButton setImage:[UIImage imageNamed:@"detail_call"] forState:0];
        [callButton addTarget:self action:@selector(callButton) forControlEvents:UIControlEventTouchUpInside];
        [adderView addSubview:callButton];
        
        UIButton *addButton =[[UIButton alloc]initWithFrame:CGRectMake(0, 5, 200, 50)];
        addButton.backgroundColor =[UIColor clearColor];
        [addButton addTarget:self action:@selector(addButton) forControlEvents:UIControlEventTouchUpInside];
        [adderView addSubview:addButton];
        
    }
    
    
    //{
    
    
    //UIView *priceView =[[UIView alloc]initWithFrame:CGRectMake(0, imageHeghit+60+10, kDeviceWidth, 40)];
    //[contView addSubview:priceView];
    //[self layeBode:priceView];
    
    //UIImageView *priceImage =[[UIImageView alloc]initWithFrame:CGRectMake(8, 13.5, 14, 13)];
    //priceImage.image =[UIImage imageNamed:@"table_my_yuyue"];
    //[priceView addSubview:priceImage];
    
    //UILabel *priceLabel =[[UILabel alloc]initWithFrame:CGRectMake(30, 12, 120, 16)];
    //priceLabel.textColor =[UIColor blackColor];
    //priceLabel.font =[UIFont systemFontOfSize:12];
    //priceLabel.text =@"价格参考";
    //[priceView addSubview:priceLabel];
    
    //UILabel *priceLabel_0 =[[UILabel alloc]initWithFrame:CGRectMake(kDeviceWidth-60, 12, 40, 16)];
    //priceLabel_0.textColor =CYBColorGreen;
    //priceLabel_0.font =[UIFont systemFontOfSize:13];
    //priceLabel_0.text =[NSString stringWithFormat:@"¥%@",oneMode.price];
    //[priceView addSubview:priceLabel_0];
    
    //float price_0 =[ZKUtil UIlabelW:priceLabel_0 NSStting:priceLabel_0.text Max:40];
    
    //UILabel *priceLabel_1 =[[UILabel alloc]initWithFrame:CGRectMake(kDeviceWidth-60+price_0, 15, 20, 13)];
    //priceLabel_1.textColor =[UIColor grayColor];
    //priceLabel_1.font =[UIFont systemFontOfSize:10];
    //priceLabel_1.text =@"人均";
    //[priceView addSubview:priceLabel_1];
    
    
    //}
    
    
    {
        
        
        foodView =[[UIView alloc]initWithFrame:CGRectMake(0, imageHeghit+60+10, kDeviceWidth, 100)];
        foodView.backgroundColor =[UIColor whiteColor];
        [contView addSubview:foodView];
        [self layeBode:foodView];
        
        UIView *foodHeadeView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, 40)];
        [self layeBode:foodHeadeView];
        [foodView addSubview:foodHeadeView];
        
        UIImageView *foodImage =[[UIImageView alloc]initWithFrame:CGRectMake(8, 13.5, 14, 13)];
        foodImage.image =[UIImage imageNamed:@"detail_date"];
        [foodView addSubview:foodImage];
        
        UILabel *foodLabel =[[UILabel alloc]initWithFrame:CGRectMake(30, 12, 120, 16)];
        foodLabel.textColor =[UIColor blackColor];
        foodLabel.font =[UIFont systemFontOfSize:12];
        foodLabel.text =@"购物介绍";
        [foodView addSubview:foodLabel];
        
        
        viewOne =imageHeghit+60+10+20;
        
        UILabel *jsLabel =[[UILabel alloc]initWithFrame:CGRectMake(8, 45, kDeviceWidth-16, 20)];
        jsLabel.textColor =[UIColor grayColor];
        jsLabel.font =[UIFont systemFontOfSize:10];
        jsLabel.text =[NSString stringWithFormat:@"类型:%@       营业时间:全天",oneMode.resourcelevelName];
        [foodView addSubview:jsLabel];
        
        foodwebview =[[UIWebView alloc]initWithFrame:CGRectMake(0, 60, kDeviceWidth, 50)];
        foodwebview.delegate =self;
        foodwebview.scrollView.bounces =NO;
        
        NSString *state;
        
        if (strIsEmpty(oneMode.info)==1) {
            
            state = @"暂无简介";
        }else{
            state = oneMode.info;
        }

        NSString *jsString = [NSString stringWithFormat:@"<html> \n"
                              "<head> \n"
                              "<style type=\"text/css\"> \n"
                              "body {font-family: \"%@\"; font-size: %d;}\n"
                              "</style> \n"
                              "</head> \n"
                              "<body>%@</body> \n"
                              "</html>", @"宋体", 11,state] ;
        [foodwebview loadHTMLString:jsString baseURL:nil];
        [foodView addSubview:foodwebview];
        
        
        
    }
    
}
-(void)viewTow
{
    
    float tabelHeghit =75*pag;
    pingjiaView =[[UIView alloc]initWithFrame:CGRectMake(0, 10+viewOne, kDeviceWidth, 45+tabelHeghit+30)];
    [scroview addSubview:pingjiaView];
    [self layeBode:pingjiaView];
    
    viewTwo = 45+tabelHeghit+30;
    
    scroview.contentSize =CGSizeMake(kDeviceWidth, viewTwo+viewOne+10);
    
    {
        UIView *pjheaderView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, 45)];
        pjheaderView.backgroundColor =[UIColor orangeColor];
        [self layeBode:pjheaderView];
        [pingjiaView addSubview:pjheaderView];
        
        UILabel *scoreLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 60, 46)];
        scoreLabel.textAlignment = NSTextAlignmentLeft;
        scoreLabel.font = [UIFont systemFontOfSize:14];
        scoreLabel.textColor = [UIColor orangeColor];
        scoreLabel.text = @"评价";
        [pjheaderView addSubview:scoreLabel];
        
        UIButton *priceButton =[[UIButton alloc]initWithFrame:CGRectMake(kDeviceWidth-40, 5, 30, 30)];
        [priceButton setImage:[UIImage imageNamed:@"my_cell_4"] forState:0];
        [priceButton addTarget:self action:@selector(priceButton) forControlEvents:UIControlEventTouchUpInside];
        [pjheaderView addSubview:priceButton];

        
    }
    
    
    {
        tabelView = [[UITableView alloc] initWithFrame:CGRectMake(0, 45, self.view.bounds.size.width, tabelHeghit)];
        //tabelView.separatorStyle = NO;
        tabelView.backgroundColor = YJCorl(231, 231, 231);
        //去掉plain样式下多余的分割线
        tabelView.tableFooterView = [[UIView alloc] init];
        //设置分割线左边无边距，默认是15
        tabelView.separatorInset = UIEdgeInsetsZero;
        tabelView.estimatedRowHeight=90; //预估行高 可以提高性能
        tabelView.rowHeight = 90;
        tabelView.dataSource = self;
        tabelView.delegate = self;
        tabelView.scrollEnabled = NO;
        [tabelView registerNib:[UINib nibWithNibName:@"ZKCommentCell" bundle:nil] forCellReuseIdentifier:ZKCommentCellID];
        [pingjiaView addSubview:tabelView];
        
        plButton=[[UIButton alloc]initWithFrame:CGRectMake(0, pingjiaView.frame.size.height-30, kDeviceWidth, 30)];
        if (self.listData.count>0&&self.listData.count<=3) {
            
            [plButton setTitle:@"没有更多评论" forState:0];
            
        }else if (self.listData.count > 3){
            
            [plButton setTitle:@"加载更多评论" forState:0];
            
        }else if (self.listData.count == 0){
            
            [plButton setTitle:@"暂没有评论" forState:0];
        }
        plButton.titleLabel.font =[UIFont systemFontOfSize:13];
        [plButton setTitleColor:CYBColorGreen forState:0];
        [plButton addTarget:self action:@selector(plButtonClick) forControlEvents:UIControlEventTouchUpInside];
        
        [pingjiaView addSubview:plButton];
        
    }
    
    
    
    
}

-(void)layeBode:(UIView*)views
{
    views.backgroundColor =[UIColor whiteColor];
    views.layer.borderWidth =0.4;
    views.layer.borderColor =TabelBackCorl.CGColor;
    
}
#pragma mark  点击事件
/**
 *  更多评论
 */
-(void)plButtonClick
{
    
    pag =pag+5;
    [self updataSubView];
    [tabelView reloadData];
    
}
/**
 *  分享
 */
-(void)enterClick
{
    if ([self isTelnet] ==NO) {
        
        return;
    }
    
    [[BaiduMobStat defaultStat] logEvent:@"share_shopping" eventLabel:@"分享购物列表"];
    
    ZKActivitiesShareViewController *activ =[[ZKActivitiesShareViewController alloc]initImageUrl:[NSString stringWithFormat:@"%@%@",imageUrlPrefix,oneMode.logosmall]  Theme:oneMode.name  Name:oneMode.address Lurl:nil];
    __weak typeof(self)weekSelf =self;
    [activ shareSuccess:^{
        [weekSelf collectionAndShare:@"1"];
    }];
    [self.navigationController pushViewController:activ animated:YES];
}
/**
 *  收藏
 */
-(void)enterClick2
{
    
    [[BaiduMobStat defaultStat] logEvent:@"collect_shopping" eventLabel:@"收藏购物列表"];
    [self collectionAndShare:@"0"];
    
}

-(void)collectionAndShare:(NSString*)typeint;
{
    
    if ([self isTelnet] ==NO) {
        
        return;
    }
    
    NSMutableDictionary *info = [NSMutableDictionary dictionary];
    [info setObject:_type forKey:@"type"];
    [info setObject:typeint forKey:@"typeint"];
    [info setObject:@"collectionAndShare" forKey:@"method"];
    [info setObject:[ZKUserInfo sharedZKUserInfo].ID forKey:@"memberid"];
    [info setObject:_ID forKey:@"id"];
    
    [indicatorView startAnimating];
    
    [ZKHttp Post:@"" params:info success:^(id responseObj) {
        
        [indicatorView stopAnimating];
        
        [self.view makeToast:[responseObj valueForKey:@"msg"]];
        
        
    } failure:^(NSError *error) {
        
        [self.view makeToast:@"网络出错了!"];
        
    }];
    
}


/**
 *  判断是否登录
 */
-(BOOL)isTelnet
{
    
    if (!oneMode.name) {
        
        [self.view makeToast:@"正在加载数据,请稍等!"];
        return NO;
    }
    
    
    if (![ZKUserInfo sharedZKUserInfo].ID) {
        
        ZKregisterViewController *vc =[[ZKregisterViewController alloc]init];
        vc.isMy =YES;
        UINavigationController *nav =[[UINavigationController alloc]initWithRootViewController:vc];
        nav.navigationBarHidden =YES;
        [self.navigationController presentViewController:nav animated:YES completion:^{
            
        }];
        
        return NO;
    }
    
    return YES;
}
/**
 *  导航
 */
-(void)addButton
{
    if (!myAdder) {
        
        [self.view makeToast:@"当前地址获取失败！"];
        return;
    }
    

    
    ZKMapNavController *map =[[ZKMapNavController alloc]initKLat:lat KLon:lon Kadder:myAdder WLat:oneMode.y.doubleValue WLon:oneMode.x.doubleValue WAdder:oneMode.address code:[ZKUtil ToTakeTheKey:@"myCity"]];
    [self.navigationController pushViewController:map animated:YES];

}
/**
 *  pingjia
 */
-(void)priceButton
{
    
    if ([self isTelnet] ==NO) {
        
        return;
    }
    
    NSString *number = oneMode.exponent;
    if ([number intValue]<6&&[number intValue]>0) {
        
        number =@"5";
    }
    ZKEvaluationViewController *vc =[[ZKEvaluationViewController alloc]initData:oneMode];
    [vc succeed:^{
        
        
        NSMutableDictionary *info = [NSMutableDictionary dictionary];
        [info setObject:_type forKey:@"type"];
        [info setObject:@"commentlist" forKey:@"method"];
        [info setObject:_ID forKey:@"id"];
        [indicatorView startAnimating];
        
        [ZKHttp Post:@"" params:info success:^(id responseObj) {
            
            [indicatorView stopAnimating];
            NSMutableArray<ZKCommentModel*>*dataArray =[ZKCommentModel objectArrayWithKeyValuesArray:[responseObj valueForKey:@"rows"]];
            self.listData = dataArray;
            
            pag++;
            
            [tabelView reloadData];
            
            [self updataSubView];
            
        } failure:^(NSError *error) {
            
            [indicatorView stopAnimating];
            [self.view makeToast:@"网络出错了!"];
        }];
        
    }];
    [self.navigationController pushViewController:vc animated:YES];
    
    
    
}
/**
 *  更新视图
 */
-(void)updataSubView
{
    if (self.listData.count ==0) {
        
        return;
    }
    if (pag>=self.listData.count) {
        [plButton setTitle:@"没有更多评论" forState:0];
        pag =self.listData.count;
    }
    
    float tabelHeghit =75*pag;
    pingjiaView.frame =CGRectMake(0, 10+viewOne, kDeviceWidth, 45+tabelHeghit+30);
    viewTwo = 45+tabelHeghit+30;
    tabelView.frame =CGRectMake(0, 45, self.view.bounds.size.width, 75*pag);
    scroview.contentSize =CGSizeMake(kDeviceWidth, viewTwo+viewOne+10);
    
    plButton.frame =CGRectMake(0, pingjiaView.frame.size.height-30, kDeviceWidth, 30);
    
    
}
/**
 *  打电话
 */
-(void)callButton
{
    NSArray *phones= [oneMode.phone componentsSeparatedByString:@","];
    NSString *dataGBK;
    
    if (phones.count > 1) {
        dataGBK = phones[0];
    }else{
        
        dataGBK = oneMode.phone;
    }
    
    [[BaiduMobStat defaultStat] logEvent:@"btn_call" eventLabel:@"打电话 "];
    
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",[dataGBK stringByReplacingOccurrencesOfString:@"—" withString:@""]];
    
    UIWebView * callWebview = [[UIWebView alloc] init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
    [self.view addSubview:callWebview];
    
}
#pragma mark －－－－－
#pragma mark tableDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.listData.count==0) {
        
        return 0;
    }else{
        
        return pag;
    }

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZKCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:ZKCommentCellID];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.commentModel = self.listData[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 75;
}

-(void)nameGD{
    
    
    if (lsPaoMaView) {
        
        [lsPaoMaView removeFromSuperview];
    }
    
    float labelW;
    
    
    labelW =self.view.frame.size.width-80-40;
    
    lsPaoMaView = [[LSPaoMaView alloc]initWithFrame:CGRectMake(40, 8, labelW, navigationHeghit) title:name];
    
    
    [self.navigationBarView  addSubview:lsPaoMaView];
    
}


#pragma mark 地图相关
-(void)locan
{
    
    
    self.locationManager = [[CLLocationManager alloc]init];
    _locationManager.delegate = self;
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    _locationManager.distanceFilter = 10;
    
    if (IsIOS8) {
        
        
        [_locationManager requestAlwaysAuthorization];
        
    }
    
    [_locationManager startUpdatingLocation];
    
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *currLocation = [locations lastObject];
    
    lat =currLocation.coordinate.latitude;
    lon =currLocation.coordinate.longitude;
    [_locationManager stopUpdatingLocation];
    
    //第一个坐标
    CLLocation *current=[[CLLocation alloc] initWithLatitude:lat longitude:lon];
    //第二个坐标
    CLLocation *before=[[CLLocation alloc] initWithLatitude:oneMode.y.doubleValue longitude:oneMode.x.doubleValue];
    // 计算距离
    CLLocationDistance meters=[current distanceFromLocation:before];
    
    jlLabel.text =[NSString stringWithFormat:@"%.2fkm",meters/1000];
    
    CLLocation *c = [[CLLocation alloc] initWithLatitude:lat longitude:lon];
    //创建位置
    CLGeocoder *revGeo = [[CLGeocoder alloc] init];
    [revGeo reverseGeocodeLocation:c
     //反向地理编码
                 completionHandler:^(NSArray *placemarks, NSError *error) {
                     
                     
                     
                     if (!error && [placemarks count] > 0)
                     {
                         NSDictionary *dict =
                         [[placemarks objectAtIndex:0] addressDictionary];
                         NSLog(@"street address: %@",
                               //记录地址
                               [dict objectForKey:@"Name"]);
                         
                         NSString *str =[dict objectForKey:@"Name"];
                         
                         str =[str stringByReplacingOccurrencesOfString:@"中国" withString:@""];
                         
                         myAdder=str;
                         
                     }
                     else
                     {
                         
                         
                         NSLog(@"ERROR: %@", error); }
                 }];
    
}


#pragma mark - webview
//完成
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
    [UIView animateWithDuration:0.3 animations:^{
        
        float webHeight  =foodwebview.scrollView.contentSize.height;;
        CGPoint point =foodView.frame.origin;
        foodView.frame =CGRectMake(point.x, point.y, kDeviceWidth, 60+webHeight+10);
        foodwebview.frame =CGRectMake(0, 65, kDeviceWidth, webHeight+5);
        
        CGRect frame = contView.frame;
        frame.size.height = CGRectGetMaxY(foodView.frame);
        contView.frame = frame;
        
        viewOne =imageHeghit+140+webHeight;
        
        pingjiaView.frame =CGRectMake(0, viewOne+10, kDeviceWidth, viewTwo);
        scroview.contentSize =CGSizeMake(kDeviceWidth, viewTwo+viewOne+10);

        
    }];
    
}

- (NSMutableArray<ZKCommentModel *> *)listData
{
    if (_listData == nil) {
        
        _listData = [NSMutableArray array];
        
    }
    return _listData;
}

#pragma mark - MONActivityIndicatorViewDelegate Methods

- (UIColor *)activityIndicatorView:(MONActivityIndicatorView *)activityIndicatorView
      circleBackgroundColorAtIndex:(NSUInteger)index {
    
    CGFloat red   = (arc4random() % 256)/255.0;
    CGFloat green = (arc4random() % 256)/255.0;
    CGFloat blue  = (arc4random() % 256)/255.0;
    CGFloat alpha = 1.0f;
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
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
