//
//  ZKchooseView.m
//  CYmiangzhu
//
//  Created by 王小腊 on 15/12/9.
//  Copyright © 2015年 WangXiaoLa. All rights reserved.
//

#import "ZKchooseView.h"
#import "ZKAppDelegate.h"

@implementation ZKchooseView
{
    UIButton *bty;
    
    NSArray *listData;
    
    NSString * sect_0;
    
    NSString * sect_1;
    
    float ysHeighit;
    
    CGPoint point;
    
    UIView *hideButton;
    
    float height ;
    
    NSMutableArray *floatArray_0;
    
    NSMutableArray *floatArray_1;
    
    float scrollW_0;
    float scrollW_1;
    
    UIScrollView *contVies_0;
    
    UIScrollView *contVies_1;
    
    
    UILabel *chooseLabel_0;
    
    UILabel *chooseLabel_1;
    
}


-(id)initWithFrame:(CGRect)frame titis:(NSArray*)dataArray;
{

   self =  [super initWithFrame:frame];
    
    if (self) {
        
        ysHeighit = frame.size.height;
        
        [self initViewData:dataArray];
        
    }

    return self;
}
/**
 *  初始化
 *
 *  @param list 数据
 */
-(void)initViewData:(NSArray*)list;
{

    sect_0 =@"不限";
    sect_1 =@"不限";
    
    listData =list;
    scrollW_0 = 0;
    scrollW_1 = 0;
    
    if (listData.count ==2) {
        
        height =self.frame.size.height+70;
        
    }else{
        height =self.frame.size.height+35;
    }
    
    UILabel *label =[[UILabel alloc]initWithFrame:CGRectMake(10, 5, 70, self.frame.size.height-10)];
    label.backgroundColor =[UIColor whiteColor];
    label.textAlignment =NSTextAlignmentLeft;
    label.textColor =YJCorl(76, 76, 76);
    label.font =[UIFont systemFontOfSize:14];
    label.text =@"条件选择";
    [self addSubview:label];
    
    chooseLabel_0 =[[UILabel alloc]initWithFrame:CGRectMake(80, 5, 100, self.frame.size.height-10)];
    chooseLabel_0.textAlignment =NSTextAlignmentLeft;
    chooseLabel_0.textColor =CYBColorGreen;
    chooseLabel_0.font =[UIFont systemFontOfSize:14];
    [self addSubview:chooseLabel_0];
    
    chooseLabel_1 =[[UILabel alloc]initWithFrame:CGRectMake(180, 5, 100, self.frame.size.height-10)];
    chooseLabel_1.textAlignment =NSTextAlignmentLeft;
    chooseLabel_1.textColor =[UIColor orangeColor];
    chooseLabel_1.font =[UIFont systemFontOfSize:14];
    [self addSubview:chooseLabel_1];
    
    
    
    bty =[[UIButton alloc]initWithFrame:CGRectMake(kDeviceWidth-40, 0, 40, 40)];
    [bty setImage:[UIImage imageNamed:@"chooesDex"] forState:0];
    [bty addTarget:self action:@selector(ButtonClick:) forControlEvents:UIControlEventTouchUpInside];
//    bty.selected = NO;
    [self addSubview:bty];
    
     floatArray_0 =[NSMutableArray arrayWithCapacity:0];
    
    if (listData.count ==2) {
        
    floatArray_1 =[NSMutableArray arrayWithCapacity:0];
    }
    
     point = self.frame.origin;
    
  
    

    // 加载float
    [self updataFloat];
    
    hideButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    hideButton.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    [[APPDELEGATE window] addSubview:hideButton];
    
    
    for (int i =0; i<listData.count; i++) {
        
        NSArray *titisArray = listData[i];
        
        float jlw = 6;
        
        if (i ==0) {
            
            UILabel *label =[[UILabel alloc]initWithFrame:CGRectMake(10, ysHeighit+5, 70, 25)];
            label.backgroundColor =[UIColor whiteColor];
            label.textAlignment =NSTextAlignmentCenter;
            label.textColor =[UIColor orangeColor];
            label.font =[UIFont systemFontOfSize:14];
            label.text =[[titisArray objectAtIndex:0] valueForKey:@"name"];
            [self addSubview:label];
            
            contVies_0 =[[UIScrollView alloc]initWithFrame:CGRectMake(80, ysHeighit, kDeviceWidth-80, 35)];
            contVies_0.backgroundColor =[UIColor whiteColor];
            contVies_0.pagingEnabled =NO;
            [self addSubview:contVies_0];
            contVies_0.showsHorizontalScrollIndicator = NO;
            
            contVies_0.contentSize = CGSizeMake(scrollW_0+6*titisArray.count , 35);

            for (int j = 1; j<titisArray.count; j++) {
                
                float buttonw = [floatArray_0[j] floatValue];
                
                if (j>1) {
                    
                    jlw =6+[floatArray_0[j-1] floatValue]+jlw;
                }

                NSString *strName =[[titisArray objectAtIndex:j] valueForKey:@"name"];
;
                UIButton *Button =[[UIButton alloc]initWithFrame:CGRectMake(jlw, 0,  buttonw, 35)];
                Button.tag =2000+j;
                [Button addTarget:self action:@selector(lxOneClick:) forControlEvents:UIControlEventTouchUpInside];
                [Button setTitle:strName forState:0];
                
                
                    if ([strName isEqualToString:sect_0]) {
                        
                         [Button setTitleColor:CYBColorGreen forState:0];

                    }else{
                        [Button setTitleColor:YJCorl(76, 76, 76) forState:0];
                    
                    }

                
                [contVies_0 addSubview:Button];
               
                Button.titleLabel.font =[UIFont systemFontOfSize:13];
           
                
            }
            
            
        }else{
            
            UILabel *label =[[UILabel alloc]initWithFrame:CGRectMake(10,ysHeighit+40, 70, 25)];
            label.backgroundColor =[UIColor whiteColor];
            label.textAlignment =NSTextAlignmentCenter;
            label.textColor =[UIColor orangeColor];
            label.font =[UIFont systemFontOfSize:14];
            label.text =[[titisArray objectAtIndex:0] valueForKey:@"name"];
            [self addSubview:label];
            
            contVies_1 =[[UIScrollView alloc]initWithFrame:CGRectMake(80, ysHeighit+35, kDeviceWidth-80, 35)];
            contVies_1.backgroundColor =[UIColor whiteColor];
            contVies_1.pagingEnabled =NO;
            [self addSubview:contVies_1];
            contVies_1.showsHorizontalScrollIndicator = NO;
            contVies_1.contentSize = CGSizeMake(scrollW_1+6*titisArray.count , 35);
            
            for (int j = 1; j<titisArray.count; j++) {
                
                float buttonw = [floatArray_1[j] floatValue];
                
                if (j>1) {
                    
                    jlw =6+[floatArray_1[j-1] floatValue]+jlw;
                }
                
                
                
                NSString *strName = [[titisArray objectAtIndex:j] valueForKey:@"name"];
                
                UIButton *Button =[[UIButton alloc]initWithFrame:CGRectMake(jlw, 0, buttonw, 35)];
                Button.tag =2000+j;
                [Button addTarget:self action:@selector(lxTwoClick:) forControlEvents:UIControlEventTouchUpInside];
                [Button setTitle:strName forState:0];
                

                    
                    if ([strName isEqualToString:sect_1]) {
                        
                        [Button setTitleColor:CYBColorGreen forState:0];
                        
                    }else{
                        [Button setTitleColor:YJCorl(76, 76, 76) forState:0];
                        
                    }
                
            
                Button.titleLabel.font =[UIFont systemFontOfSize:13];
                [contVies_1 addSubview:Button];
                
                
                
                
            }

            
            
            
        }
        
    }
    
    
    
    
    
    
}

