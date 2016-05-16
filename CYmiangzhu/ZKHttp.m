//
//  RequestData.m
//  JSONMessage
//
//  Created by usr on 14-8-16.
//  Copyright (c) 2014年 MIAO L ®. All rights reserved.


#import "ZKHttp.h"

#import "ZKUtil.h"


@implementation ZKHttp


#pragma mark POST

+ (void)post:(NSString *)url params:(NSMutableDictionary *)params success:(void (^)(id))success failure:(void (^)(NSError *))failure
{

    //1.获得请求管理者
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    mgr.responseSerializer =[AFJSONResponseSerializer serializer];

    
         [params setObject:@"AbezdodBhh6a" forKey:@"AppId"];
         [params setObject:@"c528b39514834026bc8763e287f84c22" forKey:@"AppKey"];
    
//    params[@"AppId"] = @"tJOabi6fooB3";
//    params[@"AppKey"] = @"eda608c2-589f-48ef-8c48-d984edcbdc92";
    
    NSLog(@"请求参数 ：\n%@",params);
    
    //2.发送Post请求
    [mgr POST:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObj) {
        if (success) {
            
            success(responseObj);
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            
            failure(error);
            
        }
    }];

}

+(void)youjiPostImage:(NSString *)url params:(NSMutableDictionary *)params Data:(NSData *)imag name:(NSString *)name success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    AFHTTPRequestOperationManager *man =[AFHTTPRequestOperationManager manager];
    man.responseSerializer =[AFHTTPResponseSerializer serializer];
    
    NSLog(@"上传照片---%@ ---%@",url,params);
    
    
    [man POST:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        //添加要上传的文件，此处为图片
        [formData appendPartWithFileData:imag name:name fileName:@"youji.jpeg" mimeType:@"image/jpeg"];
        
        //添加要上传的文件，此处为图片
        // [formData appendPartWithFileData:imageData name:@"服务器放图片的参数名（Key）" fileName:@"图片名字" mimeType:@"文件类型（此处为图片格式，如image/jpeg）"];
        
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        if (success) {
            
            success(responseObject);
            
            
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        
        if (failure) {
            failure(error);
            
        }
        
        
    }];


}

+(void)Post:(NSString *)url params:(NSMutableDictionary *)params success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    
//    NSLog(@"%@", [ZKUtil generateAuthInfo:params]);
    //1.获得请求管理者
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    //2.发送Post请求
    [mgr POST:[NSString stringWithFormat:@"%@%@",postUrlPrefix,url] parameters:[ZKUtil generateAuthInfo:params] success:^(AFHTTPRequestOperation *operation, id responseObj) {
        if (success) {
            
            success(responseObj);
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
       
            failure(error);
            
        }
    }];
}

+(void)normalPost:(NSString *)url params:(NSMutableDictionary *)params success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    
    
//    NSLog(@"请求地址---%@",url);
    //1.获得请求管理者
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    mgr.responseSerializer =[AFHTTPResponseSerializer serializer];
//    mgr.requestSerializer.timeoutInterval = -1;
    //2.发送Post请求
    
    
    [mgr POST:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObj) {
        if (success) {
            
            success(responseObj);
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            
            failure(error);
            
        }
    }];
}

+ (void)tlPost:(NSString *)url params:(NSMutableDictionary *)params success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    //1.获得请求管理者
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    //2.发送Post请求
    
    
    [mgr POST:[NSString stringWithFormat:@"%@%@",postUrlPrefix2,url] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObj) {
        if (success) {
            
            success(responseObj);
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            
            failure(error);
            
        }
    }];

}



+(void)P_ost:(NSString *)url params:(NSMutableDictionary *)params success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    //1.获得请求管理者
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    //2.发送Post请求
    NSString *st =[NSString stringWithFormat:@"http://118.112.180.48:%@",url];
    NSLog(@"请求地址---%@",st);
    
    [mgr POST:st parameters:[ZKUtil generateAuthInfo:params] success:^(AFHTTPRequestOperation *operation, NSDictionary*responseObj) {
        if (success) {
            
            success(responseObj);
            
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(error);
            
        }
    }];
}

+(void)Post_data:(NSString *)url params:(NSMutableDictionary *)params success:(void(^)(id responseObj))success failure:(void(^)(NSError *error))failure;
{
    
    //1.获得请求管理者
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    //2.发送Post请求
    
    [mgr POST:url parameters:params success:^(AFHTTPRequestOperation *operation, NSData*responseObj) {
        if (success) {
            
            success(responseObj);
            
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(error);
            
        }
    }];
    
    
    
}

#pragma mark GET
+(void)get:(NSString *)url parama:(NSDictionary *)parama succese:(void (^)(id))success failure:(void (^)(NSString *))failure
{
    
    //1.获得请求管理者
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    //3.发送Get请求
    [mgr GET:url
 parameters :parama
    success :^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        
        if (success) {
            
            success(responseObject);
            
            
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        if (failure) {
            
            success(error);
        }
        
    }];
    
    
    
}


