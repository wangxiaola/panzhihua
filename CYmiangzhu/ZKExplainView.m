//
//  DQMoreReminderView.m
//  changyouyibin
//
//  Created by Daqsoft-Mac on 14/12/9.
//  Copyright (c) 2014年 WangXiaoLa. All rights reserved.
//

#import "ZKExplainView.h"

#define contentWidth 270
#define contentHeight 230

@implementation ZKExplainView
{
    NSArray *array;
    
    //NSString *str;
    
    UIView *contentView;
    
    
}
-(void)show;
{
    self.alpha = 1;
    
    
    [[APPDELEGATE window] addSubview:self];
    contentView.transform = CGAffineTransformMakeScale(0, 0);
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        contentView.transform = CGAffineTransformMakeScale(1.2, 1.2);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            contentView.transform = CGAffineTransformMakeScale(1, 1);
        } completion:^(BOOL finished) {
            
        }];
    }];
    
}


-(void)sectec:(p_dex)p;
{
    self.sect =p;
    
}



-(id)initTs:(NSString*)ts MarkedWords:(NSString*)words ;
{
    
    self =[super initWithFrame:APPDELEGATE.window.bounds];
    if (self) {
        
        
        UIButton *hideButton = [[UIButton alloc] initWithFrame:self.bounds];
        hideButton.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        [hideButton addTarget:self action:@selector(hideButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:hideButton];
        
        contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, contentWidth, contentHeight)];
        contentView.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
        contentView.backgroundColor = [UIColor whiteColor];
        contentView.layer.cornerRadius = 5;
        [self addSubview:contentView];
        
        UILabel *reminderLabel =[[UILabel alloc]initWithFrame:CGRectMake(10, 0, contentWidth-20, 60)];
        reminderLabel.backgroundColor =[UIColor clearColor];
        reminderLabel.text =[NSString stringWithFormat:@"%@",ts];
        reminderLabel.textColor =CYBColorGreen;
        reminderLabel.font =[UIFont systemFontOfSize:18];
        reminderLabel.font =[UIFont boldSystemFontOfSize:18];
        [contentView addSubview:reminderLabel];
        
        UIView *inview =[[UIView alloc]initWithFrame:CGRectMake(3, 59, contentView.frame.size.width /2, 1)];
        inview.backgroundColor =CYBColorGreen;
        [contentView addSubview:inview];
        
        UILabel *label =[[UILabel alloc]initWithFrame:CGRectMake(10, 55,contentView.frame.size.width -20, contentHeight-55-40)];
        label.text =words;
        label. numberOfLines =0;
        label.textColor =[UIColor grayColor];
        label.font =[UIFont systemFontOfSize:16];
        [contentView addSubview:label];
        
        UIView *viewH =[[UIView alloc]initWithFrame:CGRectMake(3, contentHeight-55, contentView.frame.size.width -6,1)];
        viewH.backgroundColor =CYBColorGreen;
        [contentView addSubview:viewH];

        
        
        UIButton *abrogateButton =[[UIButton alloc]initWithFrame:CGRectMake(0, contentHeight-40, contentWidth, 40)];
        abrogateButton .backgroundColor =[UIColor clearColor];
        [abrogateButton setTitle:@"知道啦！" forState:UIControlStateNormal];
        [abrogateButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        abrogateButton.titleLabel.textAlignment =NSTextAlignmentCenter;
        abrogateButton.titleLabel.font =[UIFont systemFontOfSize:17];
        abrogateButton.titleLabel.font =[UIFont boldSystemFontOfSize:17];
        [abrogateButton addTarget:self action:@selector(cen) forControlEvents:UIControlEventTouchUpInside];
        [contentView addSubview:abrogateButton];
        
    }
    return self;
}


-(void)cen
{
    
    
    [self hideButtonClick];
    
    
    
}

-(void)hideButtonClick{
    
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        
        [self removeFromSuperview];
    }];
}

@end