#pragma mark 点击事件

-(void)lxTwoClick:(UIButton*)sender
{

    NSInteger pk = sender.tag;
    
    if (sender.tag>2000) {
        
        NSString *str = [[listData[1] objectAtIndex:pk-2000] valueForKey:@"code"];
        self.choose(str,0);
        
        chooseLabel_1.text =sender.titleLabel.text;
         [self supTitisLableFrame];
        
        for (UIView*vies in contVies_1.subviews) {
            
            
            if ([vies isKindOfClass:[UIButton class]]&&vies.tag>1999) {
                

                UIButton *bt =(UIButton*)vies;
                
                if (bt.tag>1999) {
                    
                    if (bt.tag ==pk) {
                        
                        [bt setTitleColor:CYBColorGreen forState:0];
                    }else{
                        
                        
                        [bt setTitleColor:YJCorl(76, 76, 76) forState:0];
                        
                    }
 
                }
                
                
            }
            
            
            
        }

        
    }
    
    [self dismm];
    
}


-(void)lxOneClick:(UIButton*)sender
{
    NSInteger pk = sender.tag;
    
    if (sender.tag >2000) {
        
        NSString *str = [[listData[0] objectAtIndex:pk-2000] valueForKey:@"code"];
        self.choose(str,1);
        
        chooseLabel_0.text =sender.titleLabel.text;
        
        [self supTitisLableFrame];
        
        
        for (UIView*vies in contVies_0.subviews) {
            
            
            if ([vies isKindOfClass:[UIButton class]]&&vies.tag>1999) {
                
                UIButton *bt =(UIButton*)vies;
                
                if (bt.tag>2000) {
                    
                    if (bt.tag ==pk) {
                        
                        [bt setTitleColor:CYBColorGreen forState:0];
                        
                        
                    }else{
                        
                        
                        [bt setTitleColor:YJCorl(76, 76, 76) forState:0];
                        
                    }
                    
                }
                
            }
            
            
            
        }
        
  
       
    }
    
    [self dismm];
    
}



