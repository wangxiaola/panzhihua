//
//  JYTMyTextField.m
//  jy_bean_out
//
//  Created by 周德江 on 14-11-12.
//  Copyright (c) 2014年 joyoung. All rights reserved.
//

#import "ZKTextField.h"

@implementation ZKTextField

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.spacing =0;
    }
    return self;
}
//控制文本所在的的位置，左右缩 10
- (CGRect)textRectForBounds:(CGRect)bounds {
    
    float pc ;
    if (self.spacing ==0) {
        pc =15;
        
    }else{
    
        pc =self.spacing;
    }
    return CGRectInset( bounds , _spacing , 0 );
}

//控制编辑文本时所在的位置，左右缩 10
- (CGRect)editingRectForBounds:(CGRect)bounds {
    float pc ;
    if (self.spacing ==0) {
        pc =15;
        
    }else{
        
        pc =self.spacing;
    }
    return CGRectInset( bounds , _spacing , 0 );
}

-(CGRect) leftViewRectForBounds:(CGRect)bounds {
    
    CGRect iconRect = [super leftViewRectForBounds:bounds];

    iconRect.origin.x += 4;

    return iconRect;

}

@end
