//
//  ZKfeileiList.m
//  CYmiangzhu
//
//  Created by Daqsoft-Mac on 15/8/13.
//  Copyright (c) 2015年 WangXiaoLa. All rights reserved.
//

#import "ZKfeileiList.h"

@implementation ZKfeileiList

-(id)initNSdict:(NSDictionary*)list;
{
    self =[super init];
    
    if (self) {
        
        self.name =@"实验。哈哈哈";
        self.infor =@"我哦我我问1OK说下哦";
        self.index =[[list valueForKey:@"index"] integerValue];
        
    }
    
    return self;
    

}

@end
