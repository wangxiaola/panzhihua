//
//  ZKTimePickerViewController.m
//  guide
//
//  Created by 汤亮 on 15/10/15.
//  Copyright © 2015年 daqsoft. All rights reserved.
//

#import "ZKTimePickerViewController.h"
#import "ZKBasicViewController.h"
static const int kDayButtoRowMargin = 10;  //每个天数按钮之间的行间距
static const int kDayButtoRayMargin = 15;  //每个天数按钮之间的列间距
#define kDayButtonWidth (self.view.bounds.size.width - 5 * kDayButtoRayMargin) / 4
static const int kDayButtonHeight = 30; //每个天数按钮的高度
static const int kHourButtonRows = 4; //小时选择按钮的行数
static const int kHourButtonRays = 6; //小时选择按钮的列数
#define kHourButtonWH self.view.bounds.size.width / kHourButtonRays //小时选择按钮的宽高

@interface ZKTimePickerViewController()
@property (nonatomic, weak) UIScrollView *dayPickerView;
@property (nonatomic, weak) UIView *hourPickerView;

//当前被选中的天数按钮
@property (nonatomic, weak) UIButton *selectedDayButton;
//当前选中的开始时间按钮
@property (nonatomic, weak) UIButton *selectedStartHourButton;

//当前选中的开始小时
@property (nonatomic, copy) NSString *selectedStarHour; //13:00
//当前选中的结束小时
@property (nonatomic, copy) NSString *selectedEndHour;
//当前选中第几天
@property (nonatomic, copy) NSString *selectedDay;

//开始结束的label
@property (nonatomic, strong) UILabel *startLabel;
@property (nonatomic, strong) UILabel *endLabel;

//小时选择点击次数
@property (nonatomic, assign) int hourButtonClickedCount;

@property (nonatomic, strong) NSMutableArray *defaultArray;
@end

@implementation ZKTimePickerViewController

@synthesize defaultArray;

#pragma mark - override
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    NSString *stateString = [self.info valueForKey:@"usetime"];
    NSArray *pcArray = [stateString componentsSeparatedByString:@";"];
    defaultArray = [NSMutableArray arrayWithCapacity:pcArray.count];
    
    for (NSString *str in pcArray) {
        NSArray *titisArry = [str componentsSeparatedByString:@","];
        [defaultArray addObject:titisArry];
        
    }

    
    [self setupNav];
    
    [self setupDayPickerView];
    
    [self setupHourPickerViewSelected:-1];
    
    [self setupDayPickerViewStatus];
    
    [self setupNextStepButton];
    
    

}

#pragma mark - 设置下一步按钮
- (void)setupNextStepButton
{
    UIButton *nextStepButton = [[UIButton alloc] init];
    nextStepButton.frame = CGRectMake(15, CGRectGetMaxY(self.hourPickerView.frame) + 10, self.view.bounds.size.width - 30, 35);
    nextStepButton.titleLabel.font = SYSTEMFONT(15);
    nextStepButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    nextStepButton.backgroundColor = OrangeColor;
    [nextStepButton setTitleColor:WhiteColor forState:UIControlStateNormal];
    [nextStepButton setTitle:@"下一步" forState:UIControlStateNormal];
    nextStepButton.layer.cornerRadius = 3;
    nextStepButton.layer.masksToBounds = YES;
    [nextStepButton addTarget:self action:@selector(nextStep) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextStepButton];
}

- (void)nextStep
{
    if (self.selectedStarHour == nil) {
        [SVProgressHUD showErrorWithStatus:@"请选择开始时间"];
        return;
    }
    
    if (self.selectedEndHour == nil) {
        [SVProgressHUD showErrorWithStatus:@"请选择结束时间"];
        return;
    }
    
    
    
    ZKBasicViewController *web = [[ZKBasicViewController alloc] init];
    web.backTwo = YES;
    NSString *time = [NSString stringWithFormat:@"%@-%@", self.selectedStarHour, self.selectedEndHour];
    NSString *url = [self.info[@"willurl"] stringByAppendingString:[NSString stringWithFormat:@"&selectedDay=%@&time=%@&z_pagetitle=行程资源选择",self.selectedDay, time]];
    web.webToUrl = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    web.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:web animated:YES];
}

