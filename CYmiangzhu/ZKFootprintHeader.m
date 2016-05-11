//
//  ZKFootprintHeader.m
//  CYmiangzhu
//
//  Created by 汤亮 on 15/12/18.
//  Copyright © 2015年 WangXiaoLa. All rights reserved.
//

#import "ZKFootprintHeader.h"

@interface ZKFootprintHeader()
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;

@end

@implementation ZKFootprintHeader

+ (instancetype)footprintHeader
{
    return [[NSBundle mainBundle] loadNibNamed:@"ZKFootprintHeader" owner:nil options:nil][0];
}
- (IBAction)addFootprint
{
    if (self.addFootprintCallback) {
        self.addFootprintCallback();
    }
}

- (void)setHeadImage:(UIImage *)headImage
{
    self.headImageView.image = headImage;
}

@end
