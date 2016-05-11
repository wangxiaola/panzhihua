//
//  ZKHotelDetailViewController.m
//  CYmiangzhu
//
//  Created by 汤亮 on 16/1/7.
//  Copyright © 2016年 WangXiaoLa. All rights reserved.
//

#import "ZKHotelDetailViewController.h"
#import "ZKMutiCalendarViewController.h"
#import "ZKCommentViewController.h"
#import "ZKregisterViewController.h"
#import "ZKHotelCommitOrderViewController.h"
#import "ZKActivitiesShareViewController.h"
#import "ZKnearListViewController.h"
#import "ZKMapNavController.h"
#import "ZKscenicSpotList.h"
#import "ZKDetailHeaderView.h"
#import "ZKCommentModel.h"
#import "ZKBookRoomModel.h"
#import "ZKProduction.h"
#import "ZKDetailAddressView.h"
#import "ZKDetailTimeView.h"
#import "ZKDetailNearView.h"
#import "ZKDetailHotelInfoView.h"
#import "ZKDetailCommentView.h"
#import "ZKBookRoomCell.h"
#import "ZKCommentCell.h"
#import "ZKHotelDescriptionCell.h"
#import <CoreLocation/CoreLocation.h>

@interface ZKHotelDetailViewController ()<UITableViewDataSource, UITableViewDelegate, ZKMutiCalendarViewControllerDelegate,CLLocationManagerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) CLLocationManager  *locationManager;
@property (nonatomic, strong) NSMutableArray<ZKCommentModel *> *commentModels;
@property (nonatomic, strong) NSMutableArray<ZKBookRoomModel *> *bookRoomModels;
@property (nonatomic, assign) double stateHeadHeghit;
@property (nonatomic, strong) ZKDetailTimeView *detailTimeView;

@property (nonatomic, copy) NavigationBlock navigationBlock;
@property (nonatomic, copy) SelectDateBlock selectDateBlock;
@property (nonatomic, copy) NearRecommendBlock nearRecommendBlock;
@property (nonatomic, copy) CommentBlock commentBlock;


@property(nonatomic,assign)double Latitude;
@property(nonatomic,strong)NSString *myAdd;
@property(nonatomic,assign)double Longitude;

@property (nonatomic, copy) BOOL (^checkLoginBlock)();

@property (nonatomic, copy) NSString *hotelInfo;
@property (nonatomic, assign) CGFloat hotelInfoHeight;

@end

@implementation ZKHotelDetailViewController

@synthesize stateHeadHeghit;

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
    
    _Latitude =currLocation.coordinate.latitude;
    _Longitude =currLocation.coordinate.longitude;
    [ZKUtil MyValue:[NSString stringWithFormat:@"%f",_Latitude] MKey:@"Latitude"];
    [ZKUtil MyValue:[NSString stringWithFormat:@"%f",_Longitude] MKey:@"Longitude"];
    [_locationManager stopUpdatingLocation];
    
    CLLocation *c = [[CLLocation alloc] initWithLatitude:_Latitude longitude:_Longitude];
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
                               dict);
                         
                         NSString *str =[dict objectForKey:@"Name"];
                         
                         str =[str stringByReplacingOccurrencesOfString:@"中国" withString:@""];
                         _myAdd =str;
                         [ZKUtil MyValue:str MKey:@"adder"];
                         [ZKUtil MyValue:[dict objectForKey:@"City"] MKey:@"myCity"];
                         
                         
                     }
                     else
                     {
                         
                         
                         NSLog(@"ERROR: %@", error); }
                 }];
}



- (BOOL (^)())checkLoginBlock
{
    if (!_checkLoginBlock) {
        __weak typeof(self) weakSelf = self;
        _checkLoginBlock =  ^BOOL() {
            if ([ZKUserInfo sharedZKUserInfo].ID == nil) {
                ZKregisterViewController *vc =[[ZKregisterViewController alloc]init];
                vc.isMy =YES;
                UINavigationController *nav =[[UINavigationController alloc]initWithRootViewController:vc];
                nav.navigationBarHidden =YES;
                [weakSelf.navigationController presentViewController:nav animated:YES completion:nil];
                return NO;
            }else {
                return YES;
            }
        };
    }
    return _checkLoginBlock;
}

- (CommentBlock)commentBlock
{
    if (!_commentBlock) {
        __weak typeof(self) weakSelf = self;
        _commentBlock = ^{
            if (self.checkLoginBlock() == NO) {
                return;
            }
            ZKCommentViewController *commentVc = [[ZKCommentViewController alloc] initData:weakSelf.hotelModel];
            
            [commentVc succeed:^{
                [weakSelf fetchCommentData];
            }];
            [weakSelf.navigationController pushViewController:commentVc animated:YES];
        };
    }
    return _commentBlock;
}

