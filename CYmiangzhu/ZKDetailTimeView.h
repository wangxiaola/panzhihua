//
//  ZKDetailTimeView.h
//  CYmiangzhu
//
//  Created by 汤亮 on 16/1/7.
//  Copyright © 2016年 WangXiaoLa. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SelectDateBlock)();

@interface ZKDetailTimeView : UIView
@property (nonatomic, copy) SelectDateBlock selectDateBlock;
@property (nonatomic, copy, readonly) NSString *enterTime;
@property (nonatomic, copy, readonly) NSString *leaveTime;
+ (instancetype)detailTimeView;
- (void)setEnterTime:(NSString *)enterTime leaveTime:(NSString *)leaveTime dayCount:(NSInteger)dayCount;
@end
