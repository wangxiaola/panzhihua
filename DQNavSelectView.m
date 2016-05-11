//
//  DQNavSelectView.m
//  changyouyibin
//
//  Created by Daqsoft-Mac on 15/2/9.
//  Copyright (c) 2015年 WangXiaoLa. All rights reserved.
//

#import "DQNavSelectView.h"

@implementation DQNavSelectView
{
    
    UIImageView *lefView;
    
    UILabel *name;
    
    UIButton *button;
    
    UIView *bennView;

    NSString *gaoliang;
    
    NSString *diliang;
    
    
}
-(id)initWithFrame:(CGRect)frame;
{
    self =[super initWithFrame:frame];
    if (self) {

        
        float gapWidth =self.frame.size.width/5;
        self.backgroundColor =[UIColor whiteColor];
        
        bennView =[[UIView alloc]initWithFrame:self.bounds];
        [self addSubview:bennView];
        
        gaoliang =@"map_select_0";
        diliang =@"map_select_1";
        
        NSArray *titis =@[@"景点",@"美食",@"酒店",@"购物",@"游玩"];
    
        for (int i=0; i<5; i++) {
            
            lefView =[[UIImageView alloc]initWithFrame:CGRectMake(8+gapWidth*i, 14, 16, 16)];
            lefView.backgroundColor =[UIColor clearColor];
            lefView.tag =i+1000;
            lefView.image =[UIImage imageNamed:diliang];
            [bennView addSubview:lefView];
            
            name =[[UILabel alloc]initWithFrame:CGRectMake(gapWidth*i+8, 0, gapWidth, self.frame.size.height)];
            name.backgroundColor =[UIColor clearColor];
            name.textColor =[UIColor blackColor];
            name.textAlignment =NSTextAlignmentCenter;
            name.tag =i+2000;
            name.font =[UIFont systemFontOfSize:12];
            name.font =[UIFont boldSystemFontOfSize:12];
            name.text =titis [i];
            [self addSubview:name];
            
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
                
                vs.image =[UIImage imageNamed:gaoliang];
                sender.selected =YES;
                
                if ([self.delegate respondsToSelector:@selector(pAdd:) ]) {
                    
                    [self.delegate pAdd:p];
                }
                
            }else{
                
                
                vs.image =[UIImage imageNamed:diliang];
                sender.selected =NO;
                
                if ([self.delegate respondsToSelector:@selector(pCancel:) ]) {
                    
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
            
            [(UIImageView*)vc  setImage:[UIImage imageNamed:gaoliang]];
            
            
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
            
            [(UIImageView*)vc  setImage:[UIImage imageNamed:diliang]];
            
            
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
            
             [(UIImageView*)vc  setImage:[UIImage imageNamed:gaoliang]];
            
            
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