- (NearRecommendBlock)nearRecommendBlock
{
    if (!_nearRecommendBlock) {
        __weak typeof(self) weakSelf = self;
        _nearRecommendBlock = ^{
            ZKnearListViewController *nearVC = [[ZKnearListViewController alloc] init:@[[NSString stringWithFormat:@"%f", weakSelf.hotelModel.x], [NSString stringWithFormat:@"%f", weakSelf.hotelModel.y]]];
            [weakSelf.navigationController pushViewController:nearVC animated:YES];
        };
    }
    return _nearRecommendBlock;
}

- (SelectDateBlock)selectDateBlock
{
    if (!_selectDateBlock) {
        __weak typeof(self) weakSelf = self;
        _selectDateBlock = ^{
            
            ZKMutiCalendarViewController *selectDateVC = [[ZKMutiCalendarViewController alloc] init];
            selectDateVC.delegate = weakSelf;
            
           NSDate *enterDate = [weakSelf dateFromString:weakSelf.detailTimeView.enterTime];
            NSDate * leaveDate = [weakSelf dateFromString:weakSelf.detailTimeView.leaveTime];
            
            [weakSelf presentViewController:selectDateVC animated:YES completion:^{
                
            [selectDateVC didSelectRangeFrom:enterDate to:leaveDate];
                
            }];
           
        };
    }
    return _selectDateBlock;
}
/**
 *  时间转换
 *
 *  @param str 时间字符
 *
 *  @return date
 */
- (NSDate*)dateFromString:(NSString*)str;
{

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat: @"yyyy-MM-dd"];

    NSDate *destDate= [dateFormatter dateFromString:str];

    return destDate;

}
- (NavigationBlock)navigationBlock
{
    if (!_navigationBlock) {
        __weak typeof(self) weakSelf = self;
        double toLatitude =_Latitude;
        double toLongitude =_Longitude;
        _navigationBlock = ^{
            if (weakSelf.hotelModel.x > 0 && weakSelf.hotelModel.y > 0 && toLatitude > 0 && toLongitude > 0) {

                
               ZKMapNavController *mapVC = [[ZKMapNavController alloc] initKLat:toLatitude KLon:toLongitude Kadder:weakSelf.myAdd WLat:weakSelf.hotelModel.y WLon:weakSelf.hotelModel.x WAdder:weakSelf.hotelModel.address code:@""];
                [weakSelf.navigationController pushViewController:mapVC animated:YES];
                
            }else {
                [weakSelf.view makeToast:@"暂无导航"];
            }
        };
    }
    return _navigationBlock;
}

- (ZKDetailTimeView *)detailTimeView
{
    if (!_detailTimeView) {
        _detailTimeView = [ZKDetailTimeView detailTimeView];
        _detailTimeView.selectDateBlock = self.selectDateBlock;
    }
    return _detailTimeView;
}

- (NSMutableArray<ZKBookRoomModel *> *)bookRoomModels
{
    if (!_bookRoomModels) {
        _bookRoomModels = [NSMutableArray array];
    }
    return _bookRoomModels;
}

- (NSMutableArray<ZKCommentModel *> *)commentModels
{
    if (!_commentModels) {
        _commentModels = [NSMutableArray array];
    }
    return _commentModels;
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    NSLog(@"%@\n%@", self.hotelModel.info, self.hotelModel.ID);
    [self setupNavBar];
    [self configTableView];
    [self setupTableHeaderView];
    [self fetchBookRoomData];
    [self fetchHotelInfoData];
    [self fetchCommentData];
    
    stateHeadHeghit = 0.01;
    
    self.Latitude = [ZKUtil ToTakeTheKey:@"Latitude"].doubleValue;
    self.Longitude = [ZKUtil ToTakeTheKey:@"Longitude"].doubleValue;
    self.myAdd = [ZKUtil ToTakeTheKey:@"adder"];
    
    [self locan];
}

- (void)fetchHotelInfoData
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"method"] = @"resoureDetail";
    params[@"type"] = @"hotel";
    params[@"id"] = self.hotelModel.ID;
    [ZKHttp Post:@"" params:params success:^(id responseObj) {
        self.hotelInfo = [responseObj[@"info"] isKindOfClass:[NSNull class]] ? @"" : responseObj[@"info"];
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:3] withRowAnimation:UITableViewRowAnimationNone];
    } failure:^(NSError *error) {}];
}

- (void)fetchCommentData
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"method"] = @"commentlist";
    params[@"id"] = self.hotelModel.ID;
    params[@"type"] = @"hotel";
    [ZKHttp Post:@"" params:params success:^(id responseObj) {
        self.commentModels = [ZKCommentModel objectArrayWithKeyValuesArray:responseObj[@"rows"]];
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:4] withRowAnimation:UITableViewRowAnimationNone];
    } failure:^(NSError *error) {}];
}

