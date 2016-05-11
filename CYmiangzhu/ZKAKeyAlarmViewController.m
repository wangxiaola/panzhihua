//
//  ZKAKeyAlarmViewController.m
//  CYmiangzhu
//
//  Created by Daqsoft-Mac on 15/8/17.
//  Copyright (c) 2015年 WangXiaoLa. All rights reserved.
//

#import "ZKAKeyAlarmViewController.h"
#import "ZKAnnounciatorView.h"
#import <CoreLocation/CoreLocation.h>

@interface ZKAKeyAlarmViewController ()<CLLocationManagerDelegate>


@property (nonatomic, strong) NSArray *titisArray;

@property (nonatomic, strong) NSMutableArray <UIButton*>*buttonArray;

@property (nonatomic, assign)double Latitude;

@property (nonatomic, assign)double Longitude;

@property (nonatomic, strong) NSString *key;

@property (nonatomic, strong) CLLocationManager  *locationManager;

@end


@implementation ZKAKeyAlarmViewController

@synthesize titisArray;
- (instancetype)init
{
    self = [super init];
    
    if (self) {
        
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}
- (NSMutableArray<UIButton *> *)buttonArray
{
    if (!_buttonArray) {
        _buttonArray = [NSMutableArray array];
    }
    return _buttonArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.titeLabel.text =@"一键报警";
    self.rittBarButtonItem =[[UIButton alloc]initWithFrame:CGRectMake(kDeviceWidth-2-40, 20, 40, 40)];
    self.rittBarButtonItem.backgroundColor =[UIColor clearColor];
    self.rittBarButtonItem.titleLabel.textColor =[UIColor whiteColor];
    self.rittBarButtonItem.titleLabel.font =[UIFont systemFontOfSize:12];
    self.rittBarButtonItem.titleLabel.font =[UIFont boldSystemFontOfSize:12];
    [self.rittBarButtonItem setImage:[UIImage imageNamed:@"hom"] forState:UIControlStateNormal];
    [self.rittBarButtonItem addTarget:self action:@selector(homClick) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationBarView addSubview: self.rittBarButtonItem];
    
    UIImageView *backImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 64, kDeviceWidth, kDeviceHeight-64)];
    [backImage setImage:[UIImage imageNamed:@"bg_police.jpg"]];
    [self.view addSubview:backImage];
    
    ZKAnnounciatorView *announciatorView = [[ZKAnnounciatorView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth*3/5, kDeviceWidth*3/5)];
    announciatorView.layer.masksToBounds = YES;
    announciatorView.center = CGPointMake(kDeviceWidth/2, kDeviceHeight/2-(kDeviceWidth/4)-10);
    announciatorView.layer.cornerRadius = kDeviceWidth*3/10;
    announciatorView.clipsToBounds = YES;
    [self.view addSubview:announciatorView];
    
    __weak typeof(self)weekSelf =self;
    
    [announciatorView  selClick:^{
        
     [weekSelf police];
        
    }];
    
    [self postDate];
    [self initView];
    [self locan];
    
}

- (void)postDate
{
    NSMutableDictionary *dic_0 = [NSMutableDictionary dictionary];
    [dic_0 setObject:@"reportType" forKey:@"method"];
    [dic_0 setObject:@"json" forKey:@"format"];

    [ZKHttp Post_data:@"http://183.221.61.239:83/rest/appthree" params:dic_0 success:^(id responseObj) {
        NSLog(@"%@",responseObj);
        titisArray = [responseObj valueForKey:@"rows"];
        [self supView];
    } failure:^(NSError *error) {
        
    }];

}
/**
 *  报警
 */
