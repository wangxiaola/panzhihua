//
//  ZKtextFieldThinkView.m
//  CYmiangzhu
//
//  Created by Daqsoft-Mac on 15/7/10.
//  Copyright (c) 2015年 WangXiaoLa. All rights reserved.
//

#import "ZKtextFieldThinkView.h"

#define contentHeight 150

 

@implementation ZKtextFieldThinkView

{

    NSMutableArray *dataArrray;
    
}
-(id)initWithFrame:(CGRect)frame;
{

    self =[super initWithFrame:CGRectMake(frame.origin.x, frame.origin.y+30+64, frame.size.width, contentHeight)];
    if (self) {
        self.backgroundColor =[UIColor clearColor];
        
        dataArrray =[[NSMutableArray alloc]initWithCapacity:0];
        
        _tabel =[[UITableView alloc]initWithFrame:self.bounds];
        _tabel.delegate =self;
        _tabel.dataSource =self;
        _tabel.layer.opacity =0.8;
        // 设置端距，这里表示separator离左边和右边均80像素
        _tabel.separatorInset = UIEdgeInsetsMake(0,5, 0, 5);
        _tabel.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tabel.backgroundColor =[UIColor whiteColor];
        _tabel.showsHorizontalScrollIndicator =NO;
        [self addSubview:_tabel];
    
}
    
    return self;

}


-(void)updata:(NSString*)pc;
{

    [dataArrray addObject:pc];
    
    if (dataArrray.count >5) {
        
        _tabel.frame =self.bounds;
        
    }else{
    
        _tabel.frame =CGRectMake(0, 0, self.frame.size.width, 30*dataArrray.count);
    }
    
    [_tabel reloadData];

}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    return 30;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;

{

    return dataArrray.count;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{

    static NSString*indefer =@"cell";
    
    UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:indefer];
    
    if (!cell) {
        
        cell =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indefer];

    }
    
    if (dataArrray.count>0) {
        
        
        cell.textLabel.textAlignment =NSTextAlignmentCenter;
        cell.textLabel.text =dataArrray[dataArrray.count-indexPath.row-1];
        
    }

    return cell;

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (dataArrray.count>0) {
        
        
        if ([self.delegate respondsToSelector:@selector(indexthink:)]) {
            
            [self.delegate indexthink:dataArrray[dataArrray.count-indexPath.row-1]];
            
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


-(void)show;
{
    self.alpha = 1;
    [[APPDELEGATE window] addSubview:self];
    _tabel.transform = CGAffineTransformMakeScale(0, 0);
    [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        _tabel.transform = CGAffineTransformMakeScale(1.1, 1.1);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            _tabel.transform = CGAffineTransformMakeScale(1, 1);
        } completion:^(BOOL finished) {
            
        }];
    }];
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
