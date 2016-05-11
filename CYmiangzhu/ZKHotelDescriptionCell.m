//
//  ZKHotelDescriptionCell.m
//  CYmiangzhu
//
//  Created by 汤亮 on 16/1/11.
//  Copyright © 2016年 WangXiaoLa. All rights reserved.
//

#import "ZKHotelDescriptionCell.h"
NSString *const ZKHotelDescriptionCellID = @"ZKHotelDescriptionCellID";

@interface ZKHotelDescriptionCell ()
@property (weak, nonatomic) IBOutlet UILabel *htmlLabel;

@end

@implementation ZKHotelDescriptionCell

- (void)loadHtmlString:(NSString *)htmlSting
{
    if (htmlSting) {
        self.htmlLabel.attributedText = [[NSAttributedString alloc] initWithData:[htmlSting dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType} documentAttributes:nil error:nil];
    }
}
@end
