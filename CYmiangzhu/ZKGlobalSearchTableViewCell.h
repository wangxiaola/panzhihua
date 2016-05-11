//
//  ZKGlobalSearchTableViewCell.h
//  CYmiangzhu
//
//  Created by 王小腊 on 16/3/28.
//  Copyright © 2016年 WangXiaoLa. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZKGlobalSearchMode;

extern NSString *const ZKGlobalSearchCellID;

@interface ZKGlobalSearchTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *fotImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIWebView *webView;


@property (nonatomic, strong) ZKGlobalSearchMode *listModel;
@end
