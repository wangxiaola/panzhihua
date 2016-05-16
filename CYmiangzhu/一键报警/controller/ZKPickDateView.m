//
//  ZKPickDateView.m
//  CYmiangzhu
//
//  Created by 王小腊 on 16/5/16.
//  Copyright © 2016年 WangXiaoLa. All rights reserved.
//

#import "ZKPickDateView.h"


#define contentHeight 180

@implementation ZKPickDateView

{
    
    
    NSArray *lyarArray;
    
    
}



-(id)initWithFrame:(CGRect)frame;
{
    
    self =[super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        _leftArray = [[NSMutableArray alloc] initWithObjects:@"今天",@"明天",@"后天", nil];
        
        lyarArray =[self latelyEightTime];
        
        
        // NSDate 日期类型
        NSDate *now = [NSDate date];
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        
        
        // 2,设置格式
        [formatter setDateFormat:@"HH"];
        
        // 3,格式化日期
        NSInteger numTimer = [[formatter stringFromDate:now] integerValue];
        
        
        NSMutableArray *array1 =[NSMutableArray arrayWithCapacity:0];
        
        NSInteger num =24-numTimer;
        
        
        for (int i=0; i<num; i++) {
            
            NSString *str;
            
            
            if (i ==0) {
                
                str =@"现在";
            }else{
                
                numTimer ++;
                str =[NSString stringWithFormat:@"%ld点",(long)numTimer];
                
            }
            
            [array1 addObject:str];
            
        }
        
        // 小学玩的游戏
        NSMutableArray *array2 = [[NSMutableArray alloc] initWithCapacity:0];//5
        for(int i = 0; i < 24; i++){
            NSString *time = [NSString stringWithFormat:@"%d点", i];
            [array2 addObject:time];
        }
        
        
        
        // 大学玩的游戏
        NSMutableArray *array3 = [[NSMutableArray alloc] initWithArray:array2 copyItems:YES];//7
        
        // 把三个小数组添加到大数组中
        _rightArray = [[NSMutableArray alloc] initWithObjects:array1,array2,array3, nil];
        
        
        _picker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, frame.size.height/2)];
        _picker.delegate = self;
        _picker.dataSource = self;
        
        // 显示选中的指示器
        _picker.showsSelectionIndicator = YES;
        
        
        [self addSubview:_picker];
        
        
        
    }
    
    return self;
}


//获取最近几天时间 数组
-(NSMutableArray *)latelyEightTime{
    NSMutableArray *eightArr = [[NSMutableArray alloc] init];
    for (int i = 0; i <3; i ++) {
        //从现在开始的24小时
        NSTimeInterval secondsPerDay =i * 24*60*60;
        
        NSDate *curDate = [NSDate dateWithTimeIntervalSinceNow:secondsPerDay];               NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];         [dateFormatter setDateFormat:@"yyyy-MM-dd"];         NSString *dateStr = [dateFormatter stringFromDate:curDate];
        //组合时间
        NSString *strTime = [NSString stringWithFormat:@"%@",dateStr];
        [eightArr addObject:strTime];
    }
    return eightArr;
}



-(void)date:(date)list;
{
    self.pickDate =list;
    
}
-(void)determineClick
{
    // 用户在第0列中选中的行数
    NSInteger i = [_picker selectedRowInComponent:0];
    
    // 用户在第一列中选中的行数
    NSInteger j = [_picker selectedRowInComponent:1];
    
    // 根据i 确定右边的数据来源于大数组中哪一个小数组
    NSMutableArray *smallArray = [_rightArray objectAtIndex:i];
    
    if (smallArray.count ==0) {
        
        [self makeToast:@"数据正在加载！"];
        
        return;
    }
    NSLog(@"显示用户选中的值");
    
    // 根据j 确定右边选中的标题 是小数组中的哪一个
    NSString *title = [smallArray objectAtIndex:j];
    
    NSString *timer =[_leftArray objectAtIndex:i];
    
    NSString *tpyehh =title;
    
    if ([tpyehh isEqualToString:@"现在"] ) {
        
        NSInteger k =[[smallArray objectAtIndex:j+1] integerValue]-1;
        tpyehh =[NSString stringWithFormat:@"%ld",(long)k];
    }
    
    
    NSString *tpyeTimer =[NSString stringWithFormat:@"%@ %@:00:00",lyarArray[i],[tpyehh  stringByReplacingOccurrencesOfString:@"点" withString:@""]];
    
    self.pickDate([NSString stringWithFormat:@"%@%@",timer,title],tpyeTimer);
    

    
    
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
        
        // 获取到第0列 选中的是哪一行
        NSInteger i = [pickerView selectedRowInComponent:0];
        
        NSMutableArray *smallArray = [_rightArray objectAtIndex:i];
        
        return smallArray.count;
    }
}




// 设置具体某一类中某一行的标题的
// 这个协议方法会调用多次
// 每次系统在调用这个协议方法时,会告诉你现在要设置 哪一列 哪一行的标题
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    
    if (component == 0) {
        // 现在要设置第0列中的标题了
        
        NSString *title = [_leftArray objectAtIndex:row];
        return title;
    }
    else
    {
        // 获取到第0列 选中的是哪一行
        NSInteger i = [pickerView selectedRowInComponent:0];
        
        // 先根据左边选中的是哪一行 从大数组中取出一个小数组(目的是确定一下哪个小数组中放了要显示的标题)
        NSMutableArray *smallArray = [_rightArray objectAtIndex:i];
        
        NSString *title = [smallArray objectAtIndex:row];
        
        return title;
    }
}
// 当选中某一行的时候调用
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component == 0) {
        // 刷新右边的数据
        [pickerView reloadComponent:1];
        
        // 让picker选中 指定的行
        [pickerView selectRow:0 inComponent:1 animated:YES];
    }
}
/*
 - (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
 PickerViewCell *pickerCell = (PickerViewCell *)view;
 if (!pickerCell) {
 NSInteger column = 3;
 pickerCell = [[PickerViewCell alloc] initWithFrame:(CGRect){CGPointZero, [UIScreen mainScreen].bounds.size.width, 45.0f} column:column];
 }
 [pickerCell setLabelTexts:@[...]];
 return pickerCell;
 }
 */

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
