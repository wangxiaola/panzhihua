//
//  ZKPhotoGalleryViewController.m
//  CYmiangzhu
//
//  Created by 王小腊 on 16/5/16.
//  Copyright © 2016年 WangXiaoLa. All rights reserved.
//

#import "ZKPhotoGalleryViewController.h"

#import "WaterF.h"
#import "WaterFLayout.h"

static NSString * const reuseIdentifier = @"Cell";

@interface ZKPhotoGalleryViewController ()

@property (nonatomic, strong) NSArray *photoImagesArray;
@property (nonatomic, strong) NSArray *photoTitisArray;
@property (nonatomic, strong) NSString *controllerTitel;

@property (nonatomic,strong) WaterF* waterfall;

@end

@implementation ZKPhotoGalleryViewController

- (instancetype)initImages:(NSArray*)images photoTitis:(NSArray*)titis title:(NSString*)str;
{
    self = [super init];
    if (self) {
        
        self.photoTitisArray = titis;
        self.photoImagesArray = images;
        self.controllerTitel = str;
    }
    
    return self;

}
- (void)viewDidLoad {
    [super viewDidLoad];
  
    self.title = self.controllerTitel;
    
    UIView *contenView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, kDeviceWidth, kDeviceHeight-64)];
    contenView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:contenView];
    
    WaterFLayout * flowLayout = [[WaterFLayout alloc]init];
    flowLayout.sectionInset = UIEdgeInsetsMake(5, 10, 2, 10);//设置其边界
    [flowLayout setMinimumInteritemSpacing:10]; //设置 y 间距
    
    self.waterfall = [[WaterF alloc]initWithCollectionViewLayout:flowLayout];
    self.waterfall.sectionNum = 1;
    self.waterfall.imagewidth = kDeviceWidth/2-15;
    [contenView addSubview:self.waterfall.view];

    
    [self updataCollectionView];

    
}

- (void)updataCollectionView
{

    self.waterfall.imagesArr = [self.photoImagesArray mutableCopy];
    self.waterfall.textsArr  = [self.photoTitisArray mutableCopy];
    [self.waterfall.collectionView reloadData];
    
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
