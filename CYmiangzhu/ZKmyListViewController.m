//
//  ZKmyListViewController.m
//  CYmiangzhu
//
//  Created by Daqsoft-Mac on 15/8/11.
//  Copyright (c) 2015年 WangXiaoLa. All rights reserved.
//

#import "ZKmyListViewController.h"
//#import "ZKmyList.h"
#import "ZKmyTableViewCell.h"
#import "ZKregisterViewController.h"
#import "ZKsetViewController.h"
#import "ZKMoreServiceViewController.h"
#import "ZKBasicViewController.h"
#import "ZKContainerLikeViewController.h"
#import "ZKmyOrderViewController.h"
#import "ZKMyNotesViewController.h"
#import "ZKMyFootprintViewController.h"
#import "ZKComplaintsListViewController.h"
#import "ZKAKeyAlarmViewController.h"

@interface ZKmyListViewController ()<UITableViewDataSource,UITableViewDelegate,ZKsetViewControllerDelegate>

{
    
    UIImageView *headportraltImag;
    
    UIButton *headerButton;
    
    float headFlod;
    
    float selcedflod;
    
    UITableView *tabel;
    
    NSString *name;
    
    NSMutableArray *dataArray;
    
    NSArray *tabelName;
    
    UIButton *stateButton;
    
    //每一个按钮的标题
    NSArray *titles;
    
    UIButton *setButton;
}
@end

@implementation ZKmyListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginSucceed) name:ZKUserDidLoginedNotification object:nil];
    
    [self.navigationBarView removeFromSuperview];
    
    headFlod =self.view.frame.size.height*0.35;
    
    selcedflod =self.view.frame.size.height*0.12;
    
    dataArray =[NSMutableArray arrayWithCapacity:0];
    
    
    NSArray *arr1_0 = [NSArray arrayWithObjects:@"我的私人定制",@"table_my_dingz", nil];
    
    NSArray *arr1_1 = [NSArray arrayWithObjects:@"我的游记",@"my_cell_2",nil];
    
    NSArray * arr1 = [[NSArray alloc] initWithObjects:arr1_0,arr1_1, nil];
    
    NSArray *arr5 = [NSArray arrayWithObjects:@"我的投诉",@"my_cell_4",nil];
    
    NSArray *arr6 = [NSArray arrayWithObjects:@"一键报警",@"message_phone",nil];
    
    NSArray *arr7 = [NSArray arrayWithObjects:@"更多服务",@"my_cell_5",nil];
    
    
    tabelName = [[NSArray alloc] initWithObjects:arr1,arr5,arr6,arr7,nil];
    
    [self initView];
    [self updataView];
    [[BaiduMobStat defaultStat] logEvent:@"home_go_my" eventLabel:@"首页-个人中心"];
    // Do any additional setup after loading the view.
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];

}

