//
//  ZKguideInforView.m
//  CYmiangzhu
//
//  Created by Daqsoft-Mac on 15/9/30.
//  Copyright (c) 2015年 WangXiaoLa. All rights reserved.
//

#import "ZKguideInforView.h"


#define contentWidth 270
#define contentHeight 150

@implementation ZKguideInforView
{
    
    UIView *contentView;
    
    ListMapData *data;
    
}

-(void)dism;
{
    self.alpha =0;
    
    [self removeFromSuperview];
    
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



-(id)initData:(ListMapData*)list;
{
    
    self =[super initWithFrame:APPDELEGATE.window.bounds];
    if (self) {
        
        
        data =list;
        
        UIView *hideButton = [[UIView alloc] initWithFrame:self.bounds];
        hideButton.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        
        [self addSubview:hideButton];
        
        UIButton *bastButton =[[UIButton alloc]initWithFrame:hideButton.frame];
        [bastButton addTarget:self action:@selector(hideButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [hideButton addSubview:bastButton];
        
        
        contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, contentWidth, contentHeight)];
        contentView.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
        contentView.backgroundColor = [UIColor whiteColor];
        [self addSubview:contentView];
        
        UIImageView *backImage =[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, contentWidth, contentHeight-50)];
        backImage.image = [UIImage imageNamed:@"map_guideInfo_bg"];
        [contentView addSubview:backImage];
        
        UIButton *dismButton =[[UIButton alloc]initWithFrame:CGRectMake(contentWidth-19, 3, 16, 16)];
        [dismButton setBackgroundImage:[UIImage imageNamed:@"map_guideInfo_exit"] forState:0];
        [dismButton addTarget:self action:@selector(hideButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [contentView addSubview:dismButton];
        
        
        UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 20, contentWidth-20, 20)];
        nameLabel.textAlignment =NSTextAlignmentLeft;
        nameLabel.textColor =[UIColor whiteColor];
        nameLabel.font =[UIFont systemFontOfSize:14];
        nameLabel.text = list.name;
        [contentView addSubview:nameLabel];
        
        UILabel *adderLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 40, contentWidth-20, 40)];
        adderLabel.textAlignment =NSTextAlignmentLeft;
        adderLabel.textColor =[UIColor whiteColor];
        adderLabel.font =[UIFont systemFontOfSize:14];
        adderLabel.numberOfLines =2;
        adderLabel.text = [NSString stringWithFormat:@"地址 : %@",list.address];;
        [contentView addSubview:adderLabel];
        
        float buttonw =(contentWidth-16-4)/2;
        
        UIButton *lefButton =[[UIButton alloc]initWithFrame:CGRectMake(8, contentHeight-42, buttonw, 50-16)];
        [lefButton setBackgroundColor:CYBColorGreen];
        [lefButton setTitle:@"电话" forState:0];
        lefButton.layer.cornerRadius =4;
        lefButton.tag =2000;
        [lefButton setTitleColor:[UIColor whiteColor] forState:0];
        [lefButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [contentView addSubview:lefButton];
        
        UIButton *ritButton =[[UIButton alloc]initWithFrame:CGRectMake(8+buttonw+4, contentHeight-42, buttonw, 50-16)];
        [ritButton setBackgroundColor:CYBColorGreen];
        [ritButton setTitle:@"导航" forState:0];
        ritButton.layer.cornerRadius =4;
        [ritButton setTitleColor:[UIColor whiteColor] forState:0];
        ritButton.tag =2001;
        [ritButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [contentView addSubview:ritButton];
        
    }
    return self;
}

-(void)buttonClick:(UIButton*)sender
{
    
    if (sender.tag ==2000) {
        
        if (self.senderbutton) {
            self.senderbutton(data,0);
        }
        
        
    }else{
        
        if (self.senderbutton) {
            self.senderbutton(data,1);
        }
    }
    
    [self dism];
    
    
}


-(void)click:(senderBUtton)sender;
{
    
    self.senderbutton =sender;
}

-(void)hideButtonClick{
    
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        
        [self removeFromSuperview];
    }];
}

@end

