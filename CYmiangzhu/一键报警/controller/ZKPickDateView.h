//
//  ZKPickDateView.h
//  CYmiangzhu
//
//  Created by 王小腊 on 16/5/16.
//  Copyright © 2016年 WangXiaoLa. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^date) (NSString*str,NSString*type);

@interface ZKPickDateView : UIView<UIPickerViewDataSource,UIPickerViewDelegate>
{
    NSMutableArray *_leftArray;
    NSMutableArray *_rightArray;
    
    UIPickerView *_picker;
}
@property(nonatomic,copy)date pickDate;

-(void)date:(date)list;


@end
