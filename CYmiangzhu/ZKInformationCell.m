//
//  ZKInformationCell.m
//  CYmiangzhu
//
//  Created by 汤亮 on 15/12/16.
//  Copyright © 2015年 WangXiaoLa. All rights reserved.
//

#import "ZKInformationCell.h"
#import "ZKInformationModel.h"

NSString *const ZKInformationCellID = @"ZKInformationCellID";

@interface ZKInformationCell()
@property (weak, nonatomic) IBOutlet UIImageView *showImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *viewCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;

@end

@implementation ZKInformationCell

- (void)setInformationModel:(ZKInformationModel *)informationModel {

    _informationModel = informationModel;
    
    [ZKUtil UIimageView:self.showImageView NSSting:[NSString stringWithFormat:@"%@%@", imageUrlPrefix, informationModel.cover]];
    self.nameLabel.text = informationModel.title;
    self.timeLabel.text = informationModel.addtime;
    self.viewCountLabel.text = informationModel.views;
    self.descLabel.text = informationModel.content;

}
@end
