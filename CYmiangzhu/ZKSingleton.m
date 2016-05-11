//
//  Singleton.m
//  socket_tutorial
//
//  Created by xiaoliangwang on 14-7-4.
//  Copyright (c) 2014年 芳仔小脚印. All rights reserved.
//

#import "ZKSingleton.h"

#import <sys/socket.h>

#import <netinet/in.h>

#import <arpa/inet.h>

#import <unistd.h>

@implementation ZKSingleton

+(ZKSingleton *) sharedInstance
{
    
    static ZKSingleton *sharedInstace = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        sharedInstace = [[self alloc] init];
    });
    
    return sharedInstace;
}
// socket连接
-(void)socketConnectHost{
    self.socket    = [[AsyncSocket alloc] initWithDelegate:self];
    
    NSError *error = nil;
   
    [self.socket connectToHost:self.socketHost onPort:self.socketPort withTimeout:3 error:&error];

}
// 连接成功回调
#pragma mark  - 连接成功回调
-(void)onSocket:(AsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port
{
    NSLog(@"\n\n\n\n\n\\nsocket连接成功\n\n\n\n");
    self.connectTimer = [NSTimer scheduledTimerWithTimeInterval:30 target:self selector:@selector(longConnectToSocket) userInfo:nil repeats:YES];
    [self.connectTimer fire];
    
    
}
// 心跳连接
-(void)longConnectToSocket{


     NSData *data = [NSJSONSerialization dataWithJSONObject:self.dicc options:NSJSONWritingPrettyPrinted error:nil];
   
    [self.socket writeData:data withTimeout:1 tag:0];

    
}
// 切断socket
-(void)cutOffSocket{
    
    self.socket.userData = SocketOfflineByUser;
    
    [self.connectTimer invalidate];
    
    [self.socket disconnect];
}
-(void)onSocketDidDisconnect:(AsyncSocket *)sock
{
    NSLog(@"sorry the connect is failure %ld",sock.userData);
    
    if (sock.userData == SocketOfflineByServer) {
        // 服务器掉线，重连
        [self socketConnectHost];
    }
    else if (sock.userData == SocketOfflineByUser) {
        // 如果由用户断开，不进行重连
        return;
    }
    
}

-(void)mess:(p_dic)p;
{

    self.k =p;
    //p =self.k;
}
-(void)onSocket:(AsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    // 对得到的data值进行解析与转换即可
    
    NSString *jsonObject=[NSJSONSerialization
                               JSONObjectWithData:data
                              options:NSJSONReadingMutableLeaves
                              error:nil];
    self.k(jsonObject);
   
    
    
    [self.socket readDataWithTimeout:-1 tag:0];
    
}



@end
