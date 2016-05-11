//
//  ZKrecommendViewController.m
//  CYmiangzhu
//
//  Created by Daqsoft-Mac on 15/8/12.
//  Copyright (c) 2015年 WangXiaoLa. All rights reserved.
//

#import "ZKrecommendViewController.h"

#import "ZKrecommenMode.h"

#import "ZKrecommenView.h"
#import "ZKticketListViewController.h"
#import "iCarousel.h"
#import "ZKBasicViewController.h"


//#define IMAGE_X                arc4random()%(int)Main_Screen_Width
//#define IMAGE_ALPHA            ((float)(arc4random()%10))/10
//#define IMAGE_WIDTH            arc4random()%20 + 10
//#define PLUS_HEIGHT            Main_Screen_Height/25

@interface ZKrecommendViewController ()<iCarouselDataSource,iCarouselDelegate>

{
    float ITEM_SPACING;
    
    UIScrollView *scroll;
    
    NSMutableArray *dataArray;
    
    iCarousel *carouselView;
    
    UIPageControl *_page;
    
}
@end

@implementation ZKrecommendViewController
-(id)init{
    self =[super init];
    if (self) {
        
        self.hidesBottomBarWhenPushed =YES;
    }
    
    return self;
}
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [SVProgressHUD dismiss];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[BaiduMobStat defaultStat] logEvent:@"search_recommend" eventLabel:@"分类-推荐"];
    
    dataArray =[[NSMutableArray alloc]initWithCapacity:0];
    
    ITEM_SPACING =self.view.frame.size.width-80;
    
    [self initView];
    
    self.navigationBarView.backgroundColor =[UIColor clearColor];
    self.navigationBarView.layer.borderColor =YJCorl(8, 35, 119).CGColor;
    [self.view addSubview:self.navigationBarView];
    self.titeLabel.text =@"推荐";
    
    [self postData];
    // Do any additional setup after loading the view.
}


-(void)initView
{
    
    
    UIImageView*backImage =[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    backImage.image =[UIImage imageNamed:@"recommen_backImage.jpg"];
    [self.view addSubview:backImage];
    
    self.view.backgroundColor =[UIColor whiteColor];
    
    
}


#pragma mark -  滚动代理

- (NSUInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    return dataArray.count;
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSUInteger)index
{
    ZKrecommenMode *mode =dataArray[index];
    
    UIView *views =[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width-80, self.view.frame.size.height-(64+20)*2)];
    views.backgroundColor =[UIColor clearColor];
    
    UIView *contView = [[UIView alloc]initWithFrame:CGRectMake(20, 0, self.view.frame.size.width-120, views.frame.size.height)];
    contView.backgroundColor =[UIColor whiteColor];
    [views addSubview:contView];
    
    UIImageView *backImage =[[UIImageView alloc]initWithFrame:CGRectMake(8, 8, contView.frame.size.width-16, views.frame.size.height-50)];
    backImage.contentMode = UIViewContentModeScaleAspectFill;
    backImage.clipsToBounds = YES;
    [contView addSubview:backImage];
    NSString *logo = [NSString stringWithFormat:@"%@%@", imageUrlPrefix, mode.logosmall];
    [ZKUtil UIimageView:backImage NSSting:logo duImage:@"recommen_backImage.jpg"];
    
    
    UILabel * nameLabel =[[UILabel alloc]initWithFrame:CGRectMake(10, contView.frame.size.height-40, contView.frame.size.width-20, 35)];
    nameLabel.textAlignment =NSTextAlignmentCenter;
    nameLabel.font =[UIFont systemFontOfSize:14];
    nameLabel.textColor =[UIColor grayColor];
    nameLabel.numberOfLines =2;
    nameLabel.text =mode.name;
    [contView addSubview:nameLabel];
    
    UIButton *bnnerClick =[[UIButton alloc]initWithFrame:contView.bounds];
    bnnerClick.backgroundColor =[UIColor clearColor];
    
    bnnerClick.tag =2000+index;
    [bnnerClick addTarget:self action:@selector(bnnerClick:) forControlEvents:UIControlEventTouchUpInside];
    [contView addSubview:bnnerClick];
    
    return views;
    
}

