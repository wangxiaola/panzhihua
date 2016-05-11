//
//  RequestData.h
//  JSONMessage
//
//  Created by usr on 14-8-16.
//  Copyright (c) 2014年 MIAO L ®. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#define ACCOUNTID @"DDC0DC3EC58AFD729EB7479C879D020205F1031E68E42544"
@interface ZKHttp : NSObject

/**
 *  发送一个POST请求
 *
 *  @param url     请求路径
 *  @param params  请求参数
 *  @param success 请求成功后的回调（请将请求成功后想做的事情写到这个block中）
 *  @param failure 请求失败后的回调（请将请求失败后想做的事情写到这个block中）
 */

+ (void)Post:(NSString *)url params:(NSMutableDictionary *)params success:(void(^)(id responseObj))success failure:(void(^)(NSError *error))failure;

/**
 *  发送一个视频POST请求
 *
 *  @param url     请求路径
 *  @param params  请求参数
 *  @param success 请求成功后的回调（请将请求成功后想做的事情写到这个block中）
 *  @param failure 请求失败后的回调（请将请求失败后想做的事情写到这个block中）
 */
+(void)normalPost:(NSString *)url params:(NSMutableDictionary *)params success:(void (^)(id))success failure:(void (^)(NSError *))failure;

/**
 *  发送一个POST请求--针对景区现状
 *
 *  @param url     请求路径
 *  @param params  请求参数
 *  @param success 请求成功后的回调（请将请求成功后想做的事情写到这个block中）
 *  @param failure 请求失败后的回调（请将请求失败后想做的事情写到这个block中）
 */
+ (void)tlPost:(NSString *)url params:(NSMutableDictionary *)params success:(void (^)(id responseObj))success failure:(void (^)(NSError *error))failure;

/**
 *  发送一个自定义POST请求
 *
 *  @param url     请求路径
 *  @param params  请求参数
 *  @param success 请求成功后的回调（请将请求成功后想做的事情写到这个block中）
 *  @param failure 请求失败后的回调（请将请求失败后想做的事情写到这个block中）
 */

+(void)P_ost:(NSString *)url params:(NSMutableDictionary *)params success:(void(^)(id responseObj))success failure:(void(^)(NSError *error))failure;




/**
 *  视屏上传
 *
 *  @param url      上传地址
 *  @param params   上传参数
 *  @param ty       上传字段
 *  @param plisName 上传文件名
 *  @param Vurl     上传的视屏本地url
 *  @param success  成功返回
 *  @param failure  失败返回
 *  @param lot      进度
 */
+(void)updata:(NSString*)url params:(NSMutableDictionary *)params typey:(NSString*)ty name:(NSString*)plisName vodioUrl:(NSString*)Vurl success:(void(^)(id responseObj))success failure:(void(^)(NSError *error))failure jingdu:(void(^)(float p))lot;


/**
 *  发送uuu一个自定义POST请求
 *
 *  @param url     请求路径
 *  @param params  请求参数
 *  @param success 请求成功后的回调（请将请求成功后想做的事情写到这个block中）
 *  @param failure 请求失败后的回调（请将请求失败后想做的事情写到这个block中）
 */

+(void)Post_data:(NSString *)url params:(NSMutableDictionary *)params success:(void(^)(id responseObj))success failure:(void(^)(NSError *error))failure;

/**
 *  发送一个get请求
 *
 *  @param url     请求路径
 *  @param params  请求参数
 *  @param success 请求成功后的回调（请将请求成功后想做的事情写到这个block中）
 *  @param failure 请求失败后的回调（请将请求失败后想做的事情写到这个block中）
 */
+ (void)get:(NSString*)url
     parama:(NSDictionary*)parama
    succese:(void(^)(id responseObj))success
    failure:(void(^)(NSString * error))failure;

/**
 *  上传图片--唐红梅接口
 *
 *  @param url     请求路径
 *  @param params  请求参数
 *  @param imag    请求imageData
 *  @param success 请求成功后的回调
 *  @param failure 请求失败后的回调
 */
+ (void)PostImage:(NSString *)url params:(NSMutableDictionary *)params Data:(NSData *)imag success:(void(^)(id responseObj))success failure:(void(^)(NSError *error))failure;

/**
 *  上传图片--通用接口
 *
 *  @param url     请求路径
 *  @param params  请求参数
 *  @param imag    请求imageData
 *  @param success 请求成功后的回调
 *  @param failure 请求失败后的回调
 */
+ (void)postImage:(NSString *)url params:(NSMutableDictionary *)params Data:(NSData *)imag success:(void(^)(id responseObj))success failure:(void(^)(NSError *error))failure;
/**
 *  上传游记图片
 *
 *  @param url     请求路径
 *  @param params  请求参数
 *  @param imag    请求imageData
 *  @param success 请求成功后的回调
 *  @param failure 请求失败后的回调
 */
+ (void)youjiPostImage:(NSString *)url params:(NSMutableDictionary *)params Data:(NSData *)imag name:(NSString *)name success:(void(^)(id responseObj))success failure:(void(^)(NSError *error))failure;


/**
 *  发送一个自定义POST请求
 *
 *  @param url     请求路径
 *  @param params  请求参数
 *  @param success 请求成功后的回调（请将请求成功后想做的事情写到这个block中）
 *  @param failure 请求失败后的回调（请将请求失败后想做的事情写到这个block中）
 */

+ (void)post:(NSString *)url params:(NSMutableDictionary *)params success:(void(^)(id responseObj))success failure:(void(^)(NSError *error))failure;

//ios自带的get请求方式

+(void)getddByUrlPath:(NSString *)path
            andParams:(NSString *)params
          andCallBack:(void (^)(id responseObj))callback;


//ios自带的post请求方式

+(void)postddByByUrlPath:(NSString *)path
               andParams:(NSDictionary*)params
             andCallBack:(void (^)(id responseObj))callback;



@end
