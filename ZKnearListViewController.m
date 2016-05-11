//
//  DQNavViewController.m
//  changyouyibin
//
//  Created by Daqsoft-Mac on 14/12/16.
//  Copyright (c) 2014年 WangXiaoLa. All rights reserved.
//

#import "ZKnearListViewController.h"
#import "MapView.h"
#import "Item.h"
#import "TestMapCell.h"
#import "CallOutAnnotationView.h"
#import "RoutePlanViewController.h"
#import "ZKAppDelegate.h"
#import "ZKTypeselectionView.h"
#import "ZKtextFieldThinkView.h"
#import "BasicMapAnnotation.h"

#import "ZKMapNavController.h"

@interface ZKnearListViewController ()<MapViewDelegate,CLLocationManagerDelegate,UITextFieldDelegate,ZKtextFieldThinkViewDelegate,ZKTypeselectionViewDelegate>
{
    
    ZKTypeselectionView *typeselecView;
    
    TestMapCell *cell;
    
    NSMutableArray *_annotations;
    
    UIButton *seleButton;
    
    NSString *key;
    
    UIButton *locationButton;
    
    UITextField *seekText;
    
    NSMutableArray *sceneryArray;
    NSMutableArray *diningArray;
    NSMutableArray *hotelArray;
    NSMutableArray *shoppingArray;
    NSMutableArray *recreationArray;
    NSMutableArray *restsArray;
    
    
    NSMutableArray *typeArray ;
    NSMutableArray *typeNameArray;
    NSMutableArray *generalArray;
    
    
    NSString *dataString;
    
    /**
     *  联想view
     */
    ZKtextFieldThinkView *thinkView;
    
    BOOL isThink;
    
    
    NSString *myadd;
    
    double myLatitude;
    
    double myLongitude;
    
    /**
     *  推荐字典
     */
    NSDictionary *nearDic;
    
    BOOL isNear;
    
    NSInteger recordIndex;
    
}

@property (nonatomic,strong)MapView *mapView;

@end

@implementation ZKnearListViewController

-(id)init:(NSArray*)data;
{
    self =[super init];
    if (self) {
        
        
        nearDic = [self zhuanhuan:data];
        

        
    }
    return self;
}
/**
 *  数组转字典
 *
 *  @param data 数据
 *
 *  @return 字典
 */
-(NSDictionary*)zhuanhuan:(NSArray*)data
{
    // data = @[@"lnglat", @"104.061035,30.555239"];
    if (data.count<2) {
        return nil;
    }
    
    NSMutableDictionary *dic =[NSMutableDictionary dictionary];
    
    NSString *l_0_str = data[0];
    NSString *l_1_str = data[1];
    
    double l_0 = [l_0_str doubleValue];
    double l_1 = [l_1_str doubleValue];
    
    if (l_0>l_1) {
        
        [dic setObject:l_0_str forKey:@"lon"];
        [dic setObject:l_1_str forKey:@"lan"];
        
    }else{
        [dic setObject:l_0_str forKey:@"lan"];
        [dic setObject:l_1_str forKey:@"lon"];
        
    }
    
    return dic;
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //    我的位置
    myadd =[ZKUtil ToTakeTheKey:@"adder"];
    myLatitude =[[ZKUtil ToTakeTheKey:@"Latitude"] doubleValue];
    myLongitude =[[ZKUtil ToTakeTheKey:@"Longitude"]doubleValue];
    
    NSString *onlyType =[nearDic valueForKey:@"onlyType"];
    
    if ([onlyType isEqualToString:@"true"]) {
        
        isNear =YES;
        
    }else{
        
        isNear =NO;
        
    }
    
    isThink =NO;
    
    [self.leftBarButtonItem removeFromSuperview];
    
    UIButton *lefButton = [[UIButton alloc]initWithFrame:CGRectMake(2, 20, 40, 40)];
    [lefButton setImage:[UIImage imageNamed:@"backimage"] forState:UIControlStateNormal];
    lefButton.backgroundColor =[UIColor clearColor];
    [lefButton addTarget:self action:@selector(lefBack) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:lefButton];
    
    
    key =@"";
    
    
    _annotations =[[NSMutableArray alloc]initWithCapacity:0];
    
    sceneryArray =[[NSMutableArray alloc]initWithCapacity:0];
    diningArray =[[NSMutableArray alloc]initWithCapacity:0];
    hotelArray =[[NSMutableArray alloc]initWithCapacity:0];
    shoppingArray =[[NSMutableArray alloc]initWithCapacity:0];
    recreationArray =[[NSMutableArray alloc]initWithCapacity:0];
    
    restsArray =[[NSMutableArray alloc]initWithCapacity:0];
    
    typeArray =[[NSMutableArray alloc]initWithCapacity:0];
    typeNameArray =[[NSMutableArray alloc]initWithCapacity:0];
    generalArray =[[NSMutableArray alloc]initWithCapacity:0];
    
    [self initMapView];
    
    
    self.titeLabel.text = @"附近推荐";
    
    [self.mapView.mapView setZoomEnabled:YES];
    
    [self nearPost];
    
    
    
}

