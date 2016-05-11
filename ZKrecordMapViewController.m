//
//  DQNavViewController.m
//  changyouyibin
//
//  Created by Daqsoft-Mac on 14/12/16.
//  Copyright (c) 2014年 WangXiaoLa. All rights reserved.
//

#import "ZKrecordMapViewController.h"
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

@interface ZKrecordMapViewController ()<MapViewDelegate,CLLocationManagerDelegate,UITextFieldDelegate,ZKtextFieldThinkViewDelegate>
{
    
    TestMapCell *cell;
    
    
    NSMutableArray *_annotations;
    
    UIButton *seleButton;
    
    NSString *key;
    
    UIButton *locationButton;
    
    
    UITextField *seekText;
    
    NSMutableArray *restsArray;
    
    NSArray *listData;
    
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
    
    NSString *pcname;
}

@property (nonatomic,strong)MapView *mapView;

@end

@implementation ZKrecordMapViewController

-(id)initData:(NSArray*)list titis:(NSString*)name;
{
    self =[super init];
    if (self) {
        
 
        listData =list;
        pcname=name;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //    我的位置
    myadd =[ZKUtil ToTakeTheKey:@"adder"];
    myLatitude =[[ZKUtil ToTakeTheKey:@"Latitude"] doubleValue];
    myLongitude =[[ZKUtil ToTakeTheKey:@"Longitude"]doubleValue];
    
    self.titeLabel.text =pcname;
    isThink =NO;
    
    [self.leftBarButtonItem removeFromSuperview];
    

    
    key =@"";
    
    
    restsArray =[[NSMutableArray alloc]initWithCapacity:0];
    _annotations =[[NSMutableArray alloc]initWithCapacity:0];
    
    typeArray =@[@"scenery",@"dining",@"hotel",@"shopping",@"recreation",@"rests"];
    [self initMapView];
    
    
    [self.mapView.mapView setZoomEnabled:YES];
    
    [self dataRefresh:listData selcet:1];
}



/**
 *  重新加载数据
 */
-(void)anewAddData
{
    
    [self.mapView.mapView removeAnnotations:self.mapView.searchArray];
    [self.mapView.searchArray removeAllObjects];
    [self.mapView.mapView addAnnotations:self.mapView.anntionArray];
    
    
}
#pragma mark  搜索请求
-(void)postSearch;
{
    
    [self.mapView.mapView removeAnnotations:self.mapView.anntionArray];
    [self.mapView.searchArray removeAllObjects];
    
    for (int i=0; i<5; i++) {
        
        
        NSMutableDictionary *dic =[NSMutableDictionary dictionary];
        
        [dic setObject:@"resoureList" forKey:@"method"];
        [dic setObject:@"48FCADED5B7009C4AED5E5461E6888C0" forKey:@"seccode"];
        [dic setObject:typeArray[i] forKey:@"type"];
        [dic setObject:seekText.text forKey:@"key"];
        
        [ZKHttp Post:@"http://192.168.0.173:8888/mz_web/app/zxwinterface.do" params:dic success:^(id responseObj) {
            
            
            NSArray *array =[responseObj valueForKey:@"rows"];
            
            if (array.count>0) {
                
                
                for (NSDictionary *dic in array) {
                    
                    Item *lists =[[Item alloc]initWithDictionary:dic anntp:@"rests"];
                    
                    [restsArray addObject:lists];
                    
                }
                
                [self  dataRefresh:restsArray selcet:2];
                
                
                
                
            }
            
            
            
        } failure:^(NSError *error) {
            
            
        }];
        
        
    }
    
    
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
        
        cell.phoneLabel .text =[NSString stringWithFormat:@"电话:%@",plist.phone ];
    }
    
    
    
    if (strIsEmpty(plist.imageUrl) ==1) {
        
        [cell.imageView setImage:[UIImage imageNamed:@""]];
    }else{
        
        NSString *url =[NSString stringWithFormat:@"http://192.168.0.173:8888/mz_web/%@",plist.imageUrl];
        
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
