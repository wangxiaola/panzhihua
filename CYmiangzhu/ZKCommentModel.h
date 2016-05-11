//
//  ZKCommentModel.h
//  CYmiangzhu
//
//  Created by 汤亮 on 16/1/7.
//  Copyright © 2016年 WangXiaoLa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZKCommentModel : NSObject
//addtime = 1452145997000;
//content = "\U5f88\U4e0d\U9519\U7684\U9152\U5e97";
//dataid = 100008074;
//dataname = "\U7c73\U6613\U5b89\U5b81\U660e\U73e0\U5927\U9152\U5e97";
//id = 100294440;
//image = "http://oto.tpanzhihua.com:80/apiserver/upload/file/201512/31172623a7l5.jpg";
//name = null;
//photo = "http://oto.tpanzhihua.com:80/apiserver/upload/file/201512/31172623a7l5.jpg";
//score = "5.0";
//state = 2;
//tag = "<null>";
//type = hotel;
@property (nonatomic, copy) NSString *ID; //评论id
@property (nonatomic, assign) double addtime;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *dataid; //被评论的资源id
@property (nonatomic, copy) NSString *image;
@property (nonatomic, copy) NSString *photo;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *score;
@property (nonatomic, copy) NSString *state;
@property (nonatomic, copy) NSString *tag;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *dataname;
@end
