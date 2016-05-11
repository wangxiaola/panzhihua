//
//  ZKFootprintModel.h
//  CYmiangzhu
//
//  Created by 汤亮 on 15/12/17.
//  Copyright © 2015年 WangXiaoLa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZKFootprintModel : NSObject

//{"id":100283274,"name":"Erfr4e3rge","img":"sc_pzh2/upload/file/201512/17170938ss4l.jpeg","date":1450281600000}

@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *img;
@property (nonatomic, assign) double date;

@property (nonatomic, assign, getter=isEditing) BOOL editing;
@end
