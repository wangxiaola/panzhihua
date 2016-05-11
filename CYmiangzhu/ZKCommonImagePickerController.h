//
//  YYCommonImagePickerController.h
//  mocha
//
//  Created by demo on 13-12-17.
//  Copyright (c) 2013年 yunyao. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ZKCommonImagePickerControllerDelegate<NSObject>
@optional

- (void)PimagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info;
- (void)PimagePickerControllerDidCancel:(UIImagePickerController *)picker;
@end
@interface ZKCommonImagePickerController : UIImagePickerController<UINavigationControllerDelegate,
UIImagePickerControllerDelegate>

@property (nonatomic,assign) id<ZKCommonImagePickerControllerDelegate> imagePickerDelegate;

@end
