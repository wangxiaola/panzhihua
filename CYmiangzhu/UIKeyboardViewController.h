//
//  UIKeyboardViewController.h
//
//
//  Created by  YFengchen on 13-1-4.
//  Copyright 2013 __zhongyan__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIKeyboardView.h"

#define IOS_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]
@protocol UIKeyboardViewControllerDelegate;

@interface UIKeyboardViewController : NSObject <UITextFieldDelegate, UIKeyboardViewDelegate, UITextViewDelegate> {
	CGRect keyboardBounds;
    UIKeyboardView *keyboardToolbar;
    id <UIKeyboardViewControllerDelegate> boardDelegate;
    UIView *objectView;
}

@property (nonatomic, assign) id <UIKeyboardViewControllerDelegate> boardDelegate;

@end

@interface UIKeyboardViewController (UIKeyboardViewControllerCreation)

- (id)initWithControllerDelegate:(id <UIKeyboardViewControllerDelegate>)delegateObject;

@end

@interface UIKeyboardViewController (UIKeyboardViewControllerAction)

- (void)addToolbarToKeyboard;

@end

@protocol UIKeyboardViewControllerDelegate <NSObject>

@optional

- (void)alttextFieldDidEndEditing:(UITextField *)textField;
- (void)alttextFieldDidChange:(UITextField *)textField;
- (void)textViewDidChange:(UITextView *)textView;

@end
