//
//  ZKGoods/Users/wangxiaola/Desktop/畅游眉山/CYmiangzhu/NavPointAnnotation.hDetailsViewController.m
//  CYmiangzhu
//
//  Created by 王小腊 on 16/1/7.
//  Copyright © 2016年 WangXiaoLa. All rights reserved.
//

#import "ZKticketListViewController.h"
#import "ZKActivitiesShareViewController.h"
#import "LSPaoMaView.h"
#import <CoreLocation/CoreLocation.h>
#import "MONActivityIndicatorView.h"
#import "ZKticketInforMOde.h"
#import "ZKCommentModel.h"
#import "CYmiangzhu-Swift.h"
#import "ZKMapNavController.h"
#import "ZKCommentCell.h"
#import "ZKEvaluationViewController.h"
#import "ZKregisterViewController.h"
#import "ZKticketMOde.h"
#import "SDCycleScrollView.h"
#import "ZKVoiceView.h"
#import "ZKCommitOrderViewController.h"
#import "ZKProduction.h"
#import "ZKnearListViewController.h"


@interface ZKticketListViewController ()<CLLocationManagerDelegate,MONActivityIndicatorViewDelegate,UIWebViewDelegate,UITableViewDataSource,UITableViewDelegate>
{

    
    ZKVoiceView *voice;
    
    NSString *_ID;
    
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
    
    float musHeghit;
    
    SDCycleScrollView *cycleScrollView;
    
    ZKticketInforMOde *oneMode;
    ZKCommentModel *towMode;
    UILabel *jlLabel;
    
    UIScrollView *scroview;
    
    UIView *pingjiaView;
    
    UIWebView *foodwebview;
    UIView *foodView;
    
    UITableView *tabelView;
    
    NSInteger pag;
    
    UIButton *plButton ;
    
}
@property (nonatomic, strong) CLLocationManager  *locationManager;
@property (nonatomic, strong) NSMutableArray <ZKCommentModel*>*listData;
@property (nonatomic, strong) NSMutableArray <ZKticketMOde*>*tickeMOde;

@end

@implementation ZKticketListViewController

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [voice pause];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    musHeghit = 0;
    
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


-(void)updata:(NSString*)goodsID  name:(NSString*)goodsName;
{
    viewOne = 0;
    viewTwo = 0;
    
    name =goodsName;
    [self nameGD];
    [self postData:goodsID ];
    
    
}

#pragma mark  数据请求
-(void)postData:(NSString*)ID {
    
    _ID =ID;
    
    [indicatorView startAnimating];
    
    NSMutableDictionary *list = [NSMutableDictionary dictionary];
    
    [list setObject:@"scenery" forKey:@"type"];
    [list setObject:@"resoureDetail" forKey:@"method"];
    [list setObject:ID forKey:@"id"];

    
    [ZKHttp Post:@"" params:list success:^(id responseObj) {

        oneMode = [ZKticketInforMOde objectWithKeyValues:responseObj];
        
        NSLog(@" === %@",oneMode.path) ;
        
        musHeghit = oneMode.path ? 60:0;
        
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"method"] = @"productmsg";
        params[@"outid"] = ID;
        params[@"page"] = @"1";
        params[@"pagesize"] = @"100";
        params[@"typecode"] = @"menpiao";
        params[@"interfaceId"] = @"6";
        params[@"TimeStamp"] = [ZKUtil timeStamp];
        
        [ZKHttp post:universalServerUrl params:params success:^(id responseObj) {
            
            [indicatorView stopAnimating];
            
            if ([responseObj[@"errmsg"] isEqualToString:@"SUCCESS"]) {

                self.tickeMOde = [ZKticketMOde objectArrayWithKeyValuesArray:responseObj[@"root"][@"rows"]];
                  
                
                [self viewOne];
                
                [self locan];
                
            }
            
        } failure:^(NSError *error) {
            [self.view makeToast:@"网络出错了!"];
            [indicatorView stopAnimating];
        }];
        
        
        
    } failure:^(NSError *error) {
        [indicatorView stopAnimating];
        [self.view makeToast:@"网络出错了!"];
        
    }];
    
    
    NSMutableDictionary *info = [NSMutableDictionary dictionary];
    [info setObject:@"scenery" forKey:@"type"];
    [info setObject:@"commentlist" forKey:@"method"];
    [info setObject:ID forKey:@"id"];
    [indicatorView startAnimating];
    
    [ZKHttp Post:@"" params:info success:^(id responseObj) {
        
        
        
        //NSLog(@"  ---- %@",responseObj);
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

        
    }];
    
    
    
    
    
}

