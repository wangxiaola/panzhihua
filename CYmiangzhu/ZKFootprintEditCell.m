//
//  ZKFootprintEditCell.m
//  CYmiangzhu
//
//  Created by 汤亮 on 15/12/21.
//  Copyright © 2015年 WangXiaoLa. All rights reserved.
//

#import "ZKFootprintEditCell.h"

NSString *const ZKFootprintEditCellID = @"ZKFootprintEditCellID";

@implementation ZKFootprintEditCell

- (IBAction)modifyFootprint {
    if (self.editFootprintCallback) {
        self.editFootprintCallback(ZKEditOperationModify);
    }
}

- (IBAction)deleteFootprint {
    if (self.editFootprintCallback) {
        self.editFootprintCallback(ZKEditOperationDelete);
    }
}

@end
