//
//  DQNavViewController.m
//  changyouyibin
//
//  Created by Daqsoft-Mac on 14/12/16.
//  Copyright (c) 2014年 WangXiaoLa. All rights reserved.
//

#import "ZKsecrtMapViewController.h"
#import "MapView.h"
#import "Item.h"
#import "TestMapCell.h"
#import "CallOutAnnotationView.h"
#import "RoutePlanViewController.h"
#import "ZKAppDelegate.h"
#import "DQNavSelectView.h"
#import "ZKtextFieldThinkView.h"
#import "BasicMapAnnotation.h"

#import "ZKMapNavController.h"

#import "GSLocationTool.h"
@interface ZKsecrtMapViewController ()<MapViewDelegate,CLLocationManagerDelegate,DQNavSelectViewDeleget,UITextFieldDelegate,ZKtextFieldThinkViewDelegate>
{
    
    TestMapCell *cell;
    
    NSMutableArray *_annotations;
    
    UIButton *seleButton;
    
    NSString *key;
    
    UIButton *locationButton;
    
    DQNavSelectView *selectView;
    
    UITextField *seekText;
    
    NSMutableArray *sceneryArray;
    NSMutableArray *diningArray;
    NSMutableArray *hotelArray;
    NSMutableArray *shoppingArray;
    NSMutableArray *recreationArray;
    NSMutableArray *restsArray;
    
    
    NSArray *typeArray ;
    
    
    NSString *dataString;
    
    /**
     *  联想view
     */
    ZKtextFieldThinkView *thinkView;
    
    BOOL isThink;
    
    
    NSString *myadd;
    
    double myLatitude;
    
    double myLongitude;
}

@property (nonatomic,strong)MapView *mapView;


@property (nonatomic, strong) CLLocationManager  *locationManager;
@end

@implementation ZKsecrtMapViewController

-(id)init;
{
    self =[super init];
    if (self) {
        
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self locan];
    //    我的位置
    myadd =[ZKUtil ToTakeTheKey:@"adder"];
    myLatitude =[[ZKUtil ToTakeTheKey:@"Latitude"] doubleValue];
    myLongitude =[[ZKUtil ToTakeTheKey:@"Longitude"]doubleValue];
    
    
    isThink =NO;
    
    [self.leftBarButtonItem removeFromSuperview];
    
    
    key =@"";
    
    [[BaiduMobStat defaultStat] logEvent:@"home_go_near" eventLabel:@"首页-附近"];
    
    _annotations    =[[NSMutableArray alloc]initWithCapacity:0];
    
    sceneryArray    =[[NSMutableArray alloc]initWithCapacity:0];
    diningArray     =[[NSMutableArray alloc]initWithCapacity:0];
    hotelArray      =[[NSMutableArray alloc]initWithCapacity:0];
    shoppingArray   =[[NSMutableArray alloc]initWithCapacity:0];
    recreationArray =[[NSMutableArray alloc]initWithCapacity:0];
    restsArray      =[[NSMutableArray alloc]initWithCapacity:0];
    
    
    typeArray =@[@"scenery",@"dining",@"hotel",@"shopping",@"recreation",@"rests"];
    [self initMapView];
    
    dispatch_queue_t globalQueue=dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    //创建多个线程用于填充图片
    
    //异步执行队列任务
    dispatch_async(globalQueue, ^{
        
        [self postData_0];
    });
    dispatch_async(globalQueue, ^{
        
        [self postData_1];
    });
    dispatch_async(globalQueue, ^{
        
        [self postData_2];
    });
    dispatch_async(globalQueue, ^{
        
        [self postData_3];
    });
    dispatch_async(globalQueue, ^{
        
        [self postData_4];
    });
    
    
    [self.titeLabel removeFromSuperview];
    [self.leftBarButtonItem removeFromSuperview];
    
    [self.mapView.mapView setZoomEnabled:YES];
}

