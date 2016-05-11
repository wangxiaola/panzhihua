//
//  DQUtil.h
//  ChangYouYiBin
//
//  Created by Daqsoft-Mac on 14/11/24.
//  Copyright (c) 2014年 StrongCoder. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#define navBarHeight 44
#define tabBarHeight 49
#define statusBarHeight 20
#define strIsEmpty(str) ([str isKindOfClass:[NSNull class]] || str == nil || [str length]<1 ? YES : NO )

@interface ZKUtil : NSObject

/**
 * 字符转字典
 *
 *  @param str 字符
 *
 *  @return 字典
 */
+(NSDictionary*)responseObject:(id)str;

//返回图片网址数组
+(id)imageUrlsD:(NSString*)urls;
//返回图片网址数组
+(id)imageUrls:(NSString*)urls;
//是否有地址
+(BOOL)FetchImage:(NSString*)path;
//取出图片
+(UIImage*)fetchImage:(NSString*)path;
//保存图片
+(BOOL)setPhotoToPath:(NSData*)image isName:(NSString *)name;
/**
 * 删除文件
 *
 *  @filePath 文件路径
 *
 *  @bool 返回的值
 */
+(BOOL)filePath:(NSString*)path;

+(NSString*)FilePath:(NSString*)path;
//取bool变量
+(BOOL)MyboolForKey:(NSString *)defaultName;
//存bool变量
+(void)MyboolForKey:(NSString *)defaultName setBool:(BOOL)value;
/**
 *  NSUserDefaults取值
 *
 *  @sK 要取的key
 *
 *  @id 返回的值
 */
+(NSString*)ToTakeTheKey:(NSString*)sK;
/**
 *  NSUserDefaults存
 *
 *  @YouValue 要存的值
 *
 *  @MKey 值的key
 */
+(void)MyValue:(NSString*)YouValue MKey:(NSString*)YouKey;

//验证email
+(BOOL)isValidateEmail:(NSString *)email;

//验证电话号码

+(BOOL)isValidateTelNumber:(NSString *)number;

/**
 *  正则判断手机号码地址格式
 *
 *  @param mobileNum 号码
 *
 *  @return yes为是
 */
+(BOOL)isMobileNumber:(NSString *)mobileNum;
/**
 *  判断字符是否以字母开头
 *
 *  @param str 需验证的字符
 *
 *  @return yes为是
 */
+(BOOL)character:(NSString*)str;

/**
 *  保存到沙盒的代码：
 *
 *  @param type 类型
 *  @param _id  id
 *  @param str  key名字
 */
+(void)saveCache:(NSString*)type andID:(NSString*)_id andString:(NSString *)str;

/**
 *  取数据
 *
 *  @param type 类型
 *  @param _Id  id
 *
 *  @return  返回字典
 */
+(NSDictionary*)getCache:(NSString*)type andID:(NSString*)_Id;

//将NSDictionary转化为json字符串
+(NSString *)json2String:(NSDictionary *)json;


+(float)adjustStatusBarHeightForiOS7;

//比较版本大小，格式必须都是1.0.0这种
+(BOOL)compareVersion:(NSString *)ver1 withOther:(NSString *)ver2;

//返回图片
+(void)UIimageView:(UIImageView*)image NSSting:(NSString*)url;

+(void)UIimageView:(UIImageView*)image NSSting:(NSString*)url  duImage:(NSString*)duImageName;

+(void)UIButton:(UIButton *)button NSSting:(NSString*)url;

+(float)UIlabel:(UILabel*)label NSStting:(NSString*)str Max:(float)fot;

+(float)UIlabelW:(UILabel*)label NSStting:(NSString*)str Max:(float)fot;

//通过url获取高度
+(CGFloat)picHeightForViewWithObject:(NSString *)url columnWidth:(CGFloat)columnWidth minHeight:(float)pictureMinHeight maxHeight:(float)pictureMaxHeight;

//用来计时的工具类，比如某些需要24小时只能执行最多一次，但必须保证返回yes一定要执行
+(BOOL)timeInterval:(NSString *)key withTime:(NSUInteger)seconds;


//存字典NSDictionary
+(void)dictionaryToJson:(NSDictionary *)dic File:(NSString*)file;

//json转字典
+(NSDictionary*)File:(NSString*)file;

+(NSMutableDictionary*)generateAuthInfo:(NSMutableDictionary *)paramData;
/**
 *  日期
 *
 *  @return 返回字符串日期
 */
+(NSString*)dataCalendar;


+(NSMutableArray*)data:(NSString*)p;
/**
 *  获取当前时间戳
 *
 *  @return 时间字符串
 */
+(NSString *)timeStamp;
@end