#pragma mark  根据数据加载视图
-(void)supviesInit;
{
    //   @[@"scenery",@"dining",@"hotel",@"shopping",@"recreation",@"rests"];
    
    if ( sceneryArray.count>0) {
        
        [typeArray addObject:@"scenery"];
        [typeNameArray addObject:@"景点"];
        [generalArray addObject:sceneryArray];
    }
    if (diningArray.count>0) {
        [typeArray addObject:@"dining"];
        [typeNameArray addObject:@"美食"];
        [generalArray addObject:diningArray];
    }
    
    if (hotelArray.count>0) {
        
        [typeArray addObject:@"hotel"];
        [typeNameArray addObject:@"住宿"];
        [generalArray addObject:hotelArray];
    }
    if (shoppingArray.count>0) {
        
        [typeArray addObject:@"shopping"];
        [typeNameArray addObject:@"购物"];
        [generalArray addObject:shoppingArray];
    }
    if (recreationArray.count>0) {
        
        [typeArray addObject:@"recreation"];
        [typeNameArray addObject:@"娱乐"];
        [generalArray addObject:recreationArray];
    }
    
    /**
     *  有数据时
     */
    if (typeArray.count>0) {
        
        
        typeselecView=[[ZKTypeselectionView alloc]initWithFrame:CGRectMake(0, 0, self.mapView.frame.size.width, 40)data:typeNameArray];
        typeselecView.layer.opacity =0.7;
        typeselecView.delegate =self;
        [self.mapView addSubview:typeselecView];
        
        seekText.frame =CGRectMake(15, 55, self.mapView.frame.size.width-30, 30);
        
        if (isNear ==YES) {
            
            NSString *pc =[ nearDic valueForKey:@"type"];
            
            for (int i =0; i<typeArray.count; i++) {
                
                if ([pc isEqualToString:typeArray[i]]) {
                    
                    recordIndex =i;
                    [self dataRefresh:generalArray[i] selcet:1];
                    [typeselecView updata:i];
                    
                }
                
            }
            
            
        }else{
            
            /**
             *  全选中
             */
            for (int i =0; i<typeArray.count; i++) {
                
                [self dataRefresh:generalArray[i] selcet:1];
                [typeselecView updata:i];
                
                
            }
            
            
        }
        
        
    }
    
    
}

/**
 *  请求
 */
-(void)nearPost
{
    
    [ZKHttp Post:@"" params:[self dataList] success:^(id responseObj) {
        
        NSLog(@"   ==  *** \n%@",responseObj);
        
       
        NSArray *array =[responseObj valueForKey:@"rows"];
        
        if (array.count>0) {
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
               
                for (NSDictionary *dic in array) {
                    
                    Item *lists =[[Item alloc]initWithDictionary:dic];
                    
                    
                    if ([lists.tp isEqualToString:@"scenery"]) {
                        
                        [sceneryArray addObject:lists];
                        
                    }else if ([lists.tp isEqualToString:@"dining"])
                    {
                        
                        [diningArray addObject:lists];
                        
                    }else if ([lists.tp isEqualToString:@"hotel"])
                    {
                        [hotelArray addObject:lists];
                        
                    }else if ([lists.tp isEqualToString:@"shopping"])
                    {
                        
                        [shoppingArray addObject:lists];
                        
                    }else if ([lists.tp isEqualToString:@"recreation"])
                    {
                        
                        
                        [recreationArray addObject:lists];
                    }
                }
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    /**
                     *  规划视图
                     */
                    [self supviesInit];
                    
                });
            
            });
            
        }
        
    } failure:^(NSError *error) {
        
        [self.view makeToast:@"网络请求错误"];
    }];
    
}

-(NSMutableDictionary*)dataList;

{
    NSMutableDictionary *dic =[NSMutableDictionary dictionary];
    
    [dic setObject:key forKey:@"key"];
    
    if (isNear ==YES) {
        
        [dic setObject:[nearDic valueForKey:@"lan"] forKey:@"lat"];
        [dic setObject:[nearDic valueForKey:@"lon"] forKey:@"lon"];
        [dic setObject:@"3" forKey:@"count"];
        [dic setObject:@"resoureNearbyLatLng" forKey:@"method"];
        
    }else{
        
        [dic setObject:[nearDic valueForKey:@"lan"] forKey:@"lat"];
        [dic setObject:[nearDic valueForKey:@"lon"] forKey:@"lon"];
        [dic setObject:@"3" forKey:@"count"];
        [dic setObject:@"resoureNearbyLatLng" forKey:@"method"];
        
    }
    
    return dic;
    
}

