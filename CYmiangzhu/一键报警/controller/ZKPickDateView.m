//
//  ZKPickDateView.m
//  CYmiangzhu
//
//  Created by 王小腊 on 16/5/16.
//  Copyright © 2016年 WangXiaoLa. All rights reserved.
//

#import "ZKPickDateView.h"
#import "ZKPickerViewCell.h"


#define contentHeight 180

@implementation ZKPickDateView

{
    NSArray *_leftArray;
    NSMutableArray *_rightArray;
    NSDate * _newDate;
    UIPickerView *_picker;
}



-(id)initWithFrame:(CGRect)frame selcetDate:(NSDate*)date;
{
    
    self =[super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        _newDate = date;
        _leftArray = @[@"01",@"02",@"03",@"04",@"05",@"06",@"07",@"08",@"09",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20",@"21",@"22",@"23",@"00"];
        
        _rightArray = [NSMutableArray arrayWithCapacity:60];
        
        for (int i = 1; i< 61; i++) {
            if (i == 60) {
                
                [_rightArray addObject:[NSString stringWithFormat:@"00"]];
            }
            else
            {
                if (i < 10) {
                    
                 [_rightArray addObject:[NSString stringWithFormat:@"0%d",i]];
                }
                else
                {
                [_rightArray addObject:[NSString stringWithFormat:@"%d",i]];
                }
                
            }
            
        }
        
        _picker = [[UIPickerView alloc] initWithFrame:CGRectMake(kDeviceWidth/4, 0, kDeviceWidth/2, frame.size.height/2)];
        _picker.delegate = self;
        _picker.dataSource = self;
        // 显示选中的指示器
        _picker.showsSelectionIndicator = YES;
        
        
        [self addSubview:_picker];
        
        
    }
    
    return self;
}

- (void)xqData;
{
    NSDate *date = _newDate;
    //1,创建一个日期格式化器
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    // 2,设置格式
    [formatter setDateFormat:@"HH:mm"];
    
    // 3,格式化日期
    NSString *string = [formatter stringFromDate:date];
    
    NSArray *titis = [string componentsSeparatedByString:@":"];
    
    //选中当前时间
    [_leftArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *str = obj;
        if ([str isEqualToString:titis[0]]) {
            
            [_picker selectRow:idx inComponent:0 animated:YES];
            
        }
    }];
    
    [_rightArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        NSString *str = obj;
        if ([str isEqualToString:titis[1]]) {
            
            [_picker selectRow:idx inComponent:1 animated:YES];
            
        }
    }];
    
    
    [self determineClick];
}
- (void)determineClick
{
    // 用户在第0列中选中的行数
    NSInteger i = [_picker selectedRowInComponent:0];
    
    // 用户在第一列中选中的行数
    NSInteger j = [_picker selectedRowInComponent:1];
    NSString *h = [_leftArray objectAtIndex:i];
    NSString *m = [_rightArray objectAtIndex:j];
    
    [self.delegate selectHstr:h mStr:m];
    
    
}


#pragma mark picker代理
// 设置pickerView中有几列
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}


// 设置每一列中有几行
// 这个协议方法  不是只调用一次, 有几列调用几次
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    
    if (component == 0) {
        // 如果当前要设置第0列的行数
        return _leftArray.count;
    }
    else
    {
        // 设置第1列的行数
        
        return _rightArray.count;
    }
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 60;
}


- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    
    ZKPickerViewCell *pickerCell = (ZKPickerViewCell *)view;
    if (!pickerCell) {
        pickerCell = [[ZKPickerViewCell alloc] initWithFrame:(CGRect){CGPointZero, 60, 60} ];
    }
    
    if (component == 0) {
        
        pickerCell.label.text = _leftArray[row];
    }
    else
    {
        pickerCell.label.text = _rightArray[row];
    }
    return pickerCell;
}
// 当选中某一行的时候调用
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    [self determineClick];
    ZKPickerViewCell * pickerCell =  (ZKPickerViewCell*)[pickerView viewForRow:row forComponent:component];
    [pickerCell select];
}


/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
