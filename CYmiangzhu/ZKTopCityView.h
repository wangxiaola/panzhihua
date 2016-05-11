//
//  ZKTopCityView.h
//  CYmiangzhu
//
//  Created by Daqsoft-Mac on 15/10/10.
//  Copyright © 2015年 WangXiaoLa. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZKCityGroup;
@class ZKTopCityView;

@protocol ZKTopCityViewDelegate <NSObject>

@optional

- (void)topCityView:(ZKTopCityView *)topCityView didSelectedCity:(NSString *)city;

@end

@interface ZKTopCityView : UIView
@property (nonatomic, strong) ZKCityGroup *cityGroup;
@property (nonatomic, weak) id<ZKTopCityViewDelegate> delegate;
@end
