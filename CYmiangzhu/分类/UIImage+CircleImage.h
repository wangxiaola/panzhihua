//
//  UIImage+CircleImage.h
//  CYmiangzhu
//
//  Created by 汤亮 on 15/8/27.
//  Copyright (c) 2015年 WangXiaoLa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (CircleImage)

//将方形图变成带边框的原形图
+ (UIImage *)circleImageWithImage:(UIImage *)image borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor;

//将图片变成指定大小的缩略图
- (UIImage *)imageByScalingAndCroppingForSize:(CGSize)targetSize;
@end