/**
 *  重新加载数据
 */
-(void)anewAddData
{
    
    [self.mapView.mapView removeAnnotations:self.mapView.searchArray];
    [self.mapView.searchArray removeAllObjects];
    
    if (isNear ==YES) {
        [self.mapView.anntionArray removeAllObjects];
        [self dataRefresh:generalArray[recordIndex] selcet:1];
        [typeselecView updata:recordIndex];
        
    }else{
        
        
        [self.mapView.mapView addAnnotations:self.mapView.anntionArray];
        
        [typeselecView showHeg];
    }
    
    
}
#pragma mark  搜索请求
-(void)postSearch;
{
    
    if (seekText.text.length ==0) {
        
        [self.view makeToast:@"输入不能为空"];
        
        return;
    }
    
    [self.mapView.mapView removeAnnotations:self.mapView.anntionArray];
    [self.mapView.searchArray removeAllObjects];
    
    [typeselecView dismHeg];
    
    key =seekText.text;
    
    [ZKHttp Post:@"" params:[self dataList] success:^(id responseObj) {
        
        
        NSArray *array =[responseObj valueForKey:@"rows"];
        
        if (array.count>0) {
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                
                for (NSDictionary *dic in array) {
                    
                    Item *lists =[[Item alloc]initWithDictionary:dic];
                    
                    [restsArray addObject:lists];
                    
                }
               
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                     [self  dataRefresh:restsArray selcet:2];
                    
                });
            });
            
           
            
            
        }else{
            
            [self.view makeToast:@"查不到相关类容"];
            
        }
        
        
    } failure:^(NSError *error) {
        
        [self.view makeToast:@"网络出错了"];
        
    }];
    
    
    
}

#pragma mark 加载数据
/**
 *  刷新标记
 *
 *  @param data 数据
 *  @param ty   类型
 */
-(void)dataRefresh:(NSArray *)data selcet:(NSInteger)dex;
{
    
    
    [_annotations removeAllObjects];
    
    if (data.count>0) {
        
        
        for (int i=0; i<data.count; i++) {
            
            Item *item =[data objectAtIndex:i];
            item.poop =dex;
            
            [_annotations addObject:item];
            
        }
        
        NSLog(@"*******  %lu   ********\n",(unsigned long)_annotations.count);
        [_mapView beginLoad];
        
        
    }
    
}



-(void)initMapView
{
    
    self.mapView = [[MapView alloc] initWithDelegate:self];
    [self.view addSubview:_mapView];
    
    [_mapView setFrame:CGRectMake(0, navigationHeghit, self.view.frame.size.width, TabelHeghit)];
    [_mapView shouldGroupAccessibilityChildren];
    
    
    
    locationButton =[[UIButton alloc]initWithFrame:CGRectMake(15, _mapView.frame.size.height -55, 40, 40)];
    locationButton.backgroundColor =[UIColor clearColor];
    [locationButton setImage:[UIImage imageNamed:@"map_location_icon"] forState:UIControlStateNormal];
    [locationButton setImage:[UIImage imageNamed:@"map_location_icon_select"] forState:UIControlStateHighlighted];
    locationButton.selected =NO;
    [locationButton addTarget:self action:@selector(locationClick:) forControlEvents:UIControlEventTouchUpInside];
    [_mapView addSubview:locationButton];
    
    
    
    seekText =[[UITextField alloc]initWithFrame:CGRectMake(15, 20, self.mapView.frame.size.width-30, 30)];
    seekText.placeholder =@"输入关键字搜索";
    seekText.textAlignment =NSTextAlignmentCenter;
    seekText.contentVerticalAlignment =UIControlContentHorizontalAlignmentCenter;
    seekText.clearButtonMode = UITextFieldViewModeUnlessEditing;
    seekText.delegate =self;
    //    seekText.clearsOnBeginEditing = YES;
    seekText.leftViewMode = UITextFieldViewModeAlways;
    seekText.returnKeyType =UIReturnKeyDone;
    seekText.backgroundColor =[UIColor whiteColor];
    seekText.layer.borderColor =[UIColor grayColor].CGColor;
    seekText.layer.borderWidth =0.4;
    seekText.layer.opacity =0.7;
    seekText.textColor =[UIColor blackColor];
    seekText.returnKeyType =UIReturnKeySearch;
    [self.mapView addSubview:seekText];
    
    
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
        
        cell.phoneLabel .text =[NSString stringWithFormat:@"电话:%@",plist.phone];
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
    
    
    [self dataRefresh: generalArray[a] selcet:1];
    
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
        
        
    }
   
}

@end
