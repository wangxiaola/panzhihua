//
//  Item.m
//  CustomMKAnnotationView
//
//  Created by JianYe on 14-2-8.
//  Copyright (c) 2014年 Jian-Ye. All rights reserved.
//

#import "Item.h"

@implementation Item


- (id)initWithDictionary:(NSDictionary *)dictionary;
{
    self = [super init];
    if (self) {
        
        self.latitude = [dictionary valueForKey:@"longitude"];
        self.longitude = [dictionary valueForKey:@"latitude"];
        self.title = [dictionary valueForKey:@"name"];
        self.subtitle = [dictionary valueForKey:@"address"];
        self.imageUrl =[dictionary valueForKey:@"logosmall"];
        self.phone =[dictionary valueForKey:@"phone"];
        self.tp =[dictionary valueForKey:@"type"];
        self.name =[dictionary valueForKey:@"name"];

    }
    return self;
}


- (id)initWithDictionary:(NSDictionary *)dictionary anntp:(NSString*)t;
{
 
    self = [super init];
    if (self) {

            self.latitude = [dictionary valueForKey:@"x"];
            self.longitude = [dictionary valueForKey:@"y"];
            self.title = [dictionary valueForKey:@"name"];
            self.subtitle = [dictionary valueForKey:@"address"];
            self.imageUrl =[dictionary valueForKey:@"logosmall"];
            self.phone =[dictionary valueForKey:@"phone"];
            self.tp =t;
            self.name =[dictionary valueForKey:@"name"];
        

        
    }
    return self;
}
@end
