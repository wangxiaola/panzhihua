//
//  ZKFootprintHeader.h
//  CYmiangzhu
//
//  Created by 汤亮 on 15/12/18.
//  Copyright © 2015年 WangXiaoLa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZKFootprintHeader : UIView
+ (instancetype)footprintHeader;
- (void)setHeadImage:(UIImage *)headImage;

@property (nonatomic, copy) void (^addFootprintCallback)();
@end