#pragma mark 地图相关
-(void)locan
{

    [[GSLocationTool sharedLocationTool] getProvinceAndCompletion:^(NSString *province, NSString *city) {
        
        NSLog(@" --------   %@/n",province);
        [ZKUtil MyValue:[NSString stringWithFormat:@"%@%@",province, city] MKey:@"adder"];
        
        myadd =[ZKUtil ToTakeTheKey:@"adder"];
        myLatitude =[[ZKUtil ToTakeTheKey:@"Latitude"] doubleValue];
        myLongitude =[[ZKUtil ToTakeTheKey:@"Longitude"]doubleValue];
        //
    } error:^(NSString *error) {
        
    }];
    
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
    
    myLatitude =currLocation.coordinate.latitude;
    myLongitude =currLocation.coordinate.longitude;
    [ZKUtil MyValue:[NSString stringWithFormat:@"%f",myLatitude] MKey:@"Latitude"];
    [ZKUtil MyValue:[NSString stringWithFormat:@"%f",myLongitude] MKey:@"Longitude"];
    [_locationManager stopUpdatingLocation];
    
    CLLocation *c = [[CLLocation alloc] initWithLatitude:myLatitude longitude:myLongitude];
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
                         myadd = str;
                         [ZKUtil MyValue:str MKey:@"adder"];
                         [ZKUtil MyValue:[dict objectForKey:@"City"] MKey:@"myCity"];
                         
                         
                     }
                     else
                     {
                         
                         
                         NSLog(@"ERROR: %@", error); }
                 }];
    
    
}

-(NSMutableDictionary*)dataList:(NSString*)type;

{
    
    NSMutableDictionary *dic =[NSMutableDictionary dictionary];
    
    [dic setObject:@"resoureList" forKey:@"method"];
    [dic setObject:@"48FCADED5B7009C4AED5E5461E6888C0" forKey:@"seccode"];
    [dic setObject:type forKey:@"type"];
    [dic setObject:@"1" forKey:@"page"];
    [dic setObject:@"30" forKey:@"rows"];
    
    return dic;
    
}

/**
 *  重新加载数据
 */
-(void)anewAddData
{
    
    [self.mapView.mapView removeAnnotations:self.mapView.searchArray];
    [self.mapView.searchArray removeAllObjects];
    [self.mapView.mapView addAnnotations:self.mapView.anntionArray];
    
    [selectView showHeg];
    
}
#pragma mark  搜索请求
-(void)postSearch;
{
    
    [restsArray removeAllObjects];
    [self.mapView.mapView removeAnnotations:self.mapView.anntionArray];
    [self.mapView.mapView removeAnnotations:self.mapView.searchArray];
    
    [self.mapView.searchArray removeAllObjects];
    [selectView dismHeg];
    
    for (int i=0; i<5; i++) {
        
        NSMutableDictionary *dic =[NSMutableDictionary dictionary];
        
        [dic setObject:@"resoureList" forKey:@"method"];
        [dic setObject:typeArray[i] forKey:@"type"];
        [dic setObject:seekText.text forKey:@"key"];
        [dic setObject:@"1" forKey:@"page"];
        [dic setObject:@"50" forKey:@"rows"];
        
        [ZKHttp Post:@"" params:dic success:^(id responseObj) {
            
            NSArray *array =[responseObj valueForKey:@"rows"];
            
            if (array.count>0) {
                
                
                for (NSDictionary *dic in array) {
                    
                    Item *lists =[[Item alloc]initWithDictionary:dic anntp:typeArray[i]];
                    
                    [restsArray addObject:lists];
                    
                }
                
                [self  dataRefresh:restsArray selcet:2];
                
                
                
                
            }else{
                
                //              [self.view makeToast:@"查不到相关类容"];
                
            }
            
            
        } failure:^(NSError *error) {
            
            [self.view makeToast:@"网络出错了"];
        }];
        
        
    }
    
    
}

-(void)postData_0;
{
    
    NSString *typ =typeArray[0];
    
    [ZKHttp Post:@"" params:[self dataList:typeArray[0]] success:^(id responseObj) {
        
        //        NSLog(@",res -----%@", responseObj);
        
        NSArray *array =[responseObj valueForKey:@"rows"];
        
        if (array.count>0) {
            
            [ZKUtil dictionaryToJson:responseObj File:typ];
            
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                // 耗时的操作
                
                for (NSDictionary *dic in array) {
                    
                    Item *lists =[[Item alloc]initWithDictionary:dic anntp:typ];
                    
                    [sceneryArray addObject:lists];
                    
                }
                
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    // 更新界面
                    
                    
                    
                    [self  dataRefresh:sceneryArray selcet:1];
                    
                    [selectView updata:0];
                    
                    
                });
            });
            
            
            
            
        }
        
        
    } failure:^(NSError *error) {
        
        /**
         *  无网取数据
         */
        NSArray *array =[[ZKUtil File:typ] valueForKey:@"rows"];
        
        if (array.count>0) {
            
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                // 耗时的操作
                
                for (NSDictionary *dic in array) {
                    
                    Item *lists =[[Item alloc]initWithDictionary:dic anntp:typ];
                    
                    [sceneryArray addObject:lists];
                    
                }
                
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    // 更新界面
                    
                    
                    
                    [self  dataRefresh:sceneryArray selcet:1];
                    
                    [selectView updata:0];
                    
                    
                });
            });
            
            
        }
        
    }];
    
    
}

