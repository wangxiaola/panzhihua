//
//  ZKStrategyCell.m
//  CYmiangzhu
//
//  Created by 汤亮 on 15/12/16.
//  Copyright © 2015年 WangXiaoLa. All rights reserved.
//

#import "ZKStrategyCell.h"
#import "ZKStrategyModel.h"
#import "ZKStategImageWidth.h"

NSString *const ZKStrategyCellID = @"ZKStrategyCellID";

@interface ZKStrategyCell()
@property (weak, nonatomic) IBOutlet UIImageView *strategyImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *viewCountLabel;
@property (weak, nonatomic) IBOutlet UIImageView *fotImage;
@end

@implementation ZKStrategyCell



- (void)setStrategyModel:(ZKStrategyModel *)strategyModel
{
    _strategyModel = strategyModel;
    
    [ZKUtil UIimageView:self.strategyImageView NSSting:[NSString stringWithFormat:@"%@%@", imageUrlPrefix, strategyModel.images]];
    self.nameLabel.text = strategyModel.title;
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd";
    NSDate *addDate = [NSDate dateWithTimeIntervalSince1970:strategyModel.addtime.doubleValue / 1000];
    self.timeLabel.text = [fmt stringFromDate:addDate];
    self.viewCountLabel.text = [NSString stringWithFormat:@"%@人查看",strategyModel.views];
    self.fotImage.layer.masksToBounds =YES;
    self.fotImage.layer.cornerRadius =15;
    [ZKUtil UIimageView:self.fotImage NSSting:strategyModel.photo];
}

- (void)setFrame:(CGRect)frame
{
    frame.size.height -= 5;
    [super setFrame:frame];
}

@end
