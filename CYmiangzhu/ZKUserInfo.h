//
//  ZKUserInfo.h
//  CYmiangzhu
//
//  Created by 汤亮 on 15/8/26.
//  Copyright (c) 2015年 WangXiaoLa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Singleton.h"

@interface ZKUserInfo : NSObject
singleton_interface(ZKUserInfo)

//{
//    errcode = 0,
//    errmsg = SUCCESS,
//    root = {
//        member = {
//            id = 14,
//            truename = <null>,
//            sex = <null>,
//            sfzh = <null>,
//            mobile = 18382116433,
//            dyzh = <null>,
//            type = huiyuan,
//            address = <null>,
//            password = cf9fc62d8172e40100694d85fd9e2df1,
//            username = 18382116433,
//            email = <null>,
//            photo = <null>
//        },
//        success = true
//    }
//}

// id...
@property (nonatomic, copy) NSString *ID;
//用户信息
@property (nonatomic, strong) NSMutableDictionary *userMessage;
//头像...
@property (nonatomic, copy) NSString *photo;
//昵称...
@property (nonatomic, copy) NSString *name;
//姓名...
@property (nonatomic, copy) NSString *truename;
//绑定手机号...
@property (nonatomic, copy) NSString *mobile;
//用户性别 0男 1女...
@property (nonatomic, copy) NSString *sex;
//地区
@property (nonatomic, copy) NSString *address;
//邮箱
@property (nonatomic, copy) NSString *email;
//账户名（手机号或者导游证号）
@property (nonatomic, copy) NSString *account;
//密码
@property (nonatomic, copy) NSString *password;

//以下属性非服务器返回属性
//是否第一次登陆或者注销过
@property (nonatomic, assign, getter=isLogined)BOOL logined;
//是否是第三方登录
@property (nonatomic, assign, getter=isThirdLogin)BOOL thirdLogin;


//保存用户信息到沙盒
- (void)saveUserInfo;
//从沙盒加载用户信息
- (void)loadUserInfo;
//重置(清空)用户信息
- (void)resetUserInfo;
@end
