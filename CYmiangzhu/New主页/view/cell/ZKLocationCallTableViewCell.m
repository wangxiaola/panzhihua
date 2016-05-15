//
//  ZKLocationCallTableViewCell.m
//  CYmiangzhu
//
//  Created by 小腊 on 16/5/15.
//  Copyright © 2016年 WangXiaoLa. All rights reserved.
//

#import "ZKLocationCallTableViewCell.h"
NSString *const ZKLocationCallCellID =@"ZKLocationCallCellID";

@implementation ZKLocationCallTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (IBAction)adderButton:(id)sender {
}
- (IBAction)callButton:(id)sender {
    
//    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",[phone stringByReplacingOccurrencesOfString:@"—" withString:@""]];
//    UIWebView * callWebview = [[UIWebView alloc] init];
//    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
//    [self addSubview:callWebview];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