-(void)postData_1;
{
    NSString *typ =typeArray[1];
    
    [ZKHttp Post:@"" params:[self dataList:typ ] success:^(id responseObj) {
        
        NSArray *array =[responseObj valueForKey:@"rows"];
        
        if (array.count>0) {
            
            [ZKUtil dictionaryToJson:responseObj File:typ];
            
            
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                // 耗时的操作
                
                for (NSDictionary *dic in array) {
                    
                    Item *lists =[[Item alloc]initWithDictionary:dic anntp:typ];
                    
                    [diningArray addObject:lists];
                    
                }
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    // 更新界面
                    
                    
                    
                    [self  dataRefresh:diningArray selcet:1];
                    
                    [selectView updata:1];
                    
                    
                });
            });
            
            
            
            
        }
        
        
    } failure:^(NSError *error) {
        
        /**
         *  无网取数据
         */
        NSArray *array =[[ZKUtil File:typ] valueForKey:@"rows"];
        
        if (array.count>0) {
            
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                // 耗时的操作
                
                for (NSDictionary *dic in array) {
                    
                    Item *lists =[[Item alloc]initWithDictionary:dic anntp:typ];
                    
                    [diningArray addObject:lists];
                    
                }
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    // 更新界面
                    
                    
                    
                    [self  dataRefresh:diningArray selcet:1];
                    
                    [selectView updata:1];
                    
                    
                });
            });
            
        }
        
    }];
    
}

-(void)postData_2;
{
    NSString *typ =typeArray[2];
    
    [ZKHttp Post:@"" params:[self dataList:typ] success:^(id responseObj) {
        
        
        
        NSArray *array =[responseObj valueForKey:@"rows"];
        
        if (array.count>0) {
            
            [ZKUtil dictionaryToJson:responseObj File:typ];
            
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                // 耗时的操作
                
                for (NSDictionary *dic in array) {
                    
                    Item *lists =[[Item alloc]initWithDictionary:dic anntp:typ];
                    
                    [hotelArray addObject:lists];
                    
                }
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    // 更新界面
                    
                    
                    [self  dataRefresh:hotelArray selcet:1];
                    
                    [selectView updata:2];
                    
                });
            });
            
            
            
            
            
        }
        
        
    } failure:^(NSError *error) {
        
        /**
         *  无网取数据
         */
        NSArray *array =[[ZKUtil File:typ] valueForKey:@"rows"];
        
        if (array.count>0) {
            
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                // 耗时的操作
                
                for (NSDictionary *dic in array) {
                    
                    Item *lists =[[Item alloc]initWithDictionary:dic anntp:typ];
                    
                    [hotelArray addObject:lists];
                    
                }
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    // 更新界面
                    
                    
                    [self  dataRefresh:hotelArray selcet:1];
                    
                    [selectView updata:2];
                    
                });
            });
            
        }
        
    }];
    
}

-(void)postData_3;
{
    NSString *typ =typeArray[3];
    
    [ZKHttp Post:@"" params:[self dataList:typ] success:^(id responseObj) {
        
        
        
        NSArray *array =[responseObj valueForKey:@"rows"];
        
        if (array.count>0) {
            
            [ZKUtil dictionaryToJson:responseObj File:typ];
            
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                // 耗时的操作
                
                
                for (NSDictionary *dic in array) {
                    
                    Item *lists =[[Item alloc]initWithDictionary:dic anntp:typ];
                    
                    [shoppingArray addObject:lists];
                    
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    // 更新界面
                    
                    
                    
                    [self  dataRefresh:shoppingArray selcet:1];
                    
                    [selectView updata:3];
                    
                });
            });
            
            
            
            
            
        }
        
        
    } failure:^(NSError *error) {
        
        /**
         *  无网取数据
         */
        NSArray *array =[[ZKUtil File:typ] valueForKey:@"rows"];
        
        if (array.count>0) {
            
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                // 耗时的操作
                
                
                for (NSDictionary *dic in array) {
                    
                    Item *lists =[[Item alloc]initWithDictionary:dic anntp:typ];
                    
                    [shoppingArray addObject:lists];
                    
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    // 更新界面
                    
                    
                    
                    [self  dataRefresh:shoppingArray selcet:1];
                    
                    [selectView updata:3];
                    
                });
            });
            
        }
        
    }];
    
}