#pragma mark 视图布局
-(void)initView
{
    
    UIView *bannerView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, headFlod)];
    bannerView.backgroundColor =CYBColorGreen;
    [self.view addSubview:bannerView];
    
    UIImageView*backImage =[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 85, 85)];
    backImage.center =CGPointMake(bannerView.center.x, bannerView.center.y-10);
    backImage.image =[UIImage imageNamed:@"my_headBack"];
    [bannerView addSubview:backImage];
    
    headportraltImag =[[UIImageView alloc]initWithFrame:CGRectMake(0, 0,80, 80)];
    headportraltImag.center =CGPointMake(bannerView.center.x, bannerView.center.y-10);
    headportraltImag.layer.masksToBounds =YES;
    headportraltImag.layer.cornerRadius =40;
    headportraltImag.contentMode = UIViewContentModeScaleAspectFill;
    [bannerView addSubview:headportraltImag];
    
    headerButton = [[UIButton alloc] initWithFrame:headportraltImag.frame];
    headerButton.backgroundColor = [UIColor clearColor];
    [headerButton addTarget:self action:@selector(setClick) forControlEvents:UIControlEventTouchUpInside];
    [bannerView addSubview:headerButton];
    
    
    stateButton =[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
    stateButton.center =CGPointMake(bannerView.center.x, bannerView.center.y+50);
    [stateButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [stateButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    stateButton.titleLabel.textAlignment =NSTextAlignmentCenter;
    stateButton.titleLabel.font =[UIFont systemFontOfSize:15];
    [bannerView addSubview:stateButton];
    
    
    setButton =[[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width-50, 25, 40, 22)];
    setButton.backgroundColor =[UIColor colorWithWhite:0 alpha:0.4];
    [setButton setTitle:@"设置" forState:UIControlStateNormal];
    [setButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    setButton.titleLabel.font =[UIFont systemFontOfSize:13];
    setButton.titleLabel.textAlignment =NSTextAlignmentCenter;
    [setButton addTarget:self action:@selector(setClick) forControlEvents:UIControlEventTouchUpInside];
    setButton.layer.cornerRadius =11;
    
 //--------------
    //占位头像
    UIImage *hd = [UIImage imageNamed:@"detail_head"];
    headportraltImag.image = [UIImage circleImageWithImage:hd borderWidth:0 borderColor:[UIColor whiteColor]];
    //如果用户有登录过
    if ([ZKUserInfo sharedZKUserInfo].ID != nil) {
        setButton.hidden = NO;
        [stateButton removeTarget:self action:@selector(stateClick) forControlEvents:UIControlEventTouchUpInside];
        [stateButton setTitle:[ZKUserInfo sharedZKUserInfo].name forState:UIControlStateNormal];
        [stateButton setTitle:[ZKUserInfo sharedZKUserInfo].name forState:UIControlStateHighlighted];
        [headerButton addTarget:self action:@selector(setClick) forControlEvents:UIControlEventTouchUpInside];
        
        [self loadHeaderImage];
        
    }else{
        setButton.hidden= YES;
        [stateButton addTarget:self action:@selector(stateClick) forControlEvents:UIControlEventTouchUpInside];
        [stateButton setTitle:@"点击登录" forState:UIControlStateNormal];
        [stateButton setTitle:@"点击登录" forState:UIControlStateHighlighted];
        [headerButton removeTarget:self action:@selector(setClick) forControlEvents:UIControlEventTouchUpInside];
    }
 //-------------------
    [self.view addSubview:setButton];
    
    float buttonW =self.view.frame.size.width/4;
    selcedflod =buttonW*0.8;
    
    titles =@[@"我的分享",@"我的收藏",@"我的评价",@"我的订单"];
    for (int i=0; i<4; i++) {
        
        UIView *contView =[[UIView alloc]initWithFrame:CGRectMake(buttonW*i, headFlod, buttonW, selcedflod)];
        contView.backgroundColor =YJCorl(167, 233, 223);
        contView.layer.borderColor =CYBColorGreen.CGColor;
        contView.layer.borderWidth =0.5;
        [self.view addSubview:contView];
        
        UIImageView *secImage =[[UIImageView alloc]initWithFrame:CGRectMake((buttonW*0.7)/2,8,buttonW*0.3, buttonW*0.3)];
        
        secImage.image =[UIImage imageNamed:[NSString stringWithFormat:@"my_for_%d",i]];
        [contView addSubview:secImage];
        
        UILabel *label =[[UILabel alloc]initWithFrame:CGRectMake(5, secImage.frame.size.height+10, buttonW-10, 20)];
        label.text =titles[i];
        label.textAlignment =NSTextAlignmentCenter;
        label.textColor =[UIColor grayColor];
        label.font =[UIFont systemFontOfSize:13];
        [contView addSubview:label];
        
        UIButton *secButton =[[UIButton alloc]initWithFrame:contView.bounds];
        secButton.tag =1000+i;
        [secButton addTarget:self action:@selector(selcedClick:) forControlEvents:UIControlEventTouchUpInside];
        [contView addSubview:secButton];
        
        
    }
    
    
    tabel =[[UITableView alloc]initWithFrame:CGRectMake(0, headFlod+selcedflod, self.view.frame.size.width, self.view.frame.size.height-self.tabBarController.tabBar.frame.size.height-headFlod-selcedflod)];
    tabel.separatorStyle=UITableViewCellSeparatorStyleNone;
    tabel.showsVerticalScrollIndicator =NO;
    tabel.delegate =self;
    tabel.backgroundColor =TabelBackCorl;
    tabel.dataSource =self;
    [self.view addSubview:tabel];
    
    UIView *footView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, 44)];
    tabel.tableFooterView = footView;
    
}

#pragma mark 数据请求


/**
 *  更新数据
 */
-(void)updataView
{
    
    for (int i=0; i<6;i++) {
        
        NSMutableDictionary *dd =[NSMutableDictionary dictionary];
        [dd setObject:[NSNumber numberWithInt:i] forKey:@"index"];
        ZKmyList *mode =[[ZKmyList alloc]initNSdict:dd];
        [dataArray addObject:mode];
    }
    
    [tabel reloadData];
    
    
}


-(void)posDada
{
     [SVProgressHUD showWithStatus:@"努力加载中"];
    NSMutableDictionary *dic =[NSMutableDictionary dictionary];
    [ZKHttp Post:@"" params:dic success:^(id responseObj) {
        
        [SVProgressHUD dismissWithSuccess:@"加载成功"];
        for (int i=0; i<8;i++) {
            
            ZKmyList *mode =[[ZKmyList alloc]initNSdict:nil];
            [dataArray addObject:mode];
        }
        [self updataView];
        [ZKUtil dictionaryToJson:responseObj File:@"ZKmyListViewController"];
        
    } failure:^(NSError *error) {
        
        /**
         *  加载缓存
         */
        NSArray *array =[[ZKUtil File:@"ZKmyListViewController"] valueForKey:@""];
        if (array.count>0) {
            
            [SVProgressHUD dismiss];
            for (int i=0; i<4; i++) {
                
                ZKmyList *mode =[[ZKmyList alloc]initNSdict:nil];
                [dataArray addObject:mode];
            }
            
            [self updataView];
            
        }else{
            
            [self updataView];
           [SVProgressHUD dismissWithError:@"加载失败！"];
        }
        
    }];   
}



#pragma mark 点击事件
/**
 *  设置
 */
-(void)setClick
{
    
    ZKsetViewController *setVc =[[ZKsetViewController alloc]init];
    setVc.delegate = self;
    [self.navigationController pushViewController:setVc animated:YES];
    
    
}
/**
 *  登录
 */
-(void)stateClick
{

    
    ZKregisterViewController *reg =[[ZKregisterViewController alloc]init];
    reg.isMy =YES;
    reg.updateAlertBlock = ^() {

        NSLog(@"调用了b lock");

    };
    
    UINavigationController *nav =[[UINavigationController alloc]initWithRootViewController:reg];
    nav.navigationBarHidden =YES;
    [self presentViewController:nav animated:YES completion:^{
        
    }];
    
}
/**
 *  多按钮点击事件
 *
 *  @param sender
 */
-(void)selcedClick:(UIButton*)sender
{
    
    if ([ZKUserInfo sharedZKUserInfo].ID == nil) {
        
        [self.view makeToast:@"请先登录" duration:0.5 position:nil];
        
        return;
    }
    
    switch (sender.tag) {
        case 1000: {
//            [self jumpToWebUrl:webUrl(@"my_collect.aspx?typeint=1&z_pagetitle=我的分享")];
            ZKContainerLikeViewController *shareVc = [[ZKContainerLikeViewController alloc] init];
            shareVc.likeType = ZKLikeTypeShare;
            [self.navigationController pushViewController:shareVc animated:YES];
            break;
        }
        case 1001: {
//            [self jumpToWebUrl:webUrl(@"my_collect.aspx?typeint=0&z_pagetitle=我的收藏")];
            ZKContainerLikeViewController *collectionVc = [[ZKContainerLikeViewController alloc] init];
            collectionVc.likeType = ZKLikeTypeCollection;
            [self.navigationController pushViewController:collectionVc animated:YES];
            break;
        }
        case 1002:
            [self jumpToWebUrl:webUrl(@"my_comment.aspx?z_pagetitle=我的评价")];
            break;
            
        case 1003: {
            //[self jumpToWebUrl:webUrl(@"s_booking.aspx?z_pagetitle=我的订单")];
            ZKmyOrderViewController *orderVc = [[ZKmyOrderViewController alloc] init];
            [self.navigationController pushViewController:orderVc animated:YES];
            break;
        }
        default:
            break;
    }
    
}

- (void)jumpToWebUrl:(NSString *)webUrl
{
    ZKBasicViewController *web = [[ZKBasicViewController alloc] init];
    web.webToUrl = [webUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    web.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:web animated:YES];
}
#pragma mark - ZKsetViewcontrollerDelegate
- (void)setViewControllerDidOperaton:(ZKsetOperation)operation
{
    
    if (ZKsetOperationSaveUserInfo == operation) {

            setButton.hidden = NO;
            [stateButton removeTarget:self action:@selector(stateClick) forControlEvents:UIControlEventTouchUpInside];
            [stateButton setTitle:[ZKUserInfo sharedZKUserInfo].name forState:UIControlStateNormal];
            [stateButton setTitle:[ZKUserInfo sharedZKUserInfo].name forState:UIControlStateHighlighted];
            [headerButton addTarget:self action:@selector(setClick) forControlEvents:UIControlEventTouchUpInside];
        
            //加载头像
            UIImage * hImage = [ZKUtil fetchImage:[ZKUserInfo sharedZKUserInfo].ID];
          UIImage *scaledImage = [hImage imageByScalingAndCroppingForSize:CGSizeMake(80, 80)];
            headportraltImag.image = [UIImage circleImageWithImage:scaledImage borderWidth:0 borderColor:[UIColor whiteColor]];

    }else if (ZKsetOperationCancelAuth == operation){
    
            setButton.hidden= YES;
            [stateButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
            [stateButton setTitle:@"点击登录" forState:UIControlStateNormal];
            [stateButton setTitle:@"点击登录" forState:UIControlStateHighlighted];
            [stateButton addTarget:self action:@selector(stateClick) forControlEvents:UIControlEventTouchUpInside];
            [headerButton removeTarget:self action:@selector(setClick) forControlEvents:UIControlEventTouchUpInside];
            
            //清空头像
            UIImage *hd = [UIImage imageNamed:@"detail_head"];
            headportraltImag.image = [UIImage circleImageWithImage:hd borderWidth:0 borderColor:[UIColor whiteColor]];;
        
    }

}

/**
 *  登录成功后的回调
 */
- (void)loginSucceed
{
    
    setButton.hidden = NO;
    [stateButton removeTarget:self action:@selector(stateClick) forControlEvents:UIControlEventTouchUpInside];
    [stateButton setTitle:[ZKUserInfo sharedZKUserInfo].name forState:UIControlStateNormal];
    [stateButton setTitle:[ZKUserInfo sharedZKUserInfo].name forState:UIControlStateHighlighted];
    [headerButton addTarget:self action:@selector(setClick) forControlEvents:UIControlEventTouchUpInside];
    
    [self loadHeaderImage];
 
}

/**
 *  加载头像
 */
- (void)loadHeaderImage
{
    UIImage * hImage = [ZKUtil fetchImage:[ZKUserInfo sharedZKUserInfo].ID];
    if (hImage) {
        headportraltImag.image = hImage;
    }else{
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[ZKUserInfo sharedZKUserInfo].photo]];
            UIImage * image = [UIImage imageWithData:imageData];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if (imageData) {
                    UIImage *scaledImage = [image imageByScalingAndCroppingForSize:CGSizeMake(80, 80)];
                    headportraltImag.image = [UIImage circleImageWithImage:scaledImage borderWidth:0 borderColor:[UIColor whiteColor]];
                    [ZKUtil setPhotoToPath:UIImagePNGRepresentation(image) isName:[ZKUserInfo sharedZKUserInfo].ID];
                }
            });
        });
    }
}



