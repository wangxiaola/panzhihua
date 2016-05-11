//
//  NSString+Regex.h
//  CYmiangzhu
//
//  Created by 汤亮 on 15/8/25.
//  Copyright (c) 2015年 WangXiaoLa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Regex)
- (BOOL)isTelephone;
- (BOOL)isIDCard;
@end