-(void)postData_4;
{
    
    NSString *typ =typeArray[4];
    
    [ZKHttp Post:@"" params:[self dataList:typ] success:^(id responseObj) {
        
        NSArray *array =[responseObj valueForKey:@"rows"];
        
        if (array.count>0) {
            
            [ZKUtil dictionaryToJson:responseObj File:typ];
            
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                // 耗时的操作
                
                
                for (NSDictionary *dic in array) {
                    
                    Item *lists =[[Item alloc]initWithDictionary:dic anntp:typ];
                    
                    [recreationArray addObject:lists];
                    
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    // 更新界面
                    
                    
                    [self  dataRefresh:recreationArray selcet:1];
                    
                    [selectView updata:4];
                    
                    
                });
            });
            
            
            
            
            
        }
        
        
    } failure:^(NSError *error) {
        
        /**
         *  无网取数据
         */
        NSArray *array =[[ZKUtil File:typ] valueForKey:@"rows"];
        
        if (array.count>0) {
            
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                // 耗时的操作
                
                
                for (NSDictionary *dic in array) {
                    
                    Item *lists =[[Item alloc]initWithDictionary:dic anntp:typ];
                    
                    [recreationArray addObject:lists];
                    
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    // 更新界面
                    
                    
                    [self  dataRefresh:recreationArray selcet:1];
                    
                    [selectView updata:4];
                    
                    
                });
            });
            
        }
        
    }];
    
}


#pragma mark 加载数据
/**
 *  刷新标记
 *
 *  @param data 数据
 *  @param ty   类型
 */
-(void)dataRefresh:(NSArray*)data selcet:(NSInteger)dex;
{
    
    [_annotations removeAllObjects];
    
    if (data.count>0) {
        
        
        for (int i=0; i<data.count; i++) {
            
            Item *item =[data objectAtIndex:i];
            item.poop =dex;
            if ([item.longitude isKindOfClass:[NSNumber class]]||[item.latitude isKindOfClass:[NSNumber class]]) {
                
                [_annotations addObject:item];
                
            }
        }
        
        NSLog(@"*******  %lu   ********\n",(unsigned long)_annotations.count);
        [_mapView beginLoad];
        
        [_mapView.mapView showAnnotations:_mapView.mapView.annotations animated:YES];
        
        
    }
    
}



