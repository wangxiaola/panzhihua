//
//  ZKBookRoomModel.h
//  CYmiangzhu
//
//  Created by 汤亮 on 16/1/7.
//  Copyright © 2016年 WangXiaoLa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZKBookRoomModel : NSObject
//{
//    code = ANMZDJD004;
//    content = "";
//    extmap =                 {
//        focusimage =                     (
//                                          {
//                                              filepath = "upload/focus/201511/23161120jgt5.jpg";
//                                          }
//                                          );
//        hoteltype = "";
//        isfirst = 0;
//        repairprice = "";
//    };
//    hasvalidity = 0;
//    id = 196;
//    name = "\U5b89\U5b81\U660e\U73e0\U5927\U9152\U5e97-\U8c6a\U534e\U6807\U95f4";
//    price = 418;
//    summary = "\U5165\U4f4f\U524d\U8bf7\U63d0\U524d\U4e0e\U9152\U5e97\U8054\U7cfb";
//    updatetime = 1452087388000;
//    validedate = "2016-10-19";
//    validsdate = "2015-11-23";
//}

@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *code;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, strong) NSDictionary *extmap;
@property (nonatomic, assign) BOOL hasvalidity;
@property (nonatomic, assign) double price;
@property (nonatomic, copy) NSString *summary;
@property (nonatomic, assign) double updatetime;
@property (nonatomic, copy) NSString *validedate;
@property (nonatomic, copy) NSString *validsdate;
@end
