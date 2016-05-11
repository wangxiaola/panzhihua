//
//  DQMoreReminderView.m
//  changyouyibin
//
//  Created by Daqsoft-Mac on 14/12/9.
//  Copyright (c) 2014年 WangXiaoLa. All rights reserved.
//

#import "ZKMoreReminderView.h"

#define contentWidth 270
#define contentHeight 170

@implementation ZKMoreReminderView
{
    NSArray *array;
    
    //NSString *str;
    
    UIView *contentView;
    

}

-(void)dism;
{
    self.alpha =0;
    
    [self removeFromSuperview];

}
-(void)show;
{
    self.alpha = 1;

    contentView.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2 - _textHeghit);
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


-(void)didSelect{
   
    
    self.sect(1);
    
     [self hideButtonClick];
    
  
}

-(id)initTs:(NSString*)ts MarkedWords:(NSString*)words ;
{
    
    self =[super initWithFrame:APPDELEGATE.window.bounds];
    if (self) {
        
        _textHeghit = 0;
        UIButton *hideButton = [[UIButton alloc] initWithFrame:self.bounds];
        hideButton.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        [hideButton addTarget:self action:@selector(hideButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:hideButton];
        
        contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, contentWidth, contentHeight)];
        contentView.backgroundColor = [UIColor whiteColor];
        contentView.layer.cornerRadius = 5;
        [self addSubview:contentView];
        
        UILabel *reminderLabel =[[UILabel alloc]initWithFrame:CGRectMake(0, 0, contentWidth, 60)];
        reminderLabel.backgroundColor =[UIColor clearColor];
        reminderLabel.text =[NSString stringWithFormat:@"  %@",ts];
        reminderLabel.textColor =CYBColorGreen;
        reminderLabel.font =[UIFont systemFontOfSize:18];
        reminderLabel.font =[UIFont boldSystemFontOfSize:18];
        [contentView addSubview:reminderLabel];
        
        UIView *inview =[[UIView alloc]initWithFrame:CGRectMake(3, 59, contentView.frame.size.width -6, 1)];
        inview.backgroundColor =CYBColorGreen;
        [contentView addSubview:inview];
        
        UILabel *label =[[UILabel alloc]initWithFrame:CGRectMake(10, 70,contentView.frame.size.width -20, 45)];
        label.text =words;
        label. numberOfLines =2;
        label.textColor =[UIColor grayColor];
        label.font =[UIFont systemFontOfSize:16];
        [contentView addSubview:label];
        
        UIView *viewH =[[UIView alloc]initWithFrame:CGRectMake(3,  120, contentView.frame.size.width -6,1)];
        viewH.backgroundColor =[UIColor colorWithRed:224/255.0 green:224/255.0 blue:224/255.0 alpha:1];
        [contentView addSubview:viewH];
        
        UIView *viewZ =[[UIView alloc]initWithFrame:CGRectMake(contentView.frame.size.width/2, 120, 1, contentHeight -120)];
        viewZ.backgroundColor =[UIColor colorWithRed:224/255.0 green:224/255.0 blue:224/255.0 alpha:1];
        [contentView addSubview:viewZ];
        
        UIButton *confirmButton =[[UIButton alloc]initWithFrame:CGRectMake(0, 120, contentWidth/2, contentHeight-120)];
        confirmButton .backgroundColor =[UIColor clearColor];
        [confirmButton setTitle:@"确定" forState:UIControlStateNormal];
        [confirmButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        confirmButton.titleLabel.font =[UIFont systemFontOfSize:15];
        [confirmButton addTarget:self action:@selector(didSelect) forControlEvents:UIControlEventTouchUpInside];
        [contentView addSubview:confirmButton];
        
        UIButton *abrogateButton =[[UIButton alloc]initWithFrame:CGRectMake(contentWidth/2, 120, contentWidth/2, contentHeight-120)];
        abrogateButton .backgroundColor =[UIColor clearColor];
        [abrogateButton setTitle:@"取消" forState:UIControlStateNormal];
        [abrogateButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        abrogateButton.titleLabel.font =[UIFont systemFontOfSize:15];
        [abrogateButton addTarget:self action:@selector(cen) forControlEvents:UIControlEventTouchUpInside];
        [contentView addSubview:abrogateButton];
        
    }
    return self;
}


-(void)cen
{
    
   self.sect(0);
    
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
