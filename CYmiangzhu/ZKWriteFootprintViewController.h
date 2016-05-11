//
//  ZKWriteFootprintViewController.h
//  CYmiangzhu
//
//  Created by 汤亮 on 15/12/17.
//  Copyright © 2015年 WangXiaoLa. All rights reserved.
//

#import "ZKSuperViewController.h"
@class ZKFootprintModel;

@interface ZKWriteFootprintViewController : ZKSuperViewController
@property (nonatomic, copy) void (^succeedUploadCallback)();
@property (nonatomic, strong) ZKFootprintModel *footprintModel;
@end
