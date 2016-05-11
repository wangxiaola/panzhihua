//
//  CustomStarRatingView.h
//  higna
//
//  Created by  on 11-9-5.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomStarRatingView: UIView {
    NSMutableArray            *starArray;
    int                     starNum;
    CGFloat                     rating;
}
-(void)setRating:(CGFloat)aRating;
@end