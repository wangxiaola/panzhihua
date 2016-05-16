//
//  WaterF.m
//  CollectionView
//
//  Created by d2space on 14-2-21.
//  Copyright (c) 2014年 D2space. All rights reserved.
//

#import "WaterF.h"
#import "WaterFCell.h"
#import "MJPhoto.h"
#import "MJPhotoBrowser.h"


@interface WaterF ()

@property (nonatomic, strong) WaterFCell* cell;
@property (nonatomic, strong) UIImageView *lyImageView;

@end

@implementation WaterF

- (NSMutableArray *) imagesArr
{
    if (!_imagesArr ) {
        
        _imagesArr = [NSMutableArray arrayWithCapacity:0];
    }
    
    return _imagesArr;
}

- (NSMutableArray *) textsArr
{
    if (!_textsArr ) {
        
        _textsArr = [NSMutableArray arrayWithCapacity:0];
    }
    
    return _textsArr;
}
- (UIImageView *)lyImageView
{

    if (!_lyImageView) {
        
        _lyImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        _lyImageView.center = self.view.center;
        [self.view addSubview:_lyImageView];
    }
    
    return _lyImageView;
}
- (id)initWithCollectionViewLayout:(UICollectionViewLayout *)layout
{
    self = [super initWithCollectionViewLayout:layout];
    if (self)
    {
        [self.collectionView registerClass:[WaterFCell class] forCellWithReuseIdentifier:@"cell"];
        self.collectionView.backgroundColor = [UIColor whiteColor];
        self.collectionView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-64);
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
}

#pragma mark UICollectionViewDataSource
//required
-(NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.sectionNum;
}

/* For now, we won't return any sections */
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{

  return self.imagesArr.count;
   
   
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* identifier = @"cell";
    self.cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    CGFloat aFloat = 0;
    UIImage* image = self.imagesArr[indexPath.item];
    aFloat = self.imagewidth/image.size.width;
    self.cell.imageView.frame = CGRectMake(0, 0, self.imagewidth,  image.size.height*aFloat) ;
    [self getTextViewHeight:indexPath];
    self.cell.nameLabel.frame = CGRectMake(0, image.size.height*aFloat, self.imagewidth, self.textViewHeight);
    self.cell.imageView.image = image;
    self.cell.nameLabel.text = self.textsArr[indexPath.item];

    return self.cell;
}
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
- (void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
#pragma mark - UICollectionView Delegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{

        NSInteger count = self.imagesArr.count;
        // 1.封装图片数据
        NSMutableArray *photos = [NSMutableArray arrayWithCapacity:count];
        
        
        for (int i = 0; i<count; i++) {
            
            NSString *titis = self.textsArr[i];
            MJPhoto *photo = [[MJPhoto alloc] init];
            photo.titis = titis;
            photo.srcImageView = self.lyImageView;
            photo.image = [self.imagesArr objectAtIndex:i]; // 图片路径
            [photos addObject:photo];
        }
        
        // 2.显示相册
        MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
        browser.currentPhotoIndex = indexPath.item; // 弹出相册时显示的第一张图片是？
        browser.photos = photos; // 设置所有的图片
        browser.isDelete =YES;
        [browser show];


}
#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat aFloat = 0;
    UIImage* image = self.imagesArr[indexPath.item];
    aFloat = self.imagewidth/image.size.width;
     CGSize size = CGSizeMake(0,0);
    [self getTextViewHeight:indexPath];
     size = CGSizeMake(self.imagewidth, image.size.height*aFloat+self.textViewHeight);
    return size;
}

- (CGFloat)getTextViewHeight:(NSIndexPath*)indexPath
{
    NSString  *attrStr =self.textsArr[indexPath.item];

    CGSize textSize =[attrStr boundingRectWithSize:CGSizeMake(self.imagewidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} context:nil].size;

    self.textViewHeight = textSize.height;
    return self.textViewHeight;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