- (void)fetchBookRoomData
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"method"] = @"productmsg";
    params[@"outid"] = self.hotelModel.ID;
    params[@"page"] = @"1";
    params[@"pagesize"] = @"100";
    params[@"typecode"] = @"kefang";
    params[@"interfaceId"] = @"6";
    params[@"TimeStamp"] = [ZKUtil timeStamp];
    [ZKHttp post:universalServerUrl params:params success:^(id responseObj) {
        if ([responseObj[@"errmsg"] isEqualToString:@"SUCCESS"]) {
            self.bookRoomModels = [ZKBookRoomModel objectArrayWithKeyValuesArray:responseObj[@"root"][@"rows"]];
            
            stateHeadHeghit = self.bookRoomModels.count == 0 ? 0.01: 40;
            
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
        }
    } failure:^(NSError *error) {}];
}

- (void)setupNavBar
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.titeLabel.text = self.hotelModel.name;
    
    self.rittBarButtonItem =[[UIButton alloc]initWithFrame:CGRectMake(kDeviceWidth-2-40, 20, 40, 40)];
    self.rittBarButtonItem.backgroundColor =[UIColor clearColor];
    self.rittBarButtonItem.titleLabel.textColor =[UIColor whiteColor];
    self.rittBarButtonItem.titleLabel.font =[UIFont systemFontOfSize:12];
    self.rittBarButtonItem.titleLabel.font =[UIFont boldSystemFontOfSize:12];
    [self.rittBarButtonItem setImage:[UIImage imageNamed:@"my_for_0"] forState:UIControlStateNormal];
    [self.rittBarButtonItem addTarget:self action:@selector(share) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationBarView addSubview: self.rittBarButtonItem];
    
    self.rittBarButtonItem2 =[[UIButton alloc]initWithFrame:CGRectMake(kDeviceWidth-2-70, 20, 40, 40)];
    self.rittBarButtonItem2.backgroundColor =[UIColor clearColor];
    self.rittBarButtonItem2.titleLabel.textColor =[UIColor whiteColor];
    self.rittBarButtonItem2.titleLabel.font =[UIFont systemFontOfSize:12];
    self.rittBarButtonItem2.titleLabel.font =[UIFont boldSystemFontOfSize:12];
    [self.rittBarButtonItem2 setImage:[UIImage imageNamed:@"my_for_1"] forState:UIControlStateNormal];
    [self.rittBarButtonItem2 addTarget:self action:@selector(collect) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationBarView addSubview: self.rittBarButtonItem2];
}

- (void)share
{
    if (self.checkLoginBlock() == NO) {
        return;
    }
    
    [[BaiduMobStat defaultStat] logEvent:@"share_hotel" eventLabel:@"分享酒店列表"];
    
    ZKActivitiesShareViewController *activ =[[ZKActivitiesShareViewController alloc]initImageUrl:[NSString stringWithFormat:@"%@%@",imageUrlPrefix,self.hotelModel.logosmall]  Theme:self.hotelModel.name  Name:self.hotelModel.address Lurl:nil];
    
    __weak typeof(self)weekSelf =self;
    [activ shareSuccess:^{
        [weekSelf collectionAndShare:@"1"];
    }];
    
    [self.navigationController pushViewController:activ animated:YES];
}

- (void)collect
{
    [[BaiduMobStat defaultStat] logEvent:@"collect_hotel" eventLabel:@"收藏酒店列表"];
    
    [self collectionAndShare:@"0"];
}

-(void)collectionAndShare:(NSString*)typeint;
{
    if (self.checkLoginBlock() == NO) {
        return;
    }
    NSMutableDictionary *info = [NSMutableDictionary dictionary];
    [info setObject:@"hotel" forKey:@"type"];
    [info setObject:typeint forKey:@"typeint"];
    [info setObject:@"collectionAndShare" forKey:@"method"];
    [info setObject:[ZKUserInfo sharedZKUserInfo].ID forKey:@"memberid"];
    [info setObject:self.hotelModel.ID forKey:@"id"];
    [ZKHttp Post:@"" params:info success:^(id responseObj) {

        [self.view makeToast:[responseObj valueForKey:@"msg"]];
        
    } failure:^(NSError *error) {
        [self.view makeToast:@"网络出错了!"];
    }];


}
- (void)configTableView
{
    [self.tableView registerNib:[UINib nibWithNibName:@"ZKBookRoomCell" bundle:nil] forCellReuseIdentifier:ZKBookRoomCellID];
    [self.tableView registerNib:[UINib nibWithNibName:@"ZKCommentCell" bundle:nil] forCellReuseIdentifier:ZKCommentCellID];
    [self.tableView registerNib:[UINib nibWithNibName:@"ZKHotelDescriptionCell" bundle:nil] forCellReuseIdentifier:ZKHotelDescriptionCellID];
}