#pragma mark 视图布局

-(void)viewOne
{
    
    
    NSLog(@"******viewone******\n\n");
    if (IsIOS8) {
        
        imageHeghit =160;
        
        
    }else{
        
        
        imageHeghit =130;
        
    }
    
    viewOne =imageHeghit+60+40+10+10+40+20+10+musHeghit+60*self.tickeMOde.count+50;
    scroview.contentSize =CGSizeMake(kDeviceWidth, viewTwo+viewOne+10);
    
    
    {
        UIView *headView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, imageHeghit)];
        [scroview addSubview:headView];
        
        if (oneMode.pics.count< 1) {
            
            UIImageView *headerIamge =[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, imageHeghit)];
            [ZKUtil UIimageView:headerIamge NSSting:[NSString stringWithFormat:@"%@%@",imageUrlPrefix,oneMode.logosmall]];
            [scroview addSubview:headerIamge];
            
        }else{
            
            
            NSMutableArray *imgUrlArray =[[NSMutableArray alloc] initWithCapacity:0];
            for (int i =0; i<oneMode.pics.count; i++) {
                if (i ==7) {
                    break;
                }
                NSString *url =[NSString stringWithFormat:@"%@%@",imageUrlPrefix,[oneMode.pics[i] valueForKey:@"1"]];
                [imgUrlArray addObject:[NSURL URLWithString:url]];
            }
            
            
            // 网络加载 --- 创建带标题的图片轮播器
            cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, self.view.frame.size.width, imageHeghit) imageNamesGroup:imgUrlArray];
            cycleScrollView.backgroundColor =[UIColor whiteColor];
            cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
            cycleScrollView.autoScrollTimeInterval =5;
            cycleScrollView.pageControlDotSize =CGSizeMake(5, 5);
            cycleScrollView.pageDotColor = [UIColor  whiteColor]; // 自定义分页控件小圆标颜色
            cycleScrollView.currentPageDotColor = [UIColor orangeColor];
            [headView addSubview:cycleScrollView];
            
            
        }
        
        
        UIButton *Button720 =[[UIButton alloc]initWithFrame:CGRectMake(kDeviceWidth-60, 10, 50, 24)];
        Button720.backgroundColor =[UIColor colorWithWhite:0 alpha:0.5];
        Button720.layer.cornerRadius =12;
        [Button720 setTitleColor:[UIColor whiteColor] forState:0];
        [Button720 setTitle:@"720全景" forState:0];
        Button720.titleLabel.font =[UIFont systemFontOfSize:10];
        [Button720 addTarget:self action:@selector(button720Click) forControlEvents:UIControlEventTouchUpInside];
        [headView addSubview:Button720];
        
        UIView * ztlView = [[UIView alloc]initWithFrame:CGRectMake(0, imageHeghit-46, kDeviceWidth, 46)];
        ztlView .backgroundColor =[UIColor colorWithWhite:0 alpha:0.5];
        [headView addSubview:ztlView];
        
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
        //没有语言就不要加载
        if (musHeghit == 60) {
            voice =[[ZKVoiceView alloc]initWithFrame:CGRectMake(0, imageHeghit, kDeviceWidth, musHeghit) Path:oneMode.path Titi:oneMode.name Image:oneMode.logosmall];
            [scroview addSubview:voice];
            
        }

        
    }
    
    {
        UIView *adderView =[[UIView alloc]initWithFrame:CGRectMake(0, imageHeghit+10+musHeghit, kDeviceWidth, 60)];
        [scroview addSubview:adderView];
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
    
    
    {
        UIView *priceView =[[UIView alloc]initWithFrame:CGRectMake(0, imageHeghit+60+10+10+musHeghit, kDeviceWidth, 40)];
        [scroview addSubview:priceView];
        [self layeBode:priceView];
        
        UIView *priceContView =[[UIView alloc]initWithFrame:CGRectMake(0, imageHeghit+60+10+10+musHeghit+41, kDeviceWidth, 60*self.tickeMOde.count)];
        priceContView.backgroundColor =[UIColor whiteColor];
        [scroview addSubview:priceContView];
        
        UIImageView *priceImage =[[UIImageView alloc]initWithFrame:CGRectMake(8, 13.5, 14, 13)];
        priceImage.image =[UIImage imageNamed:@"table_my_yuyue"];
        [priceView addSubview:priceImage];
        
        UILabel *priceLabel =[[UILabel alloc]initWithFrame:CGRectMake(30, 12, 120, 16)];
        priceLabel.textColor =[UIColor blackColor];
        priceLabel.font =[UIFont systemFontOfSize:12];
        priceLabel.text =@"门票价格";
        [priceView addSubview:priceLabel];
        
        
        for (int i =0; i<self. tickeMOde.count; i++) {
            
            ZKticketMOde *list = self.tickeMOde[i];
            
            UIView *views =[[UIView alloc]initWithFrame:CGRectMake(0, 60*i, kDeviceWidth, 60)];
            views.userInteractionEnabled =YES;
            views.backgroundColor =[UIColor whiteColor];
            [priceContView addSubview:views];
            
            UILabel *sectLabel =[[UILabel alloc]initWithFrame:CGRectMake(10, 2, kDeviceWidth-70, 36)];
            sectLabel.font =[UIFont systemFontOfSize:12];
            sectLabel.numberOfLines =2;
            sectLabel.textColor =[UIColor blackColor];
            [views addSubview:sectLabel];
            sectLabel.text =list.name;
            
            
            UILabel *priceLabel_0 =[[UILabel alloc]initWithFrame:CGRectMake(10, 35, 40, 16)];
            priceLabel_0.textColor =CYBColorGreen;
            priceLabel_0.font =[UIFont systemFontOfSize:16];
            priceLabel_0.text =list.price;
            [views addSubview:priceLabel_0];
            
            float price_0 =[ZKUtil UIlabelW:priceLabel_0 NSStting:priceLabel_0.text Max:40];
            
            UILabel *priceLabel_1 =[[UILabel alloc]initWithFrame:CGRectMake(10+price_0, 38, 20, 13)];
            priceLabel_1.textColor =[UIColor grayColor];
            priceLabel_1.font =[UIFont systemFontOfSize:10];
            priceLabel_1.text =@"元";
            [views addSubview:priceLabel_1];
            
            
            UIButton *yudingButton =[[UIButton alloc]initWithFrame:CGRectMake(kDeviceWidth-80, 10, 70, 26)];
            yudingButton.layer.masksToBounds =YES;
            yudingButton.layer.cornerRadius =4;
            yudingButton.backgroundColor =[UIColor orangeColor];
            [yudingButton setTitle:@"预定" forState:0];
            [yudingButton setTitleColor:[UIColor whiteColor] forState:0];
            yudingButton.titleLabel.font =[UIFont systemFontOfSize:13];
            yudingButton.tag = i+1000;
            [yudingButton addTarget:self action:@selector(yudingButton:) forControlEvents:UIControlEventTouchUpInside];
            [views addSubview:yudingButton];
            
            UIView *lin =[[UIView alloc]initWithFrame:CGRectMake(10, 59, kDeviceWidth-10, 0.4)];
            lin.backgroundColor = TabelBackCorl;
            [views addSubview:lin];
            
            
        }
        
        
        
    }
    
    
    {
        
        UIView *nearbyView =[[UIView alloc]initWithFrame:CGRectMake(0, imageHeghit+60+40+10+10+10+musHeghit+self.tickeMOde.count*60, kDeviceWidth, 40)];
        [scroview addSubview:nearbyView];
        [self layeBode:nearbyView];
        
        
        UIImageView *nearbyImage =[[UIImageView alloc]initWithFrame:CGRectMake(8, 13.5, 14, 13)];
        nearbyImage.image =[UIImage imageNamed:@"detail_near"];
        [nearbyView addSubview:nearbyImage];
        
        UILabel *nearbyLabel_0 =[[UILabel alloc]initWithFrame:CGRectMake(30, 12, 60, 16)];
        nearbyLabel_0.textColor =[UIColor blackColor];
        nearbyLabel_0.font =[UIFont systemFontOfSize:12];
        nearbyLabel_0.text =@"附近推荐";
        [nearbyView addSubview:nearbyLabel_0];
        
        UILabel *nearbyLabel_1 =[[UILabel alloc]initWithFrame:CGRectMake(85, 12, 160, 16)];
        nearbyLabel_1.textColor =[UIColor grayColor];
        nearbyLabel_1.font =[UIFont systemFontOfSize:12];
        nearbyLabel_1.text =@"(美食.酒店.娱乐.购物.景点)";
        [nearbyView addSubview:nearbyLabel_1];
        
        
        UIImageView *ritImage =[[UIImageView alloc]initWithFrame:CGRectMake(kDeviceWidth-12, 13.5, 6, 13)];
        ritImage.image =[UIImage imageNamed:@"jt_Xright"];
        [nearbyView addSubview:ritImage];
        
        UIButton * nearbyButton =[[UIButton alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, 40)];
        [nearbyButton addTarget:self action:@selector(nearbyButton) forControlEvents:UIControlEventTouchUpInside];
        nearbyButton.backgroundColor =[UIColor clearColor];
        [nearbyView addSubview:nearbyButton];
        
    }
    
    
    {
        
        
        
        
        foodView =[[UIView alloc]initWithFrame:CGRectMake(0, imageHeghit+60+40+10+10+10+musHeghit+self.tickeMOde.count*60+50, kDeviceWidth, 100)];
        foodView.backgroundColor =[UIColor whiteColor];
        [scroview addSubview:foodView];
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
        foodLabel.text =@"美食介绍";
        [foodView addSubview:foodLabel];
        
        
        UILabel *jsLabel =[[UILabel alloc]initWithFrame:CGRectMake(8, 45, kDeviceWidth-16, 20)];
        jsLabel.textColor =[UIColor grayColor];
        jsLabel.font =[UIFont systemFontOfSize:10];
        jsLabel.text =[NSString stringWithFormat:@"类型:%@       开放时间:%@",oneMode.resourcelevelName,oneMode.opentime];
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
      NSLog(@"******viewTow******\n\n");
    

    
    float tabelHeghit =75*pag;
    pingjiaView =[[UIView alloc]initWithFrame:CGRectMake(0, viewOne+10, kDeviceWidth, 45+tabelHeghit+30)];
    if (self.tickeMOde.count == 0) {
        
      pingjiaView.layer.opacity = 0;  
    }
    
    [scroview addSubview:pingjiaView];
    
    
    [self layeBode:pingjiaView];
    
    viewTwo = 45+tabelHeghit+30;
    
    scroview.contentSize =CGSizeMake(kDeviceWidth, viewTwo+viewOne+10);
    
    {
        UIView *pjheaderView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, 45)];
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
 *  附近推荐
 */
-(void)nearbyButton
{
    
    ZKnearListViewController *near =[[ZKnearListViewController alloc]init:@[oneMode.x,oneMode.y]];
    [self.navigationController pushViewController:near animated:YES];
    
}
/**
 *  预定
 */
-(void)yudingButton:(UIButton*)sender
{
    ZKticketMOde *mode =  self.tickeMOde[sender.tag-1000];
    
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Order" bundle:nil];
    ZKCommitOrderViewController *senceryOrderVC = [story instantiateInitialViewController];
    ZKProduction *tion =[ZKProduction new];
    tion.pzh_name =mode.name;
    tion.pzh_price =mode.price;
    tion.pzh_productID =mode.ID;
    tion.pzh_whichroom =mode.name;
    tion.pzh_usetime =@"";
    tion.pzh_qixian =[NSString stringWithFormat:@"%@,%@",mode.validsdate,mode.validedate] ;
    senceryOrderVC.production =tion;
    [self.navigationController pushViewController:senceryOrderVC animated:YES];
}
/**
 *  720全景
 */
-(void)button720Click
{
    
    
    ZKBasicViewController *web = [[ZKBasicViewController alloc] init];
    NSString *str =[NSString stringWithFormat:@"%@&z_isheadback=false&z_ishidhead=true&z_pagetitle=%@&type=undefined",oneMode.address720,oneMode.name];
    web.webToUrl =[str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [web TOback];
    
    [self.navigationController pushViewController:web animated:YES];

    
}
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
    
    
    [[BaiduMobStat defaultStat] logEvent:@"share_scenery" eventLabel:@"分享景区列表"];
    
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
    [[BaiduMobStat defaultStat] logEvent:@"collect_recreation" eventLabel:@"收藏景区列表"];
    [self collectionAndShare:@"0"];
    
}

-(void)collectionAndShare:(NSString*)typeint;
{

    if ([self isTelnet] ==NO) {
        
        return;
    }
    
    NSMutableDictionary *info = [NSMutableDictionary dictionary];
    [info setObject:@"scenery" forKey:@"type"];
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
    
    ZKGoodsOneMode *pc =[ZKGoodsOneMode new];
    pc. price = oneMode.price;
    pc.exponent =oneMode.exponent;
    pc.type =oneMode.type;
    pc.logosmall = oneMode.logosmall;
    pc.info = oneMode.info;
    pc.resourceLevel =oneMode.resourceLevel;
    pc.phone =oneMode.phone;
    pc.views =oneMode.views;
    pc.resourcelevelName =oneMode.resourcelevelName;
    pc.name =oneMode.name;
    pc.ID =oneMode.ID;
    ZKEvaluationViewController *vc =[[ZKEvaluationViewController alloc]initData:pc];
    
    __weak typeof(self) weekSelf =self;
    [vc succeed:^{
        
        [weekSelf updataTabel];
        
    }];
    [self.navigationController pushViewController:vc animated:YES];
    
    
    
}

/**
 *  加载新的评论
 */
-(void)updataTabel
{


    
    NSMutableDictionary *info = [NSMutableDictionary dictionary];
    [info setObject:@"scenery" forKey:@"type"];
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
    
    if (self.listData.count>0) {
        cell.commentModel = self.listData[indexPath.row];
    }
    
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
     
        
        float webHeight  =foodwebview.scrollView.contentSize.height;
        
        NSLog(@" --000-- %f<<<<<>>>>>%f \n",webHeight,viewOne);
        
        CGPoint point =foodView.frame.origin;
        foodView.frame =CGRectMake(point.x, point.y, kDeviceWidth, 60+webHeight+10);
        foodwebview.frame =CGRectMake(0, 65, kDeviceWidth, webHeight+5);
        
        viewOne =imageHeghit+190+webHeight+10+musHeghit+60*self.tickeMOde.count+50;
        NSLog(@" --111-- %f \n",viewOne);
        pingjiaView.frame =CGRectMake(0, viewOne+10, kDeviceWidth, viewTwo);
        scroview.contentSize =CGSizeMake(kDeviceWidth, viewTwo+viewOne+10);

        
    } completion:^(BOOL finished) {
        pingjiaView.layer.opacity = 1;
        
    }];
 
}

- (NSMutableArray<ZKCommentModel *> *)listData
{
    if (_listData == nil) {
        
        _listData = [NSMutableArray array];
        
    }
    return _listData;
}

- (NSMutableArray<ZKticketMOde *> *)tickeMOde
{
    if (_tickeMOde == nil) {
        
        _tickeMOde = [NSMutableArray array];
        
    }
    return _tickeMOde;
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