- (void)police
{


    if (!self.key) {
        
        if (self.titisArray.count == 0 && !self.Latitude) {
            
            [self.view makeToast:@"正在加载数据，请稍等！"];
            return;
        }
        self.key = [self.titisArray[self.titisArray.count-1] valueForKey:@"skey"];
        
        
    }
    if (![ZKUserInfo sharedZKUserInfo].ID) {
        [self.view makeToast:@"请先登录！"];
        
    }else{
    
    
        [SVProgressHUD show];
        
        NSMutableDictionary *dic_0 = [NSMutableDictionary dictionary];
        
        NSString *name = [ZKUserInfo sharedZKUserInfo].truename ? [ZKUserInfo sharedZKUserInfo].truename:@"攀枝花APP-游客";
        
        [dic_0 setObject:name forKey:@"name"];
        [dic_0 setObject:[ZKUserInfo sharedZKUserInfo].mobile forKey:@"phone"];
        [dic_0 setObject:self.key forKey:@"skey"];
        [dic_0 setObject:[NSNumber numberWithFloat:_Longitude] forKey:@"longitude"];
        [dic_0 setObject:[NSNumber numberWithFloat:_Latitude] forKey:@"latitude"];

        
        [ZKHttp Post_data:@"http://183.221.61.239:83/rest/appthree?format=json" params:dic_0 success:^(id responseObj) {
            
            [SVProgressHUD dismissWithSuccess:@"上报成功" afterDelay:1];

            int64_t delayInSeconds = 1.0;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                
                [self.navigationController popViewControllerAnimated:YES];
            });
          
            
        } failure:^(NSError *error) {
            
            [SVProgressHUD dismissWithError:@"网络错误!"];
        }];

        
    }
    
    
    
}
- (void)initView
{

    UILabel *annouLabel_0 = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth*3/5, 20)];
    annouLabel_0.font = [UIFont systemFontOfSize:14];
    annouLabel_0.textColor = [UIColor whiteColor];
    annouLabel_0.textAlignment = NSTextAlignmentCenter;
    annouLabel_0.center = CGPointMake(kDeviceWidth/2, kDeviceHeight/2+30);
    [self.view addSubview:annouLabel_0];
    annouLabel_0.text = @"点击向应急平台指挥中心求助";
    
    UILabel *annouLabel_1 = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth*3/5, 20)];
    annouLabel_1.font = [UIFont systemFontOfSize:14];
    annouLabel_1.textAlignment = NSTextAlignmentCenter;
    annouLabel_1.textColor = [UIColor whiteColor];
    annouLabel_1.center = CGPointMake(kDeviceWidth/2, kDeviceHeight/2+50);
    [self.view addSubview:annouLabel_1];
    annouLabel_1.text = @"请确认打开GPS位置";
    
    UIImageView *lefImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth/4, 1)];
    lefImage.center = CGPointMake(kDeviceWidth/4-10, kDeviceHeight-168);
    lefImage.image = [UIImage imageNamed:@"text_left"];
    [self.view addSubview:lefImage];
    
    UIImageView *ritImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth/4, 1)];
    ritImage.center = CGPointMake(kDeviceWidth-kDeviceWidth/4+10, kDeviceHeight-168);
    ritImage.image = [UIImage imageNamed:@"text_right"];
    [self.view addSubview:ritImage];
    
    
    UILabel *inforLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth*3/5, 20)];
    inforLabel.font = [UIFont systemFontOfSize:13];
    inforLabel.textAlignment = NSTextAlignmentCenter;
    inforLabel.textColor = [UIColor whiteColor];
    inforLabel.center = CGPointMake(kDeviceWidth/2, kDeviceHeight-168);
    [self.view addSubview:inforLabel];
    inforLabel.text = @"应急求助分类";
    
    
}

#pragma mark 点击事件
- (void)click:(UIButton*)sender
{
  
    
    UIImage *image_s = [UIImage imageNamed:@"buttonSelce"];
    UIImage *image_d = [UIImage imageNamed:@"buttondismm"];
    

    [self.buttonArray enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        self.key = [self.titisArray[sender.tag-1000] valueForKey:@"skey"];
        if (obj.tag == sender.tag) {
            
            [obj setBackgroundImage:[image_s stretchableImageWithLeftCapWidth:image_s.size.width * 0.5 topCapHeight:image_s.size.height * 0.5] forState:UIControlStateNormal];
        }else{
        
            [obj setBackgroundImage:[image_d stretchableImageWithLeftCapWidth:image_d.size.width * 0.5 topCapHeight:image_d.size.height * 0.5] forState:UIControlStateNormal];
        }
    }];
    
    
}
-(void)homClick
{
    
    self.tabBarController.selectedIndex =0;
    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:0] animated:YES];
    
}
/**
 *  添加标签
 */
- (void)supView
{

    UIView *buttonView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, 30*3)];
    buttonView.backgroundColor = [UIColor clearColor];
    buttonView.center = CGPointMake(kDeviceWidth/2, kDeviceHeight - 90);
    [self.view addSubview:buttonView];
    
    float bJu = 20;
    float buttonW = (kDeviceWidth-bJu*2)/5;
    float jianxi = 6;
    float buttonH = 24;
    
    for (int i = 0; i < titisArray.count; i++) {
        
        UIButton *bty = [[UIButton alloc]init];
        bty.frame = CGRectMake(bJu+buttonW*(i%5), (buttonH+jianxi)*(i/5), buttonW-jianxi, buttonH);
        

        UIImage *image_d = [UIImage imageNamed:@"buttondismm"];

        [bty setBackgroundImage:[image_d stretchableImageWithLeftCapWidth:image_d.size.width * 0.5 topCapHeight:image_d.size.height * 0.5] forState:UIControlStateNormal];
        
        [bty setTitle:[titisArray[i] valueForKey:@"name"] forState:0];
        bty.tag = i+1000;
        [bty setTitleColor:[UIColor whiteColor] forState:0];
        bty.titleLabel.font = [UIFont systemFontOfSize:10];
        [bty addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
        [buttonView addSubview:bty];
        [self.buttonArray addObject:bty];
        
        
    }


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
    
    _Latitude =currLocation.coordinate.latitude;
    _Longitude =currLocation.coordinate.longitude;
    [_locationManager stopUpdatingLocation];
    

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