#pragma mark table代理
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 4;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{

    if (section ==0){
        
        return 2;
        
    }else{
    
        return 1;
    }
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    ZKmyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"ZKmyTableViewCell" owner:nil options:nil];
        cell = [array lastObject];
        
        UIView *lin =[[UIView alloc]initWithFrame:CGRectMake(10, 43.5, self.view.frame.size.width-5, 0.7)];
        lin.backgroundColor =TabelBackCorl;
        [cell addSubview:lin];
        
    }
    
    
    NSArray *titsArray = [tabelName objectAtIndex:indexPath.section];
    
    
    
    if (indexPath.section == 0) {
        
        
        NSArray *pArray =titsArray[indexPath.row];
        
        cell.lefIMage.image =[UIImage imageNamed:[NSString stringWithFormat:@"%@",pArray[1]]];
        cell.leiLabel.text =pArray[0];
        
    }else{
    
        cell.lefIMage.image =[UIImage imageNamed:[NSString stringWithFormat:@"%@",titsArray[1]]];
        cell.leiLabel.text =titsArray[0];

    }
    
    
    
    if (indexPath.section ==3) {
        
        cell.ritLabel.text =@"咨询服务";
    }

    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (dataArray.count==0) {
        return;
    }
    
    if ([ZKUserInfo sharedZKUserInfo].ID == nil) {
        
        [self.view makeToast:@"请先登录" duration:0.5 position:nil];
        return;
    }
    
    if (indexPath.section ==3) {
        
        /**
         *  更多服务
         */
        [[BaiduMobStat defaultStat] logEvent:@"service_go_calls" eventLabel:@"服务-咨询服务"];
//         [self jumpToWebUrl:webUrl(@"newsServ.aspx?z_pagetitle=咨询服务")];

        ZKMoreServiceViewController *more =[[ZKMoreServiceViewController alloc]init];
        [self.navigationController pushViewController:more animated:YES];
        
    }
    
    if (indexPath.section == 2) {

        ZKAKeyAlarmViewController *aKeyVC =[[ZKAKeyAlarmViewController alloc]init];
        [self.navigationController pushViewController:aKeyVC animated:YES];

        [[BaiduMobStat defaultStat] logEvent:@"service_go_emergent" eventLabel:@"服务-一键报警"];
    }
    
    if (indexPath.section ==0) {

        /**
         *  我的抢购
         */
        if (indexPath.row ==0) {
            
          [self jumpToWebUrl:webUrl(@"s_mydz.aspx?z_pagetitle=我的私人定制")];
            
        }else{
        
            ZKMyNotesViewController *myNotesVc = [[ZKMyNotesViewController alloc] init];
            [self.navigationController pushViewController:myNotesVc animated:YES];
            
            
        }
        
        
    }
    
    if (indexPath.section ==1) {
        
        ZKComplaintsListViewController *complaintsVc = [[ZKComplaintsListViewController alloc] init];
        [self.navigationController pushViewController:complaintsVc animated:YES];
        
    }

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}




-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [[UIView alloc]init];
}


@end
