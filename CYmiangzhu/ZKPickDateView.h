//
//  ZKPickDateView.h
//  CYmiangzhu
//
//  Created by Daqsoft-Mac on 15/9/30.
//  Copyright (c) 2015年 WangXiaoLa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZKAppDelegate.h"

typedef void(^date) (NSString*str,NSString*type);

@interface ZKPickDateView : UIView<UIPickerViewDataSource,UIPickerViewDelegate>
{
    NSMutableArray *_leftArray;
    NSMutableArray *_rightArray;
    
    UIPickerView *_picker;
}
@property(nonatomic,copy)date pickDate;

-(void)date:(date)list;

-(void)show;

@end
