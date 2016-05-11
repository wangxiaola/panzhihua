//
//  ZKStategImageWidth.m
//  CYmiangzhu
//
//  Created by 王小腊 on 16/4/26.
//  Copyright © 2016年 WangXiaoLa. All rights reserved.
//

#import "ZKStategImageWidth.h"

@implementation ZKStategImageWidth

- (instancetype)initImageH:(NSString*)imageUrl;
{
    
    self = [super init];
    if (self) {
        
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrl]];
        
        UIImage *images = [UIImage imageWithData:data];
        self.image = images;
        float imageH = images.size.height;
        float imageW = images.size.width;
        
        self.imageHeghit = (imageH*kDeviceWidth)/imageW;
    }

    return self;
}

@end
