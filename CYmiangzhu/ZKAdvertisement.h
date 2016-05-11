//
//  ZKAdvertisement.h
//  CYmiangzhu
//
//  Created by 汤亮 on 15/10/21.
//  Copyright © 2015年 WangXiaoLa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZKAdvertisement : NSObject


//{"id":12718,"name":"中国攀枝花旅游资讯网","complaintPhone":null,"adAddress":null,"topimages":"sc_pzh2/upload/file/201510/21155638b3zv.png","indexImages":"sc_pzh2/upload/file/201510/211556461pg7.png"}
@property (copy, nonatomic) NSString *ID;
//广告名称
@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *complaintPhone;
//跳转页面地址
@property (copy, nonatomic) NSString *adAddress;
//小图
@property (copy, nonatomic) NSString *topimages;
//大图
@property (copy, nonatomic) NSString *indexImages;
@end
