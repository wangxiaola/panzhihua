//
//  LimitInput.h
//  singleview
//
//  Created by aqua on 14-8-30.
//  Copyright (c) 2014年 aqua. All rights reserved.
//

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.co

#import <Foundation/Foundation.h>
#import <objc/runtime.h>


#define PROPERTY_NAME @"limit"

#define DECLARE_PROPERTY(className) \
@interface className (Limit) @end

DECLARE_PROPERTY(UITextField)
DECLARE_PROPERTY(UITextView)

@interface LimitInput : NSObject

@property(nonatomic, assign) BOOL enableLimitCount;

+(LimitInput *) sharedInstance;


@end