#pragma mark - 设置导航栏
- (void)setupNav
{
    self.titeLabel.text = @"行程定制";
    self.leftBarButtonItem = [[UIButton alloc]initWithFrame:CGRectMake(2, 20, buttonItemWidth, buttonItemWidth)];
    [self.leftBarButtonItem setImage:[UIImage imageNamed:@"nav_back"] forState:UIControlStateNormal];
    [self.leftBarButtonItem addTarget:self action:@selector(navback) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationBarView  addSubview:self.leftBarButtonItem];
}

- (void)navback
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 开始结束label
- (UILabel *)startLabel
{
    if (_startLabel == nil) {
        self.startLabel = [[UILabel alloc] init];
        _startLabel.text = @"开始";
        _startLabel.font = [UIFont systemFontOfSize:10];
        _startLabel.textColor = [UIColor whiteColor];
        _startLabel.textAlignment = NSTextAlignmentCenter;
        _startLabel.frame = CGRectMake(0, kHourButtonWH - 20, kHourButtonWH, 20);
    }
    
    return _startLabel;
}

- (UILabel *)endLabel
{
    if (_endLabel == nil) {
        self.endLabel = [[UILabel alloc] init];
        _endLabel.text = @"结束";
        _endLabel.font = [UIFont systemFontOfSize:10];
        _endLabel.textColor = [UIColor whiteColor];
        _endLabel.textAlignment = NSTextAlignmentCenter;
        _endLabel.frame = CGRectMake(0, kHourButtonWH - 20, kHourButtonWH, 20);
    }
    
    return _endLabel;
}

#pragma mark - 设置第几天选择view
- (void)setupDayPickerView
{
    UIScrollView *dayPickerView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, navigationHeghit, self.view.bounds.size.width, kDayButtonHeight + 2 * kDayButtoRowMargin)];
    dayPickerView.showsHorizontalScrollIndicator = NO;
    dayPickerView.backgroundColor = RGBACOLOR(231, 231, 231, 1);
    [self.view addSubview:dayPickerView];
    self.dayPickerView = dayPickerView;
    
}

#pragma mark - 设置几点钟选择view
- (void)setupHourPickerViewSelected:(NSInteger)index;
{
    
    
    [self.hourPickerView removeFromSuperview];
    
    UIView *hourPickerView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.dayPickerView.frame), self.view.bounds.size.width, kHourButtonWH * kHourButtonRows + 1 * kHourButtonRows)];
    hourPickerView.backgroundColor = ClearColor;
    hourPickerView.clipsToBounds = YES;
    [self.view addSubview:hourPickerView];
    self.hourPickerView = hourPickerView;
    
    //添加子控件
    for (int i = 0; i < kHourButtonRows * kHourButtonRays; ++i) {
        
        int row = i / kHourButtonRays;
        int ray = i % kHourButtonRays;
        CGFloat x = kHourButtonWH * ray;
        CGFloat y = (kHourButtonWH + 1) * row;
        
        UIButton *hourButton = [[UIButton alloc] init];
        hourButton.adjustsImageWhenHighlighted = NO;
        hourButton.frame = CGRectMake(x, y, kHourButtonWH, kHourButtonWH);
        hourButton.titleLabel.font = SYSTEMFONT(12);
        hourButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        [hourButton setTitleColor:BlackColor forState:UIControlStateNormal];
        [hourButton setTitleColor:WhiteColor forState:UIControlStateSelected];
        [hourButton setTitle:[NSString stringWithFormat:@"%d", i] forState:UIControlStateNormal];
        
        [hourButton setBackgroundImage:[UIImage imageNamed:@"button_noRadius_normal"] forState:UIControlStateNormal];
        [hourButton setBackgroundImage:[UIImage imageNamed:@"button_noRadius_selected"] forState:UIControlStateSelected];
        hourButton.tag = i;
        //加不可选button
        if (index >= 0) {
            
            NSArray *selectedArray =defaultArray[index];
            
            BOOL isselected = [selectedArray containsObject:[NSString stringWithFormat:@"%d", i]];
            
            
            if (isselected && selectedArray.count>1) {
                
                hourButton.tag = (index+1)*1000;
                [hourButton setBackgroundImage:[UIImage imageNamed:@"state_date.jpg"] forState:0];
            }
   
        }
        
        hourButton.layer.shadowOffset = CGSizeZero;
        [hourButton addTarget:self action:@selector(hourButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.hourPickerView addSubview:hourButton];
    }
}



