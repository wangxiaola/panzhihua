//
//  ZKBookRoomCell.m
//  CYmiangzhu
//
//  Created by 汤亮 on 16/1/8.
//  Copyright © 2016年 WangXiaoLa. All rights reserved.
//

#import "ZKBookRoomCell.h"
#import "ZKBookRoomModel.h"

NSString *const ZKBookRoomCellID = @"ZKBookRoomCellID";

@interface ZKBookRoomCell ()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@end

@implementation ZKBookRoomCell

- (IBAction)bookRoom {
    if (self.bookRoomBlock) {
        self.bookRoomBlock();
    }
}

- (void)setBookRoomModel:(ZKBookRoomModel *)bookRoomModel
{
    _bookRoomModel = bookRoomModel;
    self.nameLabel.text = bookRoomModel.name;
    self.priceLabel.text = [[NSString stringWithFormat:@"%.2f", bookRoomModel.price] stringByReplacingOccurrencesOfString:@".00" withString:@""];
}

@end
