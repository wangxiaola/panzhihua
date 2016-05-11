//
//  ZKDetailCommentView.h
//  CYmiangzhu
//
//  Created by 汤亮 on 16/1/8.
//  Copyright © 2016年 WangXiaoLa. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZKscenicSpotList;

typedef void(^CommentBlock)();

@interface ZKDetailCommentView : UIView
@property (nonatomic, strong) ZKscenicSpotList *hotelModel;
@property (nonatomic, copy) CommentBlock commentBlock;
+ (instancetype)detailCommentView;
@end