-(void)initMapView
{
    
    self.mapView = [[MapView alloc] initWithDelegate:self];
    [self.view addSubview:_mapView];
    
    [_mapView setFrame:CGRectMake(0, navigationHeghit, self.view.frame.size.width, TabelHeghit-self.tabBarController.tabBar.height)];
    [_mapView shouldGroupAccessibilityChildren];
    
    selectView =[[DQNavSelectView alloc]initWithFrame:CGRectMake(0, 0, self.mapView.frame.size.width, 40)];
    selectView.layer.opacity =1;
    selectView.delegate =self;
    
    [self.mapView addSubview:selectView];
    
    UILongPressGestureRecognizer *longPressed = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressedAct:)];
    longPressed.minimumPressDuration = 1;
    [self.mapView addGestureRecognizer:longPressed];
    
    locationButton =[[UIButton alloc]initWithFrame:CGRectMake(15, _mapView.frame.size.height -55, 40, 40)];
    locationButton.backgroundColor =[UIColor clearColor];
    [locationButton setImage:[UIImage imageNamed:@"map_user"] forState:UIControlStateNormal];
    locationButton.selected =NO;
    [locationButton addTarget:self action:@selector(locationClick:) forControlEvents:UIControlEventTouchUpInside];
    [_mapView addSubview:locationButton];
    
    
    
    seekText =[[UITextField alloc]initWithFrame:CGRectMake(0, 0, self.mapView.frame.size.width-100, 28)];
    seekText.layer.cornerRadius =14;
    seekText.placeholder =@"景点/美食/酒店";
    seekText.left =20;
    seekText.font =[UIFont systemFontOfSize:14];
    seekText.leftViewMode =UITextFieldViewModeUnlessEditing;
    seekText.textAlignment =NSTextAlignmentCenter;
    seekText.contentVerticalAlignment =UIControlContentHorizontalAlignmentCenter;
    seekText.clearButtonMode = UITextFieldViewModeUnlessEditing;
    seekText.delegate =self;
    //    seekText.clearsOnBeginEditing = YES;
    seekText.leftViewMode = UITextFieldViewModeAlways;
    seekText.returnKeyType =UIReturnKeyDone;
    seekText.backgroundColor =TabelBackCorl;
    seekText.layer.borderColor =[UIColor grayColor].CGColor;
    seekText.layer.borderWidth =0.4;
    seekText.layer.opacity =0.7;
    seekText.textColor =[UIColor blackColor];
    seekText.returnKeyType =UIReturnKeySearch;
    seekText.center =CGPointMake(self.navigationBarView.frame.size.width/2, self.navigationBarView.frame.size.height/2+10);
    [self.navigationBarView addSubview:seekText];
    
    
    UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    tapGr.cancelsTouchesInView =NO;
    [self.view addGestureRecognizer:tapGr];
    
    
}
#pragma mark think代理

-(void)indexthink:(NSString*)str;
{
    [seekText resignFirstResponder];
    isThink =NO;
    [thinkView hideButtonClick];
    seekText.text=str;
    dataString =str;
    [self postSearch];
    
    
}

#pragma mark textfild

-(void)viewTapped:(UITapGestureRecognizer*)tapGr{
    
    [seekText   resignFirstResponder];
}

/**
 *  搜索代理
 *
 *  @param textField
 *
 *  @return
 */
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    if (isThink ==YES) {
        
        isThink =NO;
        [thinkView hideButtonClick];
        
    }
    
    if (seekText.text.length ==0) {
        
        [self.view makeToast:@"请输入关键字查询!"];
        
        
    }else{
        
        [self postSearch];
    }
    
    [self postSearch];
    
    [textField resignFirstResponder];
    
    return  YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    //开始编辑时触发，文本
    
    if (isThink ==YES) {
        
        isThink =NO;
        [thinkView hideButtonClick];
        
        
    }
    
}

/**
 *  点击清空键
 *
 *  @param textField
 *
 *  @return
 */
- (BOOL)textFieldShouldClear:(UITextField *)textField;
{
    
    [self anewAddData];
    
    return YES;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    if (range.length ==1) {
        
        dataString =seekText.text;
        
        if (dataString.length>1) {
            
            if (isThink ==NO) {
                
                thinkView =[[ZKtextFieldThinkView alloc]initWithFrame:seekText.frame];
                thinkView.delegate =self;
                [thinkView updata:dataString];
                [thinkView show];
                
                isThink =YES;
                
            }else{
                
                [thinkView updata:dataString];
                
                
                
            }
            
        }else{
            
            
            isThink =NO;
            [thinkView hideButtonClick];
            [self anewAddData];
            [seekText resignFirstResponder];
            seekText.text =@"";
            
        }
        
        
        
    }
    
    if (range.location>10) {
        
        return NO;
    }
    
    
    return YES;
    
}


#pragma mark -
#pragma mark delegate

-(Item*)listDataIndex:(NSInteger)index;
{
    Item *item = [_annotations objectAtIndex:index];
    
    return item;
    
}

- (NSInteger)numbersWithCalloutViewForMapView
{
    
    return [_annotations count];
}


- (UIImage *)baseMKAnnotationViewImageWithIndex:(NSString*)p;
{
    
    
    return [UIImage imageNamed:[NSString stringWithFormat:@"%@",p]];
    
    
}

