//
//  ZKBookRoomCell.h
//  CYmiangzhu
//
//  Created by 汤亮 on 16/1/8.
//  Copyright © 2016年 WangXiaoLa. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZKBookRoomModel;

extern NSString *const ZKBookRoomCellID;

@interface ZKBookRoomCell : UITableViewCell
@property (nonatomic, strong) ZKBookRoomModel *bookRoomModel;
@property (nonatomic, copy) void (^bookRoomBlock)();
@end
