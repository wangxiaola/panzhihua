//
//  ZKFootprintCell.m
//  CYmiangzhu
//
//  Created by 汤亮 on 15/12/17.
//  Copyright © 2015年 WangXiaoLa. All rights reserved.
//

#import "ZKFootprintCell.h"
#import "ZKFootprintModel.h"

NSString *const ZKFootprintCellID = @"ZKFootprintCellID";

@interface ZKFootprintCell()
@property (weak, nonatomic) IBOutlet UILabel *addTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *footprintImageView;
@property (weak, nonatomic) IBOutlet UIView *borderView;

@end

@implementation ZKFootprintCell

- (void)awakeFromNib {
    // Initialization code
}

-(void)setFootprintModel:(ZKFootprintModel *)footprintModel
{
    _footprintModel = footprintModel;

    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd";
    NSDate *addDate = [NSDate dateWithTimeIntervalSince1970:footprintModel.date / 1000];
    NSString *addDateStr = [fmt stringFromDate:addDate];
    self.addTimeLabel.text = addDateStr;
    
    self.nameLabel.text = footprintModel.name;
    
    self.borderView.hidden = footprintModel.img == nil;
    [ZKUtil UIimageView:self.footprintImageView NSSting:[NSString stringWithFormat:@"%@%@", imageUrlPrefix, footprintModel.img] duImage:footprintModel.img == nil ? nil : @"zz"];
}



@end
