//
//  ZKCityPickerViewController.h
//  CYmiangzhu
//
//  Created by Daqsoft-Mac on 15/10/10.
//  Copyright © 2015年 WangXiaoLa. All rights reserved.
//

#import "ZKSuperViewController.h"
@class ZKCityPickerViewController, ZKCity;


@protocol ZKCityPickerViewControllerDelegate <NSObject>

@optional

- (void)cityPickerViewController:(ZKCityPickerViewController *)cityPickerViewController didSelectedCity:(ZKCity *)city;

@end

@interface ZKCityPickerViewController : ZKSuperViewController
@property (nonatomic, weak) id<ZKCityPickerViewControllerDelegate> delegate;
@end
