//
//  CustomStarRatingView.m
//  higna
//
//  Created by  on 11-9-5.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#define STAR_IMG_WIDTH 18.0
#define STAR_IMG_HEGHT 27.0
#define STAR_MID_WIDTH 25.0

#import "CustomStarRatingView.h"

@implementation CustomStarRatingView


- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.userInteractionEnabled = NO;
    starNum = 5;
    [self prepareStars:starNum frame:self.frame];
}

-(void)setRating:(CGFloat)aRating{
    rating= aRating;
    [self fillStars];
}

- (void) prepareStars: (int)aStarNum frame: (CGRect)frame {
    starArray = [[NSMutableArray alloc] initWithCapacity:aStarNum];
    CGFloat width = STAR_IMG_WIDTH;
    CGFloat height = STAR_IMG_HEGHT;
    CGFloat edgeMargin = 15;
    CGFloat margin = (frame.size.width - STAR_IMG_WIDTH*aStarNum -edgeMargin *2)/4;
    
    CGFloat imageInitX= 0;
    CGFloat imageInitY=frame.size.height/2-0.5*STAR_IMG_HEGHT;
    for(int i=0; i < aStarNum; i++) {
        imageInitX = edgeMargin + i*(margin + width);
        UIImageView * star = [[UIImageView alloc] initWithFrame:CGRectMake(imageInitX, imageInitY, width, height)];
        [starArray addObject:star];
        [self addSubview:star];
    }
}
- (void)fillStars{    
    UIImage *onImage = [UIImage imageNamed:@"xianzhuang_ren"];
    UIImage *offImage = [UIImage imageNamed:@"xianzhuang_nobody"];
    UIImage *onFullImage = [UIImage imageNamed:@"xianzhuang_manren"];
    int starNumTemp = starNum;
    int ratingTemp = (int)((rating + 0.19999999999999999999999999999999999999999 ) * starNum);
    for (int i=0; i<starNumTemp; i++)    {           
        UIImage *img = (i < ratingTemp) ? (rating < 0.80? onImage : onFullImage) : offImage;
        UIImageView *star = (UIImageView *)[starArray objectAtIndex:i]; 
        [star setImage:img];
    }
} 

- (void)touchUpdateStar:(CGPoint) pt {    
    int starNumTemp = starNum;
    for(int i=0; i<starNumTemp; i++) 
    {
        UIImageView *star = (UIImageView *)[starArray objectAtIndex:i];
        if (pt.x>=star.frame.origin.x && pt.x<=star.frame.origin.x+star.frame.size.width && pt.y>=star.frame.origin.y && pt.y <= star.frame.origin.y+star.frame.size.height) {
            [self setRating:(i+1)];
        }
        
    }
    
} 


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	CGPoint pt = [[touches anyObject] locationInView:self];
	[self touchUpdateStar:pt];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
	CGPoint pt = [[touches anyObject] locationInView:self];
	[self touchUpdateStar:pt];
}

@end
