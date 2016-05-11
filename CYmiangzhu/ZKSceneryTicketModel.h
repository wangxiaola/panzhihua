//
//  ZKSceneryTicketModel.h
//  CYmiangzhu
//
//  Created by 汤亮 on 15/12/9.
//  Copyright © 2015年 WangXiaoLa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZKSceneryTicketModel : NSObject

//"tags": "热门",
//"phone": "08128781004/08128781064",
//"resourcelevelName": "其他",
//"exponent": 4,
//"collection": 0,
//"resourcelevel": "viewType_38",
//"info": "红格村——位于四川省攀枝花(微博)市盐边县，风景优美，以温泉出名。（备注：景区无门票，温泉需购票）",
//"id": 100007994,
//"pics": [],
//"commentcount": 0,
//"price": null,
//"address": "四川省攀枝花市盐边县红格镇红格街332号",
//"logosmall": "sc_pzh/upload/file/201410/14190043wl1y.jpg",
//"views": 99,
//"name": "红格温泉度假区",
//"path": null,
//"maxBearing": 0,
//"praise": null,
//"sharecount": 0,
//"y": 26.516499304090182,
//"x": 101.92270745919552
@property (nonatomic, copy) NSString *ID;
@property (nonatomic, strong) NSArray *pics;
@property (nonatomic, copy) NSString *logosmall;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *collection;
@property (nonatomic, copy) NSString *sharecount;
@property (nonatomic, copy) NSString *commentcount;
@property (nonatomic, copy) NSString *price;

@end
