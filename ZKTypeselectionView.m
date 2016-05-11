//
//  DQNavSelectView.m
//  changyouyibin
//
//  Created by Daqsoft-Mac on 15/2/9.
//  Copyright (c) 2015年 WangXiaoLa. All rights reserved.
//

#import "ZKTypeselectionView.h"

@implementation ZKTypeselectionView
{
    
    UIImageView *lefView;
    
    UILabel *name;
    
    UIButton *button;
    
    UIView *bennView;
    
    
    
}
-(id)initWithFrame:(CGRect)frame data:(NSArray*)list;
{
    self =[super initWithFrame:frame];
    if (self) {
        
        
        float gapWidth =self.frame.size.width/list.count;
        self.backgroundColor =[UIColor whiteColor];
        
        bennView =[[UIView alloc]initWithFrame:self.bounds];
        [self addSubview:bennView];
        
        for (int i=0; i<list.count; i++) {
            
          
            
            name =[[UILabel alloc]initWithFrame:CGRectMake(gapWidth*i+8, 0, gapWidth, self.frame.size.height)];
            name.backgroundColor =[UIColor clearColor];
            name.textColor =[UIColor blackColor];
            name.textAlignment =NSTextAlignmentCenter;
            name.tag =i+2000;
            name.font =[UIFont systemFontOfSize:12];
            name.font =[UIFont boldSystemFontOfSize:12];
            name.text =list [i];
            [self addSubview:name];
            
            
            lefView =[[UIImageView alloc]initWithFrame:CGRectMake(name.frame.origin.x+gapWidth/2-35, 14, 16, 16)];
            lefView.backgroundColor =[UIColor clearColor];
            lefView.tag =i+1000;
            lefView.image =[UIImage imageNamed:@"check"];
            [bennView addSubview:lefView];
            
            button =[[UIButton alloc]initWithFrame:CGRectMake(gapWidth*i, 0, gapWidth, self.frame.size.height)];
            button.backgroundColor =[UIColor clearColor];
            button.tag =i+3000;
            button.selected =NO;
            [button addTarget:self action:@selector(SelectButton:) forControlEvents:UIControlEventTouchUpInside];
            
            [bennView addSubview:button];
        }
        
        
    }
    
    return self;
}


-(void)SelectButton:(UIButton*)sender
{
    NSInteger p =sender.tag -3000;
    
    for (UIImageView*vs in bennView.subviews) {
        
        
        if ([vs isKindOfClass:[UIImageView class]]&&vs.tag ==1000+p) {
            
            if (sender.selected ==NO) {
                
                vs.image =[UIImage imageNamed:@"checked"];
                sender.selected =YES;
                
                if ([self.delegate respondsToSelector:@selector(pAdd:)]) {
                    
                    [self.delegate pAdd:p];
                }
    
                
            }else{
                
                
                vs.image =[UIImage imageNamed:@"check"];
                sender.selected =NO;
                
                if ([self.delegate respondsToSelector:@selector(pCancel:)]) {
                    
                    [self.delegate pCancel:p];
                }
                
                
            }
            
            
            
        }
    }
    
    
    
}


-(void)showHeg;
{
    
    for (UIView*vc in bennView.subviews) {
        
        if ([vc isKindOfClass:[UIButton class]]) {
            
            
            [(UIButton*)vc setSelected:YES];
            
            
            
        }
        
        else if ([vc isKindOfClass:[UIImageView class]])
            
        {
            
            [(UIImageView*)vc  setImage:[UIImage imageNamed:@"checked"]];
            
            
        }
        
        
    }
    
    
    
}

-(void)dismHeg;
{
    
    for (UIView*vc in bennView.subviews) {
        
        if ([vc isKindOfClass:[UIButton class]]) {
            
            
            [(UIButton*)vc setSelected:NO];
            
            
            
        }
        
        else if ([vc isKindOfClass:[UIImageView class]])
            
        {
            
            [(UIImageView*)vc  setImage:[UIImage imageNamed:@"check"]];
            
            
        }
        
        
    }
    
    
    
}
/**
 *  加载数据
 *
 *  @param selec 第几个
 */
-(void)updata:(NSInteger)selec
{

    if (selec>5) {
        
        return;
    }
    
    for (UIView*vc in bennView.subviews) {
        
        if ([vc isKindOfClass:[UIButton class]]&&vc.tag ==3000+selec) {
            
            
            [(UIButton*)vc setSelected:YES];
            
            
            
        }
        
        else if ([vc isKindOfClass:[UIImageView class]]&&vc.tag ==1000+selec)
            
        {
            
            [(UIImageView*)vc  setImage:[UIImage imageNamed:@"checked"]];
            
            
        }
        
        
    }
    
    
}


/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
