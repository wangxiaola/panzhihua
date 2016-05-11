//
//  ZKGlobalSearchTableViewCell.m
//  CYmiangzhu
//
//  Created by 王小腊 on 16/3/28.
//  Copyright © 2016年 WangXiaoLa. All rights reserved.
//

#import "ZKGlobalSearchTableViewCell.h"
#import "ZKGlobalSearchMode.h"


NSString *const ZKGlobalSearchCellID = @"ZKGlobalSearchCellID";

@implementation ZKGlobalSearchTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setListModel:(ZKGlobalSearchMode *)listModel
{

    [ZKUtil UIimageView:self.fotImage NSSting:[NSString stringWithFormat:@"%@%@", imageUrlPrefix, listModel.logosmall]];
    self.webView.scrollView.bounces = NO;
    self.webView.userInteractionEnabled = NO;
    self.nameLabel.text = listModel.name;
    
    if (strIsEmpty(listModel.summary)) {
        
        [self.webView loadHTMLString:@"暂无简介" baseURL:nil];
    }else{

        NSString *jsString = [NSString stringWithFormat:@"<html> \n"
                              "<head> \n"
                              "<style type=\"text/css\"> \n"
                              "body {font-family: \"%@\"; font-size: %d;}\n"
                              "</style> \n"
                              "</head> \n"
                              "<body>%@</body> \n"
                              "</html>", @"宋体", 12,listModel.summary] ;
        [self.webView loadHTMLString:jsString baseURL:nil];
    
    }


}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
