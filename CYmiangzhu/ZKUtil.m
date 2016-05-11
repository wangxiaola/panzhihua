//
//  DQUtil.m
//  ChangYouYiBin
//
//  Created by Daqsoft-Mac on 14/11/24.
//  Copyright (c) 2014年 StrongCoder. All rights reserved.
//

#import "ZKUtil.h"
#import <UIKit/UIKit.h>
#import "UIImageView+WebCache.h"
#import "UIButton+WebCache.h"
#import "JSON.h"

@implementation ZKUtil

+ (NSString *)timeStamp
{
    NSTimeInterval time= [[NSDate date] timeIntervalSince1970] * 1000;
    
    return [NSString stringWithFormat:@"%lld", (long long)time];
}

- (UIImage*)imageFromRGB565:(void*)rawData width:(int)width height:(int)height
{
    const size_t bufferLength = width * height * 2;
    NSData *data = [NSData dataWithBytes:rawData length:bufferLength];
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGDataProviderRef provider = CGDataProviderCreateWithCFData((CFDataRef)data);
    
    // Creating CGImage from cv::Mat
    CGImageRef imageRef = CGImageCreate(width,          //width
                                        height,         //height
                                        5,              //bits per component
                                        16,             //bits per pixel
                                        width * 2,      //bytesPerRow
                                        colorSpace,     //colorspace
                                        kCGImageAlphaNoneSkipFirst | kCGBitmapByteOrder16Little,// bitmap info
                                        provider,               //CGDataProviderRef
                                        NULL,                   //decode
                                        false,                  //should interpolate
                                        kCGRenderingIntentDefault   //intent
                                        );
    
    // Getting UIImage from CGImage
    UIImage *finalImage = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    CGDataProviderRelease(provider);
    CGColorSpaceRelease(colorSpace);
    
    return finalImage;
}
+(NSDictionary*)responseObject:(id)str;
{
    
    str = (NSData *)str;
    
    NSString* headerData=[[NSString alloc] initWithData:str  encoding:NSUTF8StringEncoding];;
    headerData = [headerData stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];  //去除掉首尾的空白字符和换行字符
    headerData = [headerData stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    headerData = [headerData stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    
    NSDictionary *backdict = [headerData JSONValue];
    
    return backdict;
}

+(id)imageUrlsD:(NSString*)urls;
{
    
    NSArray *urlA =[urls componentsSeparatedByString:@","];
    
    return urlA;
    
    
    
}

+(id)imageUrls:(NSString*)urls;
{
    NSArray *urlA;
    if (strIsEmpty(urls)==0) {
        
        urlA =[urls componentsSeparatedByString:@"-"];
    }else{
        
        urlA =@[@"zz",@"zz"];
    }
    
    
    return urlA;
    
}
+(BOOL)FetchImage:(NSString*)path;
{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"images.%@",path]];
    if (filePath) {
        return YES;
    }else{
        
        return NO;
    }
    
}
+(UIImage*)fetchImage:(NSString*)path;
{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"images.%@",path]];
    // 保存文件的名称
    //       NSLog(@" ;- - -;;;;; %@",filePath);
    UIImage *img = [UIImage imageWithContentsOfFile:filePath];
    
    return img;
    
}
+(BOOL)setPhotoToPath:(NSData*)image isName:(NSString *)name
{
    //此处首先指定了图片存取路径（默认写到应用程序沙盒 中）
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    
    //并给文件起个文件名
    NSString *uniquePath=[[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"images.%@",name]];
    NSLog(@" ;;;;;; %@",uniquePath);
    BOOL blHave=[[NSFileManager defaultManager] fileExistsAtPath:uniquePath];
    if (blHave) {
        NSLog(@"already have");
        //delete
        [self deleteFromName:name];
        
    }
    
    BOOL result = [image writeToFile:uniquePath atomically:NO];
    if (result) {
        NSLog(@"success");
        return YES;
    }else {
        NSLog(@"no success");
        return NO;
    }
}
//删除已经有的图片
+(BOOL)deleteFromName:(NSString *)name
{
    NSFileManager* fileManager=[NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    //文件名
    NSString *uniquePath=[[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"images.%@",name]];
    BOOL blHave=[[NSFileManager defaultManager] fileExistsAtPath:uniquePath];
    if (!blHave) {
        //NSLog(@"no  have");
        return NO;
    }else {
        //NSLog(@" have");
        BOOL blDele= [fileManager removeItemAtPath:uniquePath error:nil];
        if (blDele) {
            //NSLog(@"dele success");
            return YES;
        }else {
            //NSLog(@"dele fail");
            return NO;
        }
    }
}
+(NSString*)FilePath:(NSString*)path;
{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    //文件名
    NSString *sPath=[[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",path]];
    return sPath;
    
}

+(BOOL)filePath:(NSString*)path
{
    NSFileManager* fileManager=[NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    //文件名
    NSString *sPath=[[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",path]];
    
    NSLog(@"删除---%@",sPath);
    BOOL success =[fileManager removeItemAtPath:sPath error:nil];
    
    return success;
}
+(BOOL)MyboolForKey:(NSString *)defaultName;
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:defaultName];
    
}
+(void)MyboolForKey:(NSString *)defaultName setBool:(BOOL)value;
{
    [[NSUserDefaults standardUserDefaults] setBool:value forKey:defaultName];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    
}
+(NSString*)ToTakeTheKey:(NSString*)sK;
{
    
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    if (defaults) {
        
        NSString *phone=[defaults objectForKey:sK];
        return phone;
    }else{
        
        return nil;
    }
    
}

+(void)MyValue:(NSString*)YouValue MKey:(NSString*)YouKey;
{
    
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    [defaults setObject:YouValue forKey:YouKey];
    [defaults synchronize];
}
//验证email
+(BOOL)isValidateEmail:(NSString *)email {
    
    NSString *strRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{1,5}";
    
    BOOL rt = [self isValidateRegularExpression:email byExpression:strRegex];
    
    return rt;
    
}


//验证电话号码
+(BOOL)isValidateTelNumber:(NSString *)number {
    
    NSString *strRegex = @"[0-9]{1,20}";
    
    BOOL rt = [self isValidateRegularExpression:number byExpression:strRegex];
    
    return rt;
    
}
+(BOOL)isValidateRegularExpression:(NSString *)strDestination byExpression:(NSString *)strExpression

{
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", strExpression];
    
    return [predicate evaluateWithObject:strDestination];
    
}

+(BOOL)isMobileNumber:(NSString *)mobileNum;
{
    
    //    /**
    //      手机号码
    //      移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
    //      联通：130,131,132,152,155,156,185,186
    //      电信：133,1349,153,180,189
    //     */
    //    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    //    /**
    //              * 中国移动：China Mobile
    //              * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
    //              */
    //    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    //    /**
    //              * 中国联通：China Unicom
    //              * 130,131,132,152,155,156,185,186
    //              */
    //    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    //    /**
    //            * 中国电信：China Telecom
    //            * 133,1349,153,180,189
    //            */
    //    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    //    /**
    //            * 大陆地区固话及小灵通
    //            * 区号：010,020,021,022,023,024,025,027,028,029
    //            * 号码：七位或八位
    //            */
    //    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    //
    //    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    //    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    //    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    //    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    //
    //    if (([regextestmobile evaluateWithObject:mobileNum] == YES)
    //        || ([regextestcm evaluateWithObject:mobileNum] == YES)
    //        || ([regextestct evaluateWithObject:mobileNum] == YES)
    //        || ([regextestcu evaluateWithObject:mobileNum] == YES))
    //    {
    //        if([regextestcm evaluateWithObject:mobileNum] == YES) {
    //            NSLog(@"China Mobile");
    //        } else if([regextestct evaluateWithObject:mobileNum] == YES) {
    //            NSLog(@"China Telecom");
    //        } else if ([regextestcu evaluateWithObject:mobileNum] == YES) {
    //            NSLog(@"China Unicom");
    //        } else {
    //            NSLog(@"Unknow");
    //        }
    //
    //        return YES;
    //    }
    //    else
    //    {
    //        return NO;
    //    }
    
    NSString *pattern = @"^1+[34578]+\\d{9}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:mobileNum];
    return isMatch;
    
}

+(BOOL)character:(NSString*)str;
{
    NSString *regex = @"[A-Za-z]+";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    NSString *k =[str substringToIndex:1];
    return [predicate evaluateWithObject:k];
    
    
}
+ (void)saveCache:(NSString*)type andID:(NSString*)_id andString:(NSString *)str;
{
    NSUserDefaults * setting = [NSUserDefaults standardUserDefaults];
    NSString * key = [NSString stringWithFormat:@"detail-%@-%@",type, _id];
    [setting setObject:str forKey:key];
    [setting synchronize];
}

+(NSDictionary*)getCache:(NSString*)type andID:(NSString*)_Id;
{
    NSUserDefaults * settings = [NSUserDefaults standardUserDefaults];
    NSString *key = [NSString stringWithFormat:@"detail-%@-%@",type, _Id];
    
    NSString *value = [settings objectForKey:key];
    
    if (strIsEmpty(value)==1) {
        
        return nil;
    }else{
        
        NSDictionary *backdict = [value JSONValue];
        
        return backdict;
    }
    
}
+(NSString *)json2String:(NSDictionary *)json{
    if (json == nil) {
        return nil;
    }
    NSData *data = [NSJSONSerialization dataWithJSONObject:json options:NSJSONWritingPrettyPrinted error:nil];
    NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return string;
}

//+(NSMutableDictionary*)generateAuthInfo:(NSMutableDictionary *)paramData{
//
//    paramData[@"seccode"] =ACCOUNTID;
//    NSLog(@" 后  %@",paramData);
//    return paramData;
//}
+(float)adjustStatusBarHeightForiOS7{
    return statusBarHeight;
}



+(BOOL)compareVersion:(NSString *)ver1 withOther:(NSString *)ver2;{
    if([ver1 isEqualToString:ver2]){
        return 0;
    }
    ver1 = [ver1 stringByReplacingOccurrencesOfString:@"." withString:@""];
    ver2 = [ver2 stringByReplacingOccurrencesOfString:@"." withString:@""];
    
    int iver1 = [ver1 intValue];
    int iver2 = [ver2 intValue];
    
    if(iver1 > iver2){
        return YES;
    }else{
        return NO;
    }
}
+(void)UIimageView:(UIImageView*)image NSSting:(NSString*)url
{
    [image sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"zz"]];
}

+(void)UIButton:(UIButton *)button NSSting:(NSString*)url
{
    [button sd_setImageWithURL:[NSURL URLWithString:url] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"set_zhaoping"]];
}
+(void)dictionaryToJson:(id)dic File:(NSString*)file;
{
    
    
    if ([dic count]==0) {
        return;
    }
    dispatch_queue_t queue =  dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    //2.添加任务到队列中，就可以执行任务
    //异步函数：具备开启新线程的能力
    dispatch_async(queue, ^{
        
        NSError *parseError = nil;
        NSData  *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
        
        NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *path=[paths objectAtIndex:0];
        NSString *Json_path=[path stringByAppendingPathComponent:[NSString stringWithFormat:@"JsonFile.%@",file]];
        
        [jsonData writeToFile:Json_path atomically:YES];
        
        
    });
    
    
}
+(id)File:(NSString*)file;
{
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"upload"]) {
        
        //==Json文件路径
        NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *path=[paths objectAtIndex:0];
        NSString *Json_path=[path stringByAppendingPathComponent:[NSString stringWithFormat:@"JsonFile.%@",file]];
        //==Json数据
        NSData *data=[NSData dataWithContentsOfFile:Json_path];
        //==JsonObject
        
        NSError *error =nil;
        if (data ==nil) {
            
            return nil;
        }
        id JsonObject=[NSJSONSerialization JSONObjectWithData:data
                                                      options:NSJSONReadingAllowFragments
                                                        error:&error];
        
        
        return JsonObject;
        
        
    }else{
        
        NSDictionary *dic;
        return dic;
        
    }
}