- (UIView *)mapViewCalloutContentViewWithIndex:(Item*)plist
{
    
    
    
    
    cell =[[TestMapCell alloc]initWithFrame:CGRectMake(0, 0, 240, 135)];
    if (strIsEmpty(plist.title)==1) {
        
        cell.title.text = @"暂无详细";
        
    }else{
        
        cell.title.text = plist.title;
    }
    
    if (strIsEmpty(plist.subtitle)==1) {
        cell.subtitle.text =@"暂无详细介绍...";
    }else{
        cell.subtitle.text = plist.subtitle;
        
    }
    
    if (strIsEmpty(plist.phone)==1) {
        cell.phoneLabel.text =[NSString stringWithFormat:@"电话:暂无电话！"];
        
    }else{
        
        cell.phoneLabel .text =[NSString stringWithFormat:@"电话:%@",plist.phone ];
        
    }
    
    
    
    if (strIsEmpty(plist.imageUrl) ==1) {
        
        [cell.imageView setImage:[UIImage imageNamed:@"zz"]];
    }else{
        
        cell.imageView.contentMode = UIViewContentModeScaleAspectFill;
        NSString *url =[NSString stringWithFormat:@"%@%@",imageUrlPrefix,plist.imageUrl];
        
        [ZKUtil  UIimageView:cell.imageView NSSting:url];
        
        
        
    }
    
    
    return cell;
}

- (void)calloutViewDidSelectedWithIndex:(Item*)list
{
    if (!myLatitude) {
        
        [self.view makeToast:@"用户位置获取失败"];
        
        return;
    }
    
    
    ZKMapNavController *map =[[ZKMapNavController alloc]initKLat:myLatitude KLon:myLongitude Kadder:myadd WLat:[list.longitude doubleValue] WLon:[list.latitude doubleValue] WAdder:list.subtitle code:@""];
    
    [self.navigationController pushViewController:map animated:YES];
}

#pragma mark 选择代理


-(void)pAdd:(NSInteger)a;
{
    
    if (restsArray.count>0) {
        [restsArray removeAllObjects];
        [self.mapView.mapView removeAnnotations:self.mapView.searchArray];
        [self.mapView.searchArray removeAllObjects];
        [selectView dismHeg];
    }
    
    seekText.text =@"";
    [selectView updata:a];
    
    switch (a) {
        case 0:
            
            [self dataRefresh:sceneryArray selcet:1];
            break;
            
        case 1:
            
            [self dataRefresh:diningArray selcet:1];
            break;
            
        case 2:
            
            [self dataRefresh:hotelArray selcet:1];
            
            break;
            
        case 3:
            
            [self dataRefresh:shoppingArray selcet:1];
            break;
            
        case 4:
            
            [self dataRefresh:recreationArray selcet:1];
            break;
        default:
            break;
    }
}
-(void)pCancel:(NSInteger)c;
{
    
    
    for (BasicMapAnnotation*ann in self.mapView.anntionArray) {
        
        if ([ann isKindOfClass:[BasicMapAnnotation class]]) {
            
            if ([ann.type isEqualToString:typeArray[c]]) {
                
                [self.mapView.mapView removeAnnotation:ann];
                
                
            }
            
            
        }
        
    }
    
    
    
    
}

#pragma mark UIBUTTON

-(void)lefBack
{
    
    self.mapView.mapView.showsUserLocation =NO;
    [self.mapView.mapView removeAnnotations:self.mapView.mapView.annotations];
    [self.mapView.mapView removeOverlays:self.mapView.mapView.overlays];
    self.mapView.mapView.delegate =nil;
    [self.navigationController popViewControllerAnimated:YES];
    
}



-(void)longPressedAct:(UILongPressGestureRecognizer *)gesture

{
    
    if(gesture.state == UIGestureRecognizerStateBegan)
        
        
    {
        if (selectView.layer.opacity ==0) {
            selectView.layer.opacity =1;
        }else{
            selectView.layer.opacity =0;
            
        }
    }
    
}


#pragma mark 定位
-(void)locationClick:(UIButton*)sender
{
    
    
    if (sender.selected ==NO) {
        
        [self.mapView.mapView setShowsUserLocation:YES];
        
        
        CLLocationCoordinate2D loc ;
        loc.latitude =myLatitude;
        loc.longitude =myLongitude;
        //放大地图到自身的经纬度位置。
        MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(loc, self.mapView.span , self.mapView.span);
        [self.mapView.mapView setRegion:region animated:YES];
        sender.selected =YES;
    }
    else{
        
        sender.selected =NO;
        [self.mapView.mapView setShowsUserLocation:NO];
        [_mapView.mapView showAnnotations:_mapView.mapView.annotations animated:YES];
        
    }
    
    
    
}



@end
