//
//  ZKCityGroup.h
//  CYmiangzhu
//
//  Created by Daqsoft-Mac on 15/10/10.
//  Copyright © 2015年 WangXiaoLa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZKCityGroup : NSObject
/** 这组的标题 */
@property (nonatomic, copy) NSString *sort;
/** 这组的所有城市 */
@property (nonatomic, strong) NSArray *cities;
@end