+ (void)PostImage:(NSString *)url params:(NSMutableDictionary *)params Data:(NSData *)imag success:(void(^)(id responseObj))success failure:(void(^)(NSError *error))failure;
{
    
    AFHTTPRequestOperationManager *man =[AFHTTPRequestOperationManager manager];
    man.responseSerializer =[AFHTTPResponseSerializer serializer];
    
    NSLog(@"上传照片---%@ ---%@",url,params);
    
    
    [man POST:[NSString stringWithFormat:@"%@%@",postUrlPrefix,url] parameters:[ZKUtil generateAuthInfo:params] constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        //添加要上传的文件，此处为图片
        [formData appendPartWithFileData:imag name:@"Filedata" fileName:@"touxiang.jpeg" mimeType:@"image/jpeg"];
        
        //添加要上传的文件，此处为图片
        // [formData appendPartWithFileData:imageData name:@"服务器放图片的参数名（Key）" fileName:@"图片名字" mimeType:@"文件类型（此处为图片格式，如image/jpeg）"];
        
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        if (success) {
            
            success(responseObject);
            
            
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        
        if (failure) {
            failure(error);
            
        }
        
        
    }];
    
    
}


+ (void)postImage:(NSString *)url params:(NSMutableDictionary *)params Data:(NSData *)imag success:(void(^)(id responseObj))success failure:(void(^)(NSError *error))failure;
{

    AFHTTPRequestOperationManager *man =[AFHTTPRequestOperationManager manager];
//    man.responseSerializer =[AFHTTPResponseSerializer serializer];
    
    params[@"AppId"] = @"tJOabi6fooB3";
    params[@"AppKey"] = @"eda608c2-589f-48ef-8c48-d984edcbdc92";
    
     NSLog(@"上传照片---%@ ---%@",url,params);
    
    [man POST:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        //添加要上传的文件，此处为图片
        [formData appendPartWithFileData:imag name:@"Filedata" fileName:@"touxiang.jpeg" mimeType:@"image/jpeg"];
        
        //添加要上传的文件，此处为图片
        // [formData appendPartWithFileData:imageData name:@"服务器放图片的参数名（Key）" fileName:@"图片名字" mimeType:@"文件类型（此处为图片格式，如image/jpeg）"];
        
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        if (success) {
            
            success(responseObject);
            
            
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        
        if (failure) {
            failure(error);
            
        }
        
        
    }];
  
    
}


+(void)updata:(NSString*)url params:(NSMutableDictionary *)params typey:(NSString*)ty name:(NSString*)plisName vodioUrl:(NSString*)Vurl success:(void(^)(id responseObj))success failure:(void(^)(NSError *error))failure jingdu:(void(^)(float p))lot;
{

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFHTTPRequestOperation *operation = [manager POST:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        

        NSURL *pcurl = [NSURL fileURLWithPath:Vurl];
        NSData *videoData = [NSData dataWithContentsOfURL:pcurl];
        [formData appendPartWithFileData:videoData name:plisName fileName:[NSString stringWithFormat:@"%@.mov",ty] mimeType:@"video/quicktime"];
        

    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        
        
        
    }];
    
    [operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        
        NSLog(@"Sent %lld of %lld bytes", totalBytesWritten, totalBytesExpectedToWrite);
        float p =totalBytesExpectedToWrite/totalBytesWritten;
        
        if (lot) {
            
            lot(101-p);
        }

        
    }];
    
    [operation start];
    
   
}

//ios自带的get请求方式
+(void)getddByUrlPath:(NSString *)path andParams:(NSString *)params andCallBack:(void (^)(id))callback{
    
    if (params) {
        [path stringByAppendingString:[NSString stringWithFormat:@"?%@",params]];
    }
    
    NSString*  pathStr = [path  stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"url:%@",pathStr);
    NSURL *url = [NSURL URLWithString:pathStr];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            
            id jsonData = [NSJSONSerialization JSONObjectWithData:data options:0 error:Nil];
            
            if ([jsonData  isKindOfClass:[NSArray  class]]) {
                NSDictionary*  dic = jsonData[0];
                
                callback(dic);
                
                
            }else{
                callback(jsonData);
            }
            
        });
        
        
    }];
    //开始请求
    [task resume];
}
//ios自带的post请求方式
+(void)postddByByUrlPath:(NSString *)path andParams:(NSDictionary*)params andCallBack:(void (^)(id))callback{
    
    NSURL *url = [NSURL URLWithString:path];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    NSError*  error;
    
    if ([NSJSONSerialization isValidJSONObject:params]) {
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:params options:NSJSONWritingPrettyPrinted error:&error];
        [request  setHTTPBody:jsonData];
        
        
        NSURLSession *session = [NSURLSession sharedSession];
        NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
              //  NSString*  str = [[NSString   alloc]initWithData:data encoding:NSUTF8StringEncoding];
                //NSLog(@"..........%@",str);
                id  jsonData = [NSJSONSerialization JSONObjectWithData:data options:0 error:Nil];
                if ([jsonData  isKindOfClass:[NSArray  class]]) {
                    NSDictionary*  dic = jsonData[0];
                    
                    callback(dic);
                    
                    
                }else{
                    callback(jsonData);
                }
            });
            
        }];
        //开始请求
        [task resume];
        
    }
}



@end
