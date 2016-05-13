//
//  ZKNewHomeTableViewCell.h
//  CYmiangzhu
//
//  Created by 王小腊 on 16/5/11.
//  Copyright © 2016年 WangXiaoLa. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 *  cell样式
 */
typedef NS_ENUM(NSInteger,homecellTyper) {
    /**
     *  优惠
     */
    homecellOne = 0,
    /**
     *  攻略
     */
    homecellTow,
};

@class ZKInformationModel;
@class ZKStrategyModel;

#define cellHeight 500/3

@interface ZKNewHomeTableViewCell : UITableViewCell

@property (nonatomic, strong) UIView *pictureView;

@property (nonatomic, strong)UIImageView *backImageView;

@property (nonatomic, strong) UILabel *inforLabel;

@property (nonatomic, strong) UIImageView *lefImageView;

@property (nonatomic, strong) UILabel *stateLabel;

@property (nonatomic) homecellTyper cellType;

@property (nonatomic, strong) ZKInformationModel *dataOne;
@property (nonatomic, strong) ZKStrategyModel *dataTow;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier SuperViews:(homecellTyper)typer;


@end
