//
//  ZKCategoryTool.m
//  CYmiangzhu
//
//  Created by 汤亮 on 15/9/2.
//  Copyright (c) 2015年 WangXiaoLa. All rights reserved.
//

#import "ZKCategoryTool.h"
#import "ZKCategory.h"

@implementation ZKCategoryTool

static NSArray *_categories;

+ (NSArray *)categories
{
    if (_categories == nil) {
        _categories = [ZKCategory objectArrayWithFilename:@"category.plist"];
    }
    
    return _categories;
}

@end