-(void)ButtonClick:(UIButton*)sendet
{
    
    
    if (sendet.selected ==NO) {
        
        [self show];
    }else{
        
        [self dismm];
    }



}

-(void)dismm{


        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationDuration:0.2]; //动画时长
        bty.transform = CGAffineTransformMakeRotation(0 *M_PI / 180.0);
        CGAffineTransform transform = bty.transform;
        //第二个值表示横向放大的倍数，第三个值表示纵向缩小的程度
        transform = CGAffineTransformScale(transform, 1,1);
        bty.transform = transform;
        [UIView commitAnimations];
    
        bty.selected =NO;

        hideButton.frame =CGRectMake(0, 0, 0, 0);
    [UIView animateWithDuration:0.2 animations:^{
        
        hideButton.opaque=NO;
        self.frame =CGRectMake(point.x, point.y, kDeviceWidth, ysHeighit);
        
    }];
    
}
-(void)show{
    
    //顺时针 旋转180度
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.2]; //动画时长
    bty.transform = CGAffineTransformMakeRotation(180*M_PI/180);
    CGAffineTransform transform = bty.transform;
    transform = CGAffineTransformScale(transform, 1,1);
    bty.transform = transform;
    [UIView commitAnimations];

    bty.selected =YES;
    hideButton.frame =CGRectMake(0, 64+height, kDeviceWidth, kDeviceHeight-64-height);
    [UIView animateWithDuration:0.2 animations:^{
        
        self.frame =CGRectMake(point.x, point.y, kDeviceWidth, height);

    }];
    
    
    
}



-(void)chooseKey:(p_dex)name;
{
    self.choose =name;

}

-(void)updataFloat
{
    
    for (int i =0; i<listData.count; i++) {
        
        NSArray *list = listData[i];
        
        if ( i ==0) {
            
            
            for (int i =0; i<list.count; i++) {
                NSDictionary *dic = list[i];
                float px  =[self contentLabelH:[dic valueForKey:@"name"]];
                
                [floatArray_0 addObject:[NSNumber numberWithFloat:px]];
                
                if (i>0) {
                    
                    scrollW_0 = scrollW_0 +px;
                    
                }
               
            }

            
        }else{
        
            for (int i =0; i<list.count; i++) {
                NSDictionary *dic = list[i];
                
                float px =[self contentLabelH:[dic valueForKey:@"name"]];
                [floatArray_1 addObject:[NSNumber numberWithFloat:px]];
                if (i>0) {
                    
                    scrollW_1 = scrollW_1+px;
                }
      
                
            }

        
        
        }
        
    }
  
}


/*
 *  懒加载的方法返回contentLabel的宽度  (只会调用一次)
 */
-(CGFloat)contentLabelH:(NSString*)str
{
    
    CGFloat h=[str boundingRectWithSize:CGSizeMake(MAXFLOAT, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} context:nil].size.width;
        
    h =h+6;  //内容距离底部下划线10的距离

    return h;
}


/**
 *  重新布局lable
 */
-(void)supTitisLableFrame
{

  
    float p1 = [self contentLabelH:chooseLabel_0.text]+10;
    float p2 = [self contentLabelH:chooseLabel_1.text]+10;
    
    chooseLabel_0.frame =CGRectMake(80, 5, p1, 30);
    chooseLabel_1.frame = CGRectMake(80+p1+10,5, p2, 30);
    

}

@end
