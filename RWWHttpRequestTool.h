//
//  RWWHttpRequestTool.h
//  upData
//
//  Created by 任文武 on 15/7/2.
//  Copyright (c) 2015年 RWW. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
@interface RWWHttpRequestTool : NSObject
//请求数据
+(void)PostRequestWithUrl:(NSString *)url prama:(NSDictionary *)dic success:(void(^)(id response))success fail:(void(^)(id response))fail;
//上传相册
+(void)upLoadImageWithUrl:(NSString *)url prama:(NSDictionary *)dic image:(id)image success:(void(^)(id reponse))success fail:(void(^)(id response))fail;
//网络监测
/**检测网路状态**/
+ (void)netWorkStatus;
/**
 *JSON方式获取数据
 *urlStr:获取数据的url地址
 *
 */
+ (void)JSONDataWithUrl:(NSString *)url success:(void (^)(id json))success fail:(void (^)())fail;
/**
 *xml方式获取数据
 *urlStr:获取数据的url地址
 *
 */
+ (void)XMLDataWithUrl:(NSString *)urlStr success:(void (^)(id xml))success fail:(void (^)())fail;
/**
 *Session下载文件
 *urlStr :   下载文件的url地址
 *
 */
+ (void)sessionDownloadWithUrl:(NSString *)urlStr success:(void (^)(NSURL *fileURL))success fail:(void (^)())fail;
/**
 *文件上传,自己定义文件名
 *urlStr:    需要上传的服务器url
 *fileURL:   需要上传的本地文件URL
 *fileName:  文件在服务器上以什么名字保存
 *fileTye:   文件类型
 *
 */
+ (void)postUploadWithUrl:(NSString *)urlStr fileUrl:(NSURL *)fileURL fileName:(NSString *)fileName fileType:(NSString *)fileTye success:(void (^)(id responseObject))success fail:(void (^)())fail;
/**
 *文件上传,文件名由服务器端决定
 *urlStr:    需要上传的服务器url
 *fileURL:   需要上传的本地文件URL
 *
 */
+ (void)postUploadWithUrl:(NSString *)urlStr fileUrl:(NSURL *)fileURL success:(void (^)(id responseObject))success fail:(void (^)())fail;
@end
