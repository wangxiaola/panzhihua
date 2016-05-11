//
//  ZKFoodTableViewCell.m
//  CYmiangzhu
//
//  Created by 王小腊 on 15/12/10.
//  Copyright © 2015年 WangXiaoLa. All rights reserved.
//

#import "ZKFoodTableViewCell.h"
#import "ZKscenicSpotList.h"
#import "CYmiangzhu-Swift.h"
#import "ZKLikeModel.h"
NSString *const ZKFoodTableViewCellID = @"ZKFoodTableViewCellID";


@interface ZKFoodTableViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *showImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet RatingBar *ratingBar;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceDescLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@end

@implementation ZKFoodTableViewCell

- (void)setListModel:(ZKscenicSpotList *)listModel
{
    _listModel = listModel;
    [ZKUtil UIimageView:self.showImageView NSSting:[NSString stringWithFormat:@"%@%@", imageUrlPrefix, listModel.logosmall]];
    self.nameLabel.text = listModel.name;
    [self.ratingBar setRating:listModel.exponent];
    self.scoreLabel.text = [NSString stringWithFormat:@"%.1f分", listModel.exponent];
    self.priceLabel.text = listModel.price;
    self.distanceLabel.text = [NSString stringWithFormat:@"%@km", listModel.distance];
}

- (void)setLikeModel:(ZKLikeModel *)likeModel
{
    _likeModel = likeModel;
    [ZKUtil UIimageView:self.showImageView NSSting:[NSString stringWithFormat:@"%@%@", imageUrlPrefix, likeModel.logosmall]];
    self.nameLabel.text = likeModel.dataname;
    [self.ratingBar setRating:likeModel.exponent];
    self.scoreLabel.text = [NSString stringWithFormat:@"%.1f分", likeModel.exponent];
    self.priceLabel.text = likeModel.price;
    self.distanceLabel.text = [NSString stringWithFormat:@"%@km", likeModel.distance];
}

- (void)setCellType:(ZKListCellType)cellType
{
    if (cellType == ZKListCellTypeHotel) {
        self.priceDescLabel.text = @"元起";
    }else if (cellType == ZKListCellTypeFood) {
        self.priceDescLabel.text = @"人均";
    }
}

@end
