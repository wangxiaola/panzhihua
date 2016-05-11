//
//  MONActivityIndicatorView.h
//
//  Created by Mounir Ybanez on 4/24/14.
//

#import <UIKit/UIKit.h>

@protocol MONActivityIndicatorViewDelegate;

@interface MONActivityIndicatorView : UIView

/** 圈的数量指标. */
@property (readwrite, nonatomic) NSUInteger numberOfCircles;

/** 圈之间的间距. */
@property (readwrite, nonatomic) CGFloat internalSpacing;

/** 每个圆的半径. */
@property (readwrite, nonatomic) CGFloat radius;

/** 每个循环的基本动画延迟. */
@property (readwrite, nonatomic) CGFloat delay;

/** 每个循环的基本动画持续时间*/
@property (readwrite, nonatomic) CGFloat duration;

/** 指定的代表 */
@property (weak, nonatomic) id<MONActivityIndicatorViewDelegate> delegate;


/**
 Starts the animation of the activity indicator.
 */
- (void)startAnimating;

/**
 Stops the animation of the acitivity indciator.
 */
- (void)stopAnimating;

@end

@protocol MONActivityIndicatorViewDelegate <NSObject>

@optional

/**
 Gets the user-defined background color for a particular circle.
 @param activityIndicatorView The activityIndicatorView owning the circle.
 @param index The index of a particular circle.
 @return The background color of a particular circle.
 */
- (UIColor *)activityIndicatorView:(MONActivityIndicatorView *)activityIndicatorView
      circleBackgroundColorAtIndex:(NSUInteger)index;

@end
