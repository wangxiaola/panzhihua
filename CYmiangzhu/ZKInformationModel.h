//
//  ZKInformationModel.h
//  CYmiangzhu
//
//  Created by 汤亮 on 15/12/16.
//  Copyright © 2015年 WangXiaoLa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZKInformationModel : NSObject

//"imgs": "https://mmbiz.qlogo.cn/mmbiz/Pa7XxVhokAIEMQefdpDwVcKib2MKrfC3sTvRoL3atUwUPaMXOTYfFvQkSD0CES9Bu6hgMCIhDaoZ45oEWibbgPdQ/0,https://mmbiz.qlogo.cn/mmbiz/Pa7XxVhokAIEMQefdpDwVcKib2MKrfC3sAAksh9V5FKSglk4ssPr55ysRvr84sEPAv4hujnGPuNkoQWiacybx1Jg/0,sc_pzh2/upload/file/image/201512/161037511o7f.jpg,sc_pzh2/upload/file/image/201512/16103554fu7q.jpg,sc_pzh2/upload/file/image/201512/16103938bo83.jpg",
//"titcont": "在很久以前，你秋裤上岗的时候，攀枝花人民却阳光下沐浴。随着十二月的到来，已经是步入深冬的节奏，你穿着秋裤依然冷成狗，可攀枝花人民依然沐浴着阳光，享受着温泉，你是不是已经感觉到这个世界满满的恶意了？",
//"state": true,
//"url": "news-100282597.do",
//"content": "在很久以前，你秋裤上岗的时候，攀枝花人民却阳光下沐浴。随着十二月的到来，已经是步入深冬的节奏，你穿着秋裤依然冷成狗，可攀枝花人民依然沐浴着阳光，享受着温泉，你是不是已经感觉到这个世界满满的恶意了？",
//"id": 100282597,
//"sortno": 1,
//"author": null,
//"pics": "<img class=\"newsImg\" src=\"https://mmbiz.qlogo.cn/mmbiz/Pa7XxVhokAIEMQefdpDwVcKib2MKrfC3sTvRoL3atUwUPaMXOTYfFvQkSD0CES9Bu6hgMCIhDaoZ45oEWibbgPdQ/0\" /><img class=\"newsImg\" src=\"https://mmbiz.qlogo.cn/mmbiz/Pa7XxVhokAIEMQefdpDwVcKib2MKrfC3sAAksh9V5FKSglk4ssPr55ysRvr84sEPAv4hujnGPuNkoQWiacybx1Jg/0\" /><img class=\"newsImg\" src=\"sc_pzh2/upload/file/image/201512/161037511o7f.jpg\" /><img class=\"newsImg\" src=\"sc_pzh2/upload/file/image/201512/16103554fu7q.jpg\" /><img class=\"newsImg\" src=\"sc_pzh2/upload/file/image/201512/16103938bo83.jpg\" />",
//"cover": "sc_pzh2/upload/file/201512/16105409rztx.jpg",
//"title": "红格温泉，泡出来的是气质！！！",
//"addtime": "2015-12-16",
//"time": "10:54:14",
//"source": null,
//"views": 9,
//"month": "12.16",
//"year": "2015",
//"adddtime": 1450234454000,
//"praise": 0,
//"channel": "新闻资讯"

@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *imgs;
@property (nonatomic, copy) NSString *titcont;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *cover;
@property (nonatomic, copy) NSString *addtime;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *views;
@property (nonatomic, copy) NSString *praise;

@end
