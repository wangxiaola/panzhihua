//
//  ZKpickDataView.m
//  weipeng
//
//  Created by Daqsoft-Mac on 15/2/10.
//  Copyright (c) 2015年 WangXiaoLa. All rights reserved.
//

#import "ZKmerchandiseView.h"
#define contentWidth 270
#define contentHeight 280
@implementation ZKmerchandiseView
{
    
    NSMutableArray *array;
    
    UIView *contentView;
    
    UIScrollView *scroll;
    
    NSArray *data;
    
    NSString *gao;
    
    NSString *di;
    
    NSInteger tg;
    
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

-(void)didSelect{
    
    
    
    NSMutableArray *contArray =[[NSMutableArray alloc]initWithCapacity:0];
    for (id d  in array) {

        if ([d isEqualToString:@"站位"]) {

        }else{
        
            [contArray addObject:d];

            
        }
        
    }
    
    
    [self hideButtonClick];
    if (array.count>0) {
        
        if ([self.delegate respondsToSelector:@selector(array:tp:)]) {
            [self.delegate array:contArray tp:tg];
        }
    }
    
}

-(id)initArray:(NSArray*)list Name:(NSString*)str sect:(NSString*)p tp:(NSInteger)j;
{
    
    self =[super initWithFrame:APPDELEGATE.window.bounds];
    if (self) {
        
        data =list;
        array =[[NSMutableArray alloc]initWithCapacity:0];
        tg =j;
        
        UIButton *hideButton = [[UIButton alloc] initWithFrame:self.bounds];
        hideButton.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        [hideButton addTarget:self action:@selector(hideButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:hideButton];
        
        contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, contentWidth, contentHeight)];
        contentView.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
        contentView.backgroundColor = [UIColor whiteColor];
        contentView.layer.cornerRadius = 5;
        [self addSubview:contentView];
        
        UILabel *reminderLabel =[[UILabel alloc]initWithFrame:CGRectMake(10, 0, contentWidth, 60)];
        reminderLabel.backgroundColor =[UIColor clearColor];
        reminderLabel.text =str;
        reminderLabel.textColor =CYBColorGreen;
        reminderLabel.font =[UIFont systemFontOfSize:20];
        reminderLabel.font =[UIFont boldSystemFontOfSize:20];
        [contentView addSubview:reminderLabel];
        
        UIView *inview =[[UIView alloc]initWithFrame:CGRectMake(6, 59, contentView.frame.size.width -12, 1)];
        inview.backgroundColor =CYBColorGreen;
        [contentView addSubview:inview];
        
        scroll =[[UIScrollView alloc]initWithFrame:CGRectMake(0, 60, contentView.frame.size.width, contentView.frame.size.height-120)];
        scroll.backgroundColor =[UIColor whiteColor];
        scroll.contentOffset =CGPointMake(0, 0);
        scroll.contentSize =CGSizeMake(contentWidth, 46*list.count);
        [contentView addSubview:scroll];
        
        gao =@"checked";
        di =@"check";
        
        
        NSArray *dqArray ;
        if (p!=nil) {
            
        dqArray =[p componentsSeparatedByString:@","];
            
        }

        for (int i=0; i<list.count; i++) {
            
            
            
            UIImageView *lefImage =[[UIImageView alloc]initWithFrame:CGRectMake(6, 46/2-10+46*i, 20, 20)];
            lefImage.backgroundColor =[UIColor whiteColor];
            
              lefImage.image =[UIImage imageNamed:di];
            
            
          
            
            lefImage.tag =1000+i;
            [scroll addSubview:lefImage];
            
            if (i<list.count-1) {
                
                UIView *lin0 =[[UIView alloc]initWithFrame:CGRectMake(6,46+(46*i) ,contentWidth-12, 1)];
                lin0 .backgroundColor =TabelBackCorl;
                [scroll addSubview:lin0];
            }
            
            
            UILabel *name =[[UILabel alloc]initWithFrame:CGRectMake(40, 46*i, contentWidth-50, 46)];
            name.backgroundColor =[UIColor clearColor];
            NSArray *tits =[list[i] componentsSeparatedByString:@"#"];
            name.text =tits[1];
            name.font =[UIFont systemFontOfSize:13];
            name.textColor =[UIColor blackColor];
            name.textAlignment =NSTextAlignmentLeft;
            [scroll addSubview:name];
            
            UIButton *but =[[UIButton alloc]initWithFrame:CGRectMake(0, 46*i, contentWidth, 46)];
            but.backgroundColor =[UIColor clearColor];
            but.tag =2000+i;
            [but addTarget:self action:@selector(buttClick:) forControlEvents:UIControlEventTouchUpInside];
            [scroll addSubview:but];
            
            [array addObject:@"站位"];
            
            /**
             *  判断几个已经多选
             */
            if ( dqArray.count>0) {

                for (NSString *k  in dqArray) {
      
                        
                        NSString *str_0 = name.text;
                        
                        if ([str_0 isEqualToString:k]) {
                            
                            lefImage.image =[UIImage imageNamed:gao];
                            [array replaceObjectAtIndex:i withObject:[data objectAtIndex:i]];
                            but.selected =YES;
                            
                        }
                    
                }
            }

            
            
            
        }
        
        UIView *viewH =[[UIView alloc]initWithFrame:CGRectMake(6,  contentView.frame.size.height-60, contentView.frame.size.width-12,1)];
        viewH.backgroundColor =CYBColorGreen;
        [contentView addSubview:viewH];
        
        
        UIButton *confirmButton =[[UIButton alloc]initWithFrame:CGRectMake(contentWidth-70, -10, 80, 80)];
        confirmButton .backgroundColor =[UIColor clearColor];
        [confirmButton setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
        [confirmButton addTarget:self action:@selector(hideButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [contentView addSubview:confirmButton];
        
        UIButton *abrogateButton =[[UIButton alloc]initWithFrame:CGRectMake(10, contentHeight-50, contentWidth-20, 40)];
        abrogateButton .backgroundColor =CYBColorGreen;
        [abrogateButton setTitle:@"确定" forState:UIControlStateNormal];
        [abrogateButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        abrogateButton.titleLabel.font =[UIFont systemFontOfSize:18];
        abrogateButton.layer.cornerRadius =6;
        [abrogateButton addTarget:self action:@selector(didSelect) forControlEvents:UIControlEventTouchUpInside];
        [contentView addSubview:abrogateButton];
        
        
        
        
    }
    return self;
}

-(void)buttClick:(UIButton*)sender
{
    
    NSInteger j =sender.tag -2000;
    
    for (UIView *s in scroll.subviews)
    {
        
        if ([s isKindOfClass:[UIImageView class]] )
        {
            
            if (s.tag ==1000+j) {
                
                if (sender.selected ==NO) {
                    
                    [array replaceObjectAtIndex:j withObject:[data objectAtIndex:j]];
                    
                    [(UIImageView*)s  setImage:[UIImage imageNamed:gao] ];
                    sender.selected =YES;
                }else{
                    [array replaceObjectAtIndex:j withObject:@"站位"];
                    sender.selected =NO;
                    [(UIImageView*)s  setImage:[UIImage imageNamed:di] ];
                
                }
                
               // NSLog(@"=== --- -%@",array);
            }
            
        }
        
    }
    
}

-(void)hideButtonClick{
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        
        [self removeFromSuperview];
    }];
}


@end
