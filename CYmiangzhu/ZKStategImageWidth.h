//
//  ZKStategImageWidth.h
//  CYmiangzhu
//
//  Created by 王小腊 on 16/4/26.
//  Copyright © 2016年 WangXiaoLa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZKStategImageWidth : NSObject

@property (nonatomic, assign) float imageHeghit;
@property (nonatomic, copy) UIImage *image;

- (instancetype)initImageH:(NSString*)imageUrl;

@end
