//
//  ZKDetailAddressView.m
//  CYmiangzhu
//
//  Created by 汤亮 on 16/1/7.
//  Copyright © 2016年 WangXiaoLa. All rights reserved.
//

#import "ZKDetailAddressView.h"
#import "ZKscenicSpotList.h"

@interface ZKDetailAddressView()
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;

@end

@implementation ZKDetailAddressView

+ (instancetype)detailAddressView
{
    return [[[NSBundle mainBundle] loadNibNamed:@"ZKDetailAddressView" owner:nil options:nil] firstObject];
}

- (void)setHotelModel:(ZKscenicSpotList *)hotelModel
{
    _hotelModel = hotelModel;
    self.addressLabel.text = hotelModel.address;
    self.distanceLabel.text = hotelModel.distance ? [NSString stringWithFormat:@"距您%@km", hotelModel.distance] : @"未知";
}

- (IBAction)call {
    NSArray *phones= [self.hotelModel.phone componentsSeparatedByString:@","];
    NSString *phone = phones[0];
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",[phone stringByReplacingOccurrencesOfString:@"—" withString:@""]];
    UIWebView * callWebview = [[UIWebView alloc] init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
    [self addSubview:callWebview];
}

- (IBAction)navigationToMap {
    if (self.navigationBlock) {
        self.navigationBlock();
    }
}

@end