#pragma mark - 设置选择第几天初始化状态
- (void)setupDayPickerViewStatus
{
    [self.dayPickerView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    CGFloat y = kDayButtoRowMargin;
    for (int i = 1; i <= [self.info[@"day"] integerValue]; i++) {
        
        CGFloat x = kDayButtoRayMargin + (kDayButtoRayMargin +  kDayButtonWidth) * (i -1);
        
        UIButton *dayButton = [[UIButton alloc] init];
        dayButton.frame = CGRectMake(x, y, kDayButtonWidth, kDayButtonHeight);
        dayButton.titleLabel.font = SYSTEMFONT(12);
        dayButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        [dayButton setTitleColor:BlackColor forState:UIControlStateNormal];
        [dayButton setTitleColor:WhiteColor forState:UIControlStateSelected];
        dayButton.backgroundColor = WhiteColor;
        [dayButton setTitle:[NSString stringWithFormat:@"第%d天", i] forState:UIControlStateNormal];
        dayButton.layer.cornerRadius = 3;
        dayButton.layer.masksToBounds = YES;
        dayButton.tag = i;
        
        [dayButton addTarget:self action:@selector(dayButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        
        if (i == [self.info[@"day"] integerValue]) {
            self.dayPickerView.contentSize = CGSizeMake(CGRectGetMaxX(dayButton.frame) + kDayButtoRayMargin, 0);
        }
        
        [self.dayPickerView addSubview:dayButton];
    }
    
    //将传递进来的当前选中天数对应的按钮选中
    if (![self.info[@"selectedDay"] isEqualToString:@""]) {
        UIButton *needSelectDayButton = (UIButton *)[self.dayPickerView viewWithTag:[self.info[@"selectedDay"] integerValue]];
        [self dayButtonClick:needSelectDayButton];
    }
 
    if (![self.info[@"start"] isEqualToString:@""]) {
        //将传递进来的当前选中开始小时对应的按钮选中
        UIButton *needSelectHourButton1 = (UIButton *)[self.hourPickerView viewWithTag:[self.info[@"start"] integerValue]];
        [self hourButtonClick:needSelectHourButton1];
    }
 
    if (![self.info[@"end"] isEqualToString:@""]) {
        //将传递进来的当前选中结束小时对应的按钮选中
        UIButton *needSelectHourButton2 = (UIButton *)[self.hourPickerView viewWithTag:[self.info[@"end"] integerValue]];
        [self hourButtonClick:needSelectHourButton2];
    }

    

}

#pragma mark - 第几天点击
- (void)dayButtonClick:(UIButton *)dayButton
{
    
    
    [self setupHourPickerViewSelected:dayButton.tag - 1];
    
    //同一个按钮直接返回
    if (self.selectedDayButton == dayButton) {
        return;
    }
    
    //选择的第几天
    self.selectedDay = [NSString stringWithFormat:@"%ld",(long)dayButton.tag];
    //同时清空选择这天所有的小时选择按钮状态
    [self resetHourButtonStatus];
    
    //让之前选中的按钮设置为非选中状态，并设置颜色，现在选中的按钮设置为选中状态，并设置颜色
    self.selectedDayButton.selected = NO;
    self.selectedDayButton.backgroundColor = WhiteColor;
    dayButton.selected = YES;
    dayButton.backgroundColor = RGBCOLOR(51, 202, 171);
    self.selectedDayButton = dayButton;
}

#pragma mark - 在选择小时之前，判断是否先选中了第几天
- (BOOL)isSelectedDayButton
{
    BOOL hasSelected = NO;
    for (id view in self.dayPickerView.subviews) {
        
        //self.dayPickerView本身是scrollView,它的subviews里面除了手动添加的UIButton,还有一个UIImageView
//        MMLog(@"%@", [view class]);
    
        if (![view isKindOfClass:[UIButton class]]) {
            continue;
        }
        
        UIButton *dayButton = view;
        if (dayButton.isSelected) {
            hasSelected = YES;
            break;
        }
        
    }
    
    return hasSelected;
}

#pragma mark - 小时点击
- (void)hourButtonClick:(UIButton *)hourButton
{
    //在选择小时之前，判断是否先选中了第几天
    if ([self isSelectedDayButton] == NO) {
        [SVProgressHUD showErrorWithStatus:@"请先选择行程日期"];
        return;
    }
    
    
    
    
    NSArray *selectedArray =defaultArray[self.selectedDay.integerValue - 1];
    BOOL isselected = [selectedArray containsObject:hourButton.titleLabel.text];
    NSInteger p = hourButton.titleLabel.text.integerValue;
    
    if (isselected && selectedArray.count>1) {

        [SVProgressHUD showErrorWithStatus:@"当天已经有行程安排了!"];
        return;
    }

    if (self.selectedStarHour && selectedArray.count>1 && self.selectedEndHour == nil) {
        
        NSString *str_0 =selectedArray[selectedArray.count-1];
        NSString *str_1 =selectedArray[0];
        NSString *state = [self.selectedStarHour stringByReplacingOccurrencesOfString:@":00" withString:@""];
        
        if (state.integerValue < str_1.integerValue && p > str_0.integerValue) {
            self.hourButtonClickedCount--;
            [SVProgressHUD showErrorWithStatus:@"选中时间段已有行程安排!"];
            [self resetHourButtonStatus];
            return;
        }
    }
    
    //同一个按钮直接返回
    if (self.selectedStartHourButton == hourButton) {
        return;
    }
    

    //选择的次数加一次
    self.hourButtonClickedCount++;
    
    //每奇数次选择重置按钮状态，添加开始两字到按钮上，同时保存当前选中的开始按钮和开始时间
    if (self.hourButtonClickedCount%2 == 1) {
        
        [self resetHourButtonStatus];
        [hourButton setBackgroundImage:[UIImage imageNamed:@"button_leftRadius_selected"] forState:UIControlStateSelected];
        [hourButton addSubview:self.startLabel];
        self.selectedStartHourButton = hourButton;
        self.selectedStarHour = [NSString stringWithFormat:@"%@:00", hourButton.titleLabel.text];
    
    //每偶数次选择重置按钮状态
    }else if (self.hourButtonClickedCount%2 == 0){

        //如果每偶数次选择的小时时间小于之前选择的小时时间，与奇数次选择做同样的操作，并将选择次数减1以保证选择奇数偶数次选择做不同的操作
        if (self.selectedStartHourButton.tag > hourButton.tag) {
            
            [self resetHourButtonStatus];
            [hourButton setBackgroundImage:[UIImage imageNamed:@"button_leftRadius_selected"] forState:UIControlStateSelected];
            [hourButton addSubview:self.startLabel];
            self.selectedStartHourButton = hourButton;
            self.selectedStarHour = [NSString stringWithFormat:@"%@:00", hourButton.titleLabel.text];
            self.hourButtonClickedCount--;
            
        //如果每偶数次选择的小时时间大于之前选择的小时时间,将结束两字添加到按钮上，同时保存当前结束时间
        }else{
            
            [hourButton setBackgroundImage:[UIImage imageNamed:@"button_rightRadius_selected"] forState:UIControlStateSelected];
            [hourButton addSubview:self.endLabel];
            [self selectHourButtonsFrom:self.selectedStartHourButton.tag to:hourButton.tag];
            self.selectedEndHour = [NSString stringWithFormat:@"%@:00", hourButton.titleLabel.text];
        }
    }
    
    //每选中一个按钮则将这个按钮点选中状态设置为YES
    hourButton.selected = YES;
}

#pragma mark - 重置小时选择状态
- (void)resetHourButtonStatus
{
    //清空开始结束时间
    self.selectedStarHour = nil;
    self.selectedEndHour = nil;
    //取消小时选中状态
    [self cancelHourButtonSelected:self.selectedDay.integerValue*1000];
    //移除开始结束label
    [self.startLabel removeFromSuperview];
    [self.endLabel removeFromSuperview];
}

#pragma mark - 取消小时选中状态
- (void)cancelHourButtonSelected:(NSInteger)index;
{
    
    
    for (UIButton *button in self.hourPickerView.subviews) {
        
        NSLog(@"%ld",(long)button.tag);
        if (button.tag != index) {
            
            [button setBackgroundImage:[UIImage imageNamed:@"button_noRadius_normal"] forState:UIControlStateNormal];
            [button setBackgroundImage:[UIImage imageNamed:@"button_noRadius_selected"] forState:UIControlStateSelected];
            button.selected = NO;

        }
    }
}

#pragma amrk - 从开始时间到结束时间的所有按钮都变为选中状态
- (void)selectHourButtonsFrom:(NSInteger)fromTime to:(NSInteger)toTime
{
    for (NSInteger i = fromTime + 1; i < toTime; i++) {
        UIButton *hourButton = (UIButton *)[self.hourPickerView viewWithTag:i];
        hourButton.selected = YES;
    }

}

@end