- (void)setupTableHeaderView
{
    ZKDetailHeaderView *headerView = [[ZKDetailHeaderView alloc] init];
    headerView.frame = CGRectMake(0, 0, self.tableView.frame.size.width, 150);
    headerView.hotelModel = self.hotelModel;
    self.tableView.tableHeaderView = headerView;
}


- (void)mutiCalendarViewController:(ZKMutiCalendarViewController *)mutiCalendarViewController didSelectRangeFrom:(NSDate *)startDate to:(NSDate *)endDate dayCount:(NSInteger)dayCount
{
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-M-d";
    fmt.locale = [NSLocale localeWithLocaleIdentifier:@"en_US"];
    NSString *start = [fmt stringFromDate:startDate];
    NSString *end = [fmt stringFromDate:endDate];
    [self.detailTimeView setEnterTime:start leaveTime:end dayCount:dayCount];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0 || section == 2) {
        return 0;
    }else if (section == 1) {
        return self.bookRoomModels.count;
    }else if (section == 3) {
        return self.hotelInfo ? 1 : 0;
    }
    return self.commentModels.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        ZKDetailAddressView *detailAddressView = [ZKDetailAddressView detailAddressView];
        detailAddressView.hotelModel = self.hotelModel;
        detailAddressView.navigationBlock = self.navigationBlock;
        return detailAddressView;
    }else if (section == 1) {
        
        return stateHeadHeghit <= 0.03 && stateHeadHeghit >= 0? [[UIView alloc] init]:self.detailTimeView;
        
    }else if (section == 2) {
        ZKDetailNearView *detailNearView = [ZKDetailNearView detailNearView];
        detailNearView.nearRecommendBlock = self.nearRecommendBlock;
        return detailNearView;
    }else if (section == 3) {
        return [ZKDetailHotelInfoView detailHotelInfoView];
    }else if (section == 4) {
        ZKDetailCommentView *detailCommentView = [ZKDetailCommentView detailCommentView];
        detailCommentView.hotelModel = self.hotelModel;
        detailCommentView.commentBlock = self.commentBlock;
        return detailCommentView;
    }
    return nil;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        ZKBookRoomCell *bookRoomCell = [tableView dequeueReusableCellWithIdentifier:ZKBookRoomCellID];
        ZKBookRoomModel *bookRoomModel = self.bookRoomModels[indexPath.row];
        bookRoomCell.bookRoomModel = bookRoomModel;
        __weak typeof(self) weakSelf = self;
        bookRoomCell.bookRoomBlock = ^{
            ZKProduction *production = [[ZKProduction alloc] init];
            production.pzh_productID = bookRoomModel.ID;
            production.pzh_name = bookRoomModel.name;
            production.pzh_price = [[NSString stringWithFormat:@"%.2f", bookRoomModel.price] stringByReplacingOccurrencesOfString:@".00" withString:@""];
            production.pzh_qixian = [NSString stringWithFormat:@"%@,%@", self.detailTimeView.enterTime, self.detailTimeView.leaveTime];
            UIStoryboard *story = [UIStoryboard storyboardWithName:@"Order" bundle:nil];
            ZKHotelCommitOrderViewController *hotelOrderVC = [story instantiateViewControllerWithIdentifier:@"HotelCommit"];
            hotelOrderVC.production = production;
            [weakSelf.navigationController pushViewController:hotelOrderVC animated:YES];
        };
        return bookRoomCell;
    }else if (indexPath.section == 3) {
        ZKHotelDescriptionCell *hotelDescriptionCell = [tableView dequeueReusableCellWithIdentifier:ZKHotelDescriptionCellID];
        [hotelDescriptionCell loadHtmlString:self.hotelInfo];
        return hotelDescriptionCell;
    }else if (indexPath.section == 4) {
        
        ZKCommentCell *commentCell = [tableView dequeueReusableCellWithIdentifier:ZKCommentCellID];
        commentCell.commentModel = self.commentModels[indexPath.row];
        return commentCell;
    }
    
    return [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"dasdasda"];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 77;
    }else if ( section == 2 || section == 3) {
        return 44;
    }else if(section == 1){
    
     return stateHeadHeghit == 0.01 ? 0.01 : 40;
        
    }
    return 66;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{

   if (section == 1){
    
       return stateHeadHeghit == 0.01 ? 0.01 : 10;
       
   }else if (section == 4){
   
       return 0.01;
   }
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 || indexPath.section == 2) {
        return 0;
    }else if (indexPath.section == 1) {
        return 66;
    }else if (indexPath.section == 3) {
        return UITableViewAutomaticDimension;
    }
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 || indexPath.section == 2) {
        return 0;
    }else if (indexPath.section == 1) {
        return 66;
    }else if (indexPath.section == 3) {
        return 44;
    }
    return 75;
}


@end
