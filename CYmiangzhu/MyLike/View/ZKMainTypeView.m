//
//  ZKMainTypeView.m
//  CYmiangzhu
//
//  Created by 王小腊 on 15/12/11.
//  Copyright © 2015年 WangXiaoLa. All rights reserved.
//

#import "ZKMainTypeView.h"

#define selectFont [UIFont boldSystemFontOfSize:12]
#define normalFont [UIFont systemFontOfSize:12]

@implementation ZKMainTypeView
{
    UIView *selectView;
    NSInteger itemCount;
    
    NSArray *array;
}

-(id)initFrame:(CGRect)frame filters:(NSArray *)filters
{
    self = [super initWithFrame:frame];
    if (self) {
        array =filters;
        self.backgroundColor = [UIColor whiteColor];
        itemCount = filters.count;
        selectView = [[UIView alloc] initWithFrame:CGRectMake(0, frame.size.height-3, self.frame.size.width/itemCount, 3)];
        selectView.backgroundColor =CYBColorGreen;
         [self addSubview:selectView];
        float jiange =frame.size.width/filters.count;
        for (NSInteger i=0; i<filters.count; i++) {
            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(jiange*i, 3, jiange, frame.size.height-3)];
            [button setTitle:[filters objectAtIndex:i] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [button setTitleColor: CYBColorGreen forState:UIControlStateSelected];
           
            if (i>0) {
                
                UIView *lin =[[ UIView alloc]initWithFrame:CGRectMake(jiange*i, 10, 1, frame.size.height-20)];
                lin.backgroundColor =TabelBackCorl;
                [self addSubview:lin];
            }
            
            if (i == 0) {
                button.selected = YES;
                button.titleLabel.font = selectFont;
            }else{
                button.titleLabel.font = normalFont;
            }
            button.tag = i;
            [button addTarget:self action:@selector(selectTypeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:button];
        }
    }
    return self;
}

-(void)select:(UIButton *)b{
    for (UIView *v in b.superview.subviews) {
        if ([v isKindOfClass:[UIButton class]]) {
            [(UIButton *)v setSelected:NO];
            [(UIButton *)v titleLabel].font = normalFont;
        }
    }
    b.selected = YES;
    b.titleLabel.font = selectFont;
}

-(void)selectTypeButtonClick:(UIButton *)b{
    [self select:b];
    CGRect frame = selectView.frame;
    frame.origin.x = self.frame.size.width/itemCount*b.tag;
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        selectView.frame = frame;
    } completion:^(BOOL finished) {
        
    }];
    if ([self.delegate respondsToSelector:@selector(selectTypeIndex:)]) {
        [self.delegate selectTypeIndex:b.tag];
    }
}

-(void)selectToIndex:(NSInteger)index{
    UIButton *button;
    for (UIView *v in self.subviews) {
        if ([v isKindOfClass:[UIButton class]] && v.tag == index) {
            button = (UIButton *)v;
            break;
        }
    }
    
    CGRect frame = selectView.frame;
    frame.origin.x = index*self.frame.size.width/[array count];
    [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        selectView.frame = frame;
    } completion:^(BOOL finished) {
        
    }];
    
    [self select:button];
}



@end
