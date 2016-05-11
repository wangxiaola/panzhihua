//
//  ZKUserInfo.m
//  CYmiangzhu
//
//  Created by 汤亮 on 15/8/26.
//  Copyright (c) 2015年 WangXiaoLa. All rights reserved.
//

#import "ZKUserInfo.h"


@implementation ZKUserInfo

singleton_implementation(ZKUserInfo)

+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"ID" : @"id"};
}

- (void)saveUserInfo
{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:self.ID forKey:@"USER_MESSAGE_ID"];
    NSString *userMessage = [self.userMessage JSONRepresentation];
    [defaults setObject:userMessage forKey:@"USER_MESSAGE"];
    [defaults setObject:self.address forKey:@"userRegion"];
    [defaults setObject:self.mobile forKey:@"userPhone"];
    [defaults setObject:self.photo forKey:@"userPhoto"];
    [defaults setObject:self.truename forKey:@"userTrueName"];
    [defaults setObject:self.name forKey:@"userName"];
    [defaults setObject:self.sex forKey:@"userSex"];
    [defaults setObject:self.email forKey:@"userEmail"];
    [defaults setObject:self.account forKey:@"userAccount"];
    [defaults setObject:self.password forKey:@"userPassword"];
    
    [defaults setBool:self.logined forKey:@"userLogined"];
    [defaults setBool:self.thirdLogin forKey:@"userThirdLogin"];
  
    
    [defaults synchronize];

}

- (void)loadUserInfo
{
    
     NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    self.ID =[defaults objectForKey:@"USER_MESSAGE_ID"];
    NSString *userMessage = [defaults objectForKey:@"USER_MESSAGE"];
    if (userMessage) {
        self.userMessage = [NSJSONSerialization JSONObjectWithData:[userMessage dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
    }
    self.address = [defaults objectForKey:@"userRegion"];
    self.photo = [defaults objectForKey:@"userPhoto"];
    self.mobile = [defaults objectForKey:@"userPhone"];
    self.truename = [defaults objectForKey:@"userTrueName"];
    self.name = [defaults objectForKey:@"userName"];
    self.sex = [defaults objectForKey:@"userSex"];
    self.email = [defaults objectForKey:@"userEmail"];
    self.account = [defaults objectForKey:@"userAccount"];
    self.password = [defaults objectForKey:@"userPassword"];
    
    self.logined = [defaults boolForKey:@"userLogined"];
    self.thirdLogin = [defaults boolForKey:@"userThirdLogin"];

}

- (void)resetUserInfo
{
    self.ID = nil;
    self.address = nil;
    self.photo = nil;
    self.mobile = nil;
    self.truename = nil;
    self.name = nil;
    self.sex = nil;
    self.userMessage = nil;
    self.email = nil;
    self.password = nil;
    
    self.logined = NO;
    self.thirdLogin = NO;

    [self saveUserInfo];
}

@end
