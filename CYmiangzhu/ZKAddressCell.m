//
//  ZKAddressCell.m
//  CYmiangzhu
//
//  Created by 汤亮 on 15/12/10.
//  Copyright © 2015年 WangXiaoLa. All rights reserved.
//

#import "ZKAddressCell.h"
#import "ZKscenicSpotList.h"
#import "CYmiangzhu-Swift.h"
#import "ZKLikeModel.h"
NSString *const ZKAddressCellID = @"ZKAddressCellID";

@interface ZKAddressCell()
@property (weak, nonatomic) IBOutlet UIImageView *showImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet RatingBar *ratingBar;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@end

@implementation ZKAddressCell

- (void)setListModel:(ZKscenicSpotList *)listModel
{
    _listModel = listModel;
    [ZKUtil UIimageView:self.showImageView NSSting:[NSString stringWithFormat:@"%@%@", imageUrlPrefix, listModel.logosmall]];
    self.nameLabel.text = listModel.name;
    [self.ratingBar setRating:listModel.exponent];
    self.scoreLabel.text = [NSString stringWithFormat:@"%.1f分", listModel.exponent];
    self.addressLabel.text = listModel.address;
    self.distanceLabel.text = [NSString stringWithFormat:@"%@km", listModel.distance];
}

- (void)setLikeModel:(ZKLikeModel *)likeModel
{
    _likeModel = likeModel;
    [ZKUtil UIimageView:self.showImageView NSSting:[NSString stringWithFormat:@"%@%@", imageUrlPrefix, likeModel.logosmall]];
    self.nameLabel.text = likeModel.dataname;
    [self.ratingBar setRating:likeModel.exponent];
    self.scoreLabel.text = [NSString stringWithFormat:@"%.1f分", likeModel.exponent];
    self.addressLabel.text = likeModel.address;
    self.distanceLabel.text = [NSString stringWithFormat:@"%@km", likeModel.distance];
}

@end
