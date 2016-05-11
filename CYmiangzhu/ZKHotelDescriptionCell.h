//
//  ZKHotelDescriptionCell.h
//  CYmiangzhu
//
//  Created by 汤亮 on 16/1/11.
//  Copyright © 2016年 WangXiaoLa. All rights reserved.
//

#import <UIKit/UIKit.h>
extern NSString *const ZKHotelDescriptionCellID;
@interface ZKHotelDescriptionCell : UITableViewCell
- (void)loadHtmlString:(NSString *)htmlSting;
@end
