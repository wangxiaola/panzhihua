//
//  ZKDetailAddressView.h
//  CYmiangzhu
//
//  Created by 汤亮 on 16/1/7.
//  Copyright © 2016年 WangXiaoLa. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZKscenicSpotList;
typedef void(^NavigationBlock)();

@interface ZKDetailAddressView : UIView
@property (nonatomic, strong) ZKscenicSpotList *hotelModel;
@property (nonatomic, copy) NavigationBlock navigationBlock;
+ (instancetype)detailAddressView;
@end