+(void)UIimageView:(UIImageView*)image NSSting:(NSString*)url  duImage:(NSString*)duImageName;
{
    if (duImageName == nil) {
        [image sd_setImageWithURL:[NSURL URLWithString:url]];
    }else {
        [image sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:duImageName]];
    }
    
}

+(float)UIlabel:(UILabel*)label NSStting:(NSString*)str Max:(float)fot;
{
    /*
     if (strIsEmpty(str) ==1) {
     return 50;
     
     }else{
     
     // CGSize size = [str sizeWithFont:label.font constrainedToSize:CGSizeMake(label.frame.size.width, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
     NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:fot]};
     CGSize size = [str boundingRectWithSize:CGSizeMake(label.frame.size.width, MAXFLOAT) options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
     float height =size.height;
     
     return height;
     
     }
     */
    
    if (strIsEmpty(str) ==1) {
        return 50;
        
    }else{
        
        CGSize size = [str sizeWithFont:label.font constrainedToSize:CGSizeMake(label.frame.size.width, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
        
        
        
        //        CGSize maxh =CGSizeMake(label.frame.size.width, MAXFLOAT);
        //        NSDictionary *dic =@{NSFontAttributeName:label.font};
        //
        //        CGSize size =[str boundingRectWithSize:maxh options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
        
        float height =size.height;
        
        return height;
        
    }
    
    
}

- (NSString *)formatTime:(int)num{
    
    int sec = num % 60;
    int min = num / 60;
    if (num < 60) {
        return [NSString stringWithFormat:@"00:%02d",num];
    }
    return [NSString stringWithFormat:@"%02d:%02d",min,sec];
}



+(float)UIlabelW:(UILabel*)label NSStting:(NSString*)str Max:(float)fot;
{
    /*
     if (strIsEmpty(str)==1) {
     return 20;
     }else{
     
     CGFloat size=[str boundingRectWithSize:CGSizeMake(MAXFLOAT, label.frame.size.height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]} context:nil].size.width;
     float  width =size;
     return width;
     
     }
     */
    
    if (strIsEmpty(str)==1) {
        return 80;
    }else{
        
        CGSize size = [str sizeWithFont:label.font constrainedToSize:CGSizeMake(MAXFLOAT, label.frame.size.height)];
        
        //        CGSize maxh =CGSizeMake(MAXFLOAT,label.frame.size.height);
        //        NSDictionary *dic =@{NSFontAttributeName:label.font};
        //
        //        CGSize size =[str boundingRectWithSize:maxh options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
        
        
        float  width =size.width;
        return width;
        
        
        
    }
    
}
+(CGFloat)picHeightForViewWithObject:(NSString *)url columnWidth:(CGFloat)columnWidth minHeight:(float)pictureMinHeight maxHeight:(float)pictureMaxHeight
{
    NSArray *splitUrl = [url componentsSeparatedByString:@"/"];
    float picWidth;
    float picHeight;
    if(splitUrl.count > 1){
        NSString *whString = [splitUrl objectAtIndex:splitUrl.count-2];
        NSArray *whArray = [whString componentsSeparatedByString:@"x"];
        picWidth = [whArray.firstObject floatValue];
        if (picWidth == 0 || whArray.count < 2) {
            picHeight = pictureMinHeight;
        }else{
            if(picWidth < 0.05*columnWidth){
                return 0;
            }
            picHeight = MIN(pictureMaxHeight, [whArray.lastObject floatValue]/picWidth*columnWidth) ;
        }
    }else{
        picHeight = pictureMinHeight;
    }
    return picHeight;
}


+(BOOL)timeInterval:(NSString *)key withTime:(NSUInteger)seconds{
    NSDate *date = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    if(date){
        NSTimeInterval interval = [[NSDate date] timeIntervalSinceDate:date];
        if(interval < seconds){
            return NO;
        }
    }
    [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
    return YES;
}
//遍历文件夹获得文件夹大小，返回多少M
-(float ) folderSizeAtPath:(NSString*) folderPath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:folderPath]) return 0;
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:folderPath] objectEnumerator];
    NSString* fileName;
    long long folderSize = 0;
    while ((fileName = [childFilesEnumerator nextObject]) != nil){
        NSString* fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
        folderSize += [self fileSizeAtPath:fileAbsolutePath];
    }
    return folderSize/(1024.0*1024.0);
}

