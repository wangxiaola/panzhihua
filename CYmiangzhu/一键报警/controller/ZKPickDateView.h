//
//  ZKPickDateView.h
//  CYmiangzhu
//
//  Created by 王小腊 on 16/5/16.
//  Copyright © 2016年 WangXiaoLa. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ZKPickDateViewDelegate <NSObject>

- (void)selectHstr:(NSString*)h mStr:(NSString*)m;

@end

@interface ZKPickDateView : UIView<UIPickerViewDataSource,UIPickerViewDelegate>

- (void)xqData;

-(id)initWithFrame:(CGRect)frame selcetDate:(NSDate*)date;

@property (weak, nonatomic)id<ZKPickDateViewDelegate>delegate;
@end
