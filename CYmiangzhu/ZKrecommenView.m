//
//  ZKrecommenView.m
//  CYmiangzhu
//
//  Created by Daqsoft-Mac on 15/8/12.
//  Copyright (c) 2015年 WangXiaoLa. All rights reserved.
//

#import "ZKrecommenView.h"

@implementation ZKrecommenView

{

    UIImageView *backImage;
    
    UILabel *nameLabel;

}
-(id)initWithFrame:(CGRect)frame
{
    self =[super initWithFrame:frame];
    
    if (self) {
        
      
        self.backgroundColor =[UIColor whiteColor];
        backImage=[[UIImageView alloc]initWithFrame:CGRectMake(8, 8, self.frame.size.width-16, self.frame.size.height-8-50)];
        [self addSubview:backImage];
        
        nameLabel =[[UILabel alloc]initWithFrame:CGRectMake(10, self.frame.size.height-45, self.frame.size.width-20, 35)];
        nameLabel.textAlignment =NSTextAlignmentCenter;
        nameLabel.font =[UIFont systemFontOfSize:14];
        nameLabel.textColor =[UIColor grayColor];
        nameLabel.numberOfLines =2;
        [self addSubview:nameLabel];
        
        
        self.layer.borderColor =[UIColor grayColor].CGColor;
        self.layer.borderWidth =0.4;
        
        
    }
    return self;
}

-(void)updata:(ZKrecommenMode*)list;
{

    [ZKUtil UIimageView:backImage NSSting:list.logosmall duImage:@"recommen_backImage.jpg"];
    nameLabel.text =list.name;

}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