- (long long) fileSizeAtPath:(NSString*) filePath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]){
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}

+(NSMutableDictionary*)generateAuthInfo:(NSMutableDictionary *)paramData{
    
    paramData[@"seccode"] = @"9C1438BE6CF68E52E0B20C6C4259C250F6913438DABE0219";
    
    NSLog(@"\n\n请求参数:  \n%@\n",paramData);
    
    return paramData;
}

+(NSString*)dataCalendar;
{
    
    NSInteger year,month,day,hour,min,sec,week;
    NSString *weekStr=nil;
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDate *now = [NSDate date];;
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit |
    NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    
    comps = [calendar components:unitFlags fromDate:now];
    year = [comps year];
    week = [comps weekday];
    month = [comps month];
    day = [comps day];
    hour = [comps hour];
    min = [comps minute];
    sec = [comps second];
    
    if(week==1)
    {
        weekStr=@"星期天";
    }else if(week==2){
        weekStr=@"星期一";
        
    }else if(week==3){
        weekStr=@"星期二";
        
    }else if(week==4){
        weekStr=@"星期三";
        
    }else if(week==5){
        weekStr=@"星期四";
        
    }else if(week==6){
        weekStr=@"星期五";
        
    }else if(week==7){
        weekStr=@"星期六";
        
    }
    else {
        NSLog(@"error!");
    }
    
    
    
    return [NSString stringWithFormat:@"%ld年%ld月%ld日 %ld时%ld分%ld秒  %@",(long)year,(long)month,(long)day,(long)hour,(long)min,(long)sec,weekStr];//将会输出2012-03-04.
    
}


+(NSMutableArray*)data:(NSString*)p;
{
    
    NSMutableArray *dataArray =[[NSMutableArray alloc]initWithCapacity:0];
    
    NSArray *x_0 =[p componentsSeparatedByString:@"$"];
    
    NSArray *urlArray =[x_0[0] componentsSeparatedByString:@"#"];
    
    NSString *select =x_0[1];
    
    NSArray *infor =[x_0[2] componentsSeparatedByString:@"#"];
    
    [dataArray  addObject:urlArray];
    [dataArray addObject:select];
    [dataArray addObject:infor];
    
    return dataArray;
}
@end