- (NSUInteger)numberOfPlaceholdersInCarousel:(iCarousel *)carousel
{
    return dataArray.count;
}

- (NSUInteger)numberOfVisibleItemsInCarousel:(iCarousel *)carousel
{
    return dataArray.count;
}

- (CGFloat)carouselItemWidth:(iCarousel *)carousel
{
    return ITEM_SPACING;
}

- (CATransform3D)carousel:(iCarousel *)_carousel transformForItemView:(UIView *)view withOffset:(CGFloat)offset
{
    view.alpha = 1.0 - fminf(fmaxf(offset, 0.0), 1.0);
    
    CATransform3D transform = CATransform3DIdentity;
    transform.m34 = carouselView.perspective;
    transform = CATransform3DRotate(transform, M_PI / 8.0, 0, 1.0, 0);
    return CATransform3DTranslate(transform, 0.0, 0.0, offset * carouselView.itemWidth);
}

- (BOOL)carouselShouldWrap:(iCarousel *)carousel
{
    return YES;
}


/**
 *  滚动结束
 *
 *  @param carousel
 */
//- (void)carouselDidEndScrollingAnimation:(iCarousel *)carousel;
//{
//
//
//
//    float pag =carousel.scrollOffset/(self.view.frame.size.width-80);
//
//     _page.currentPage = pag;
//
//
//
//}




/**
 *  滚动中
 *
 *  @param carousel
 */

- (void)carouselDidScroll:(iCarousel *)carousel
{
    
    CGFloat pag = carousel.scrollOffset/(self.view.frame.size.width-80);
    
    _page.currentPage = (int)(pag + 0.5);
    
}




/**
 *  点击图片事件
 *
 *  @param sender
 */
-(void)bnnerClick:(UIButton*)sender
{
    NSInteger dex =sender.tag -2000;
    
    ZKrecommenMode *mode =dataArray[dex];
    
    ZKticketListViewController *vc =[[ZKticketListViewController alloc]init];
    [vc updata:mode.ID name:mode.name];
    [self.navigationController pushViewController:vc animated:YES];
    
    
}

#pragma mark 更新界面
-(void)updataView;
{
    
    carouselView =[[iCarousel alloc]initWithFrame:CGRectMake(0, navigationHeghit+20, self.view.frame.size.width, self.view.frame.size.height-(navigationHeghit+20)*2)];
    [self.view addSubview:carouselView];
    
    carouselView.delegate = self;
    carouselView.dataSource = self;
    carouselView.clipsToBounds =YES;
    carouselView.type = 0;
    carouselView.decelerationRate =0.8;
    
    _page = [[UIPageControl alloc]initWithFrame:CGRectMake(0, 0, 150, 30)];
    _page.center =CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height-40);
    
    // 设置页数
    _page.numberOfPages = dataArray.count;
    
    // 设置小点的颜色
    _page.currentPageIndicatorTintColor = CYBColorGreen;
    _page.pageIndicatorTintColor = YJCorl(230, 230, 230);
    [self.view addSubview:_page];
    
    
}



#pragma mark 数据请求
/**
 *  请求
 */
-(void)postData
{
    NSMutableDictionary *dic =[NSMutableDictionary dictionary];
    dic[@"method"] = @"resoureList";
    dic[@"type"] = @"scenery";
    
    [SVProgressHUD showWithStatus:@"正在加载..."];
    [ZKHttp Post:@"" params:dic success:^(id responseObj) {
        [SVProgressHUD dismiss];
        
        dataArray =[ZKrecommenMode objectArrayWithKeyValuesArray:responseObj[@"rows"]];
        
        [self updataView];
        [ZKUtil dictionaryToJson:responseObj[@"rows"] File:@"ZKrecommendViewController"];
        
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        /**
         *  加载缓存
         */
        id array =[ZKUtil File:@"ZKrecommendViewController"];
        if ([array count]>0) {
            
            //            for (int i=0; i<4; i++) {
            
            dataArray =[ZKrecommenMode objectArrayWithKeyValuesArray:array];
            //                [dataArray addObject:mode];
            //            }
            
            [self.view makeToast:@"当前加载为缓存数据"];
            [self updataView];
            
        }else{
            
            [self updataView];
            [self.view makeToast:@"请检查网络连接"];
        }
        
    }];
    
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
