//
//  ZKregisterViewController.m
//  CYmiangzhu
//
//  Created by Daqsoft-Mac on 15/8/11.
//  Copyright (c) 2015年 WangXiaoLa. All rights reserved.
//

#import "ZKregisterViewController.h"
#import "ZKFindViewController.h"
#import "ZKLoginViewController.h"
#import "ZKcarrierViewController.h"

#import "ZKMoreReminderView.h"
#import <ShareSDK/ShareSDK.h>
//#import "WXApi.h"
#import "WeiboSDK.h"
#import <TencentOpenAPI/QQApiInterface.h>

NSString *const ZKUserDidLoginedNotification = @"ZKUserDidLoginedNotification";

@interface ZKregisterViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *dlLabel;
@end

@implementation ZKregisterViewController


@synthesize dlLabel;

-(id)init
{
    self =[super init];
    if (self) {
        
        self.hidesBottomBarWhenPushed =YES;
        
        
    }
    
    return self;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    [self updataView];
    
    
    self.peopleText.text = [ZKUserInfo sharedZKUserInfo].account;
    
    [self.navigationBarView removeFromSuperview];
    self.dengluClick.layer.cornerRadius =4;
    // Do any additional setup after loading the view from its nib.
    self.hom_backImage.frame =CGRectMake(0, 0, kDeviceWidth, kDeviceHeight);
    //输入框中叉号编辑时出现
    self.peopleText.clearButtonMode =UITextFieldViewModeWhileEditing;
    self.peopleText.delegate =self;
    self.peopleText.spacing =25;
    //再次编辑就清空
    self.peopleText.clearsOnBeginEditing =NO;
    self.peopleText.textAlignment =NSTextAlignmentLeft;
    self.peopleText.returnKeyType =UIReturnKeyDone;
    
    //输入框中叉号编辑时出现
    self.passwoderText.clearButtonMode =UITextFieldViewModeWhileEditing;
    self.passwoderText.spacing =25;
    self.passwoderText.delegate =self;
    //再次编辑就清空
    self.passwoderText.secureTextEntry = YES;
    self.passwoderText.clearsOnBeginEditing =YES;
    self.passwoderText.textAlignment =NSTextAlignmentLeft;
    self.passwoderText.returnKeyType =UIReturnKeyDone;
    
    if (self.isMy ==NO) {
        
        [self.cenceBUtton removeFromSuperview];
        
    }
    
    UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped)];
    
    [self.view addGestureRecognizer:tapGr];
    
}




/**
 *  更新试图
 */
-(void)updataView
{
    
    
    NSMutableArray *viewArray =[NSMutableArray arrayWithCapacity:3];

        
        
        
        for (int i = 0 ; i<3; i++) {
            
            if (i == 0) {
                
            
                    
                    //UIView *views =[self titis:@"微信" imageName:@"weixing_TL" dex:0];
                    //[viewArray addObject:views];
           
            }
            
            if (i == 1) {
                
         
                    
                    UIView *views = [self titis:@"腾讯QQ" imageName:@"QQ_TL" dex:1];
                    
                    
                    [viewArray addObject:views];
                
                
            }
            
            if ( i ==2) {
                
          
                    
                    UIView *views = [self titis:@"新浪微博" imageName:@"weibo_TL" dex:2];
                    
                    [viewArray addObject:views];
                
                
            }
            
            
        }
        
        double segmentation = kDeviceWidth/viewArray.count;
        
        NSLog(@"%f -  - %f",segmentation,kDeviceHeight);
        
        
        for (int i =0; i<viewArray.count; i++) {
            
            UIView *views = viewArray[i];
            views.hidden = NO;
            views.backgroundColor =[UIColor clearColor];
            [views setFrame:CGRectMake(segmentation*i+segmentation/2-25, kDeviceHeight-90, 50, 70)];
            
        }
        
        
        
        
    
    
    
    
}

/**
 *  加载视图
 *
 *  @param str 名字
 *  @param img 图片名
 *  @param tg  tag
 *
 *  @return view
 */
-(UIView*)titis:(NSString*)str imageName:(NSString*)img dex:(NSInteger)tg;
{
    
    
    UIView *views = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 50, 70)];
    views.backgroundColor =[UIColor clearColor];
    views.userInteractionEnabled =YES;
    [self.view addSubview:views];
    
    UIImageView *backImage =[[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 40, 40)];
    backImage.backgroundColor =[UIColor clearColor];
    backImage.image =[UIImage imageNamed:img];
    [views addSubview:backImage];
    
    UILabel *label =[[UILabel alloc]initWithFrame:CGRectMake(0, 50, 50, 20)];
    label.backgroundColor =[UIColor clearColor];
    label.textAlignment =NSTextAlignmentCenter;
    label.font =[UIFont systemFontOfSize:11];
    label.textColor =[UIColor whiteColor];
    label.text =str;
    [views addSubview:label];
    
    UIButton *bty =[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 70)];
    bty.backgroundColor =[UIColor clearColor];
    bty.tag =1000+tg;
    [bty addTarget:self action:@selector(sfTlBUtton:) forControlEvents:UIControlEventTouchUpInside];
    [views addSubview:bty];
    
    return views;
    
}

#pragma mark textFled 代理

- (BOOL)textFieldShouldReturn:(UITextField *)textField;
{
    
    [self viewTapped];
    return YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}


#pragma mark 点击事件

-(void)showCenButton
{
    [SVProgressHUD showErrorWithStatus:@"登陆失败"];
    self.cenceBUtton.layer.opacity =1;
    [self.dengluClick setBackgroundColor:[UIColor orangeColor]];
    self.dengluClick.userInteractionEnabled =YES;
    
}

-(void)dismissSenderBUtton{

    self.cenceBUtton.layer.opacity =0;
    [self.dengluClick setBackgroundColor:[UIColor grayColor]];
    self.dengluClick.userInteractionEnabled =NO;
}

/**
 *  还原
 */
-(void)reduction;
{

    [self showCenButton];
}
/**
 *  第三方登录
 *
 *  @param sender
 
 */
- (void)sfTlBUtton:(UIButton*)sender {
    
    NSInteger index =sender.tag -1000;
    [self dismissSenderBUtton];
    [SVProgressHUD showSuccessWithStatus:@"正在登录中..." duration:1.5];
    
    //设置授权选项
    id<ISSAuthOptions> authOptions = [ShareSDK authOptionsWithAutoAuth:YES
                                                         allowCallback:YES
                                                         authViewStyle:SSAuthViewStyleFullScreenPopup
                                                          viewDelegate:nil
                                               authManagerViewDelegate:nil];
    
    [authOptions setFollowAccounts:[NSDictionary dictionaryWithObjectsAndKeys:
                                    [ShareSDK userFieldWithType:SSUserFieldTypeName value:@"ShareSDK"],
                                    SHARE_TYPE_NUMBER(ShareTypeSinaWeibo),
                                    [ShareSDK userFieldWithType:SSUserFieldTypeName value:@"ShareSDK"],
                                    SHARE_TYPE_NUMBER(ShareTypeTencentWeibo),
                                    [ShareSDK userFieldWithType:SSUserFieldTypeName value:@"ShareSDK"],
                                    SHARE_TYPE_NUMBER(ShareTypeWeixiTimeline),
                                    
                                    nil]];
    if (index ==0) {
        
        //[ShareSDK getUserInfoWithType:ShareTypeWeixiTimeline authOptions:authOptions result:^(BOOL result, id<ISSPlatformUser> userInfo, id<ICMErrorInfo> error) {
            
            //NSLog(@" 1111111   %d",result);
            //if (result) {
                ////成功登录后，判断该用户的ID是否在自己的数据库中。
                ////如果有直接登录，没有就将该用户的ID和相关资料在数据库中创建新用户。
                ////                [self reloadStateWithType:ShareTypeQQSpace];
                //[self loginWithMethod:@"thirdLogin" isThirdLogin:YES thirdLoginIdentifier:[userInfo uid]];
                //[self saveThirdLoginUserInfo:userInfo];
            //}else{
            
                //[self reduction];
            //}
            
            
        //}];
    }else if (index ==1){
        
        [[BaiduMobStat defaultStat] logEvent:@"btn_login_qq" eventLabel:@"QQ帐号登录"];
        
        
        [ShareSDK getUserInfoWithType:ShareTypeQQSpace authOptions:authOptions result:^(BOOL result, id<ISSPlatformUser> userInfo, id<ICMErrorInfo> error) {
            NSLog(@"22222222 %d",result);
            if (result) {
                //成功登录后，判断该用户的ID是否在自己的数据库中。
                //如果有直接登录，没有就将该用户的ID和相关资料在数据库中创建新用户。
                //                [self reloadStateWithType:ShareTypeQQSpace];
                
                [self loginWithMethod:@"thirdLogin" isThirdLogin:YES thirdLoginIdentifier:[userInfo uid]];
                [self saveThirdLoginUserInfo:userInfo];
            }else{
                
                [self reduction];
            }
            
        }];
        
        
    }else if (index ==2){
        
        [[BaiduMobStat defaultStat] logEvent:@"" eventLabel:@""];
        
        [ShareSDK getUserInfoWithType:ShareTypeSinaWeibo authOptions:authOptions result:^(BOOL result, id<ISSPlatformUser> userInfo, id<ICMErrorInfo> error) {
            
            
            NSLog(@" 3333333  %d",result);
            
            if (result) {
                //成功登录后，判断该用户的ID是否在自己的数据库中。
                //如果有直接登录，没有就将该用户的ID和相关资料在数据库中创建新用户。
                //                [self reloadStateWithType:ShareTypeSinaWeibo];
                
                [self loginWithMethod:@"thirdLogin" isThirdLogin:YES thirdLoginIdentifier:[userInfo uid]];
                [self saveThirdLoginUserInfo:userInfo];
            }else{
                
                [self reduction];
            }
        }];
    }
}

/**
 *  保存三方登陆的用户信息
 */
- (void)saveThirdLoginUserInfo:(id<ISSPlatformUser>)userInfo
{
    [ZKUserInfo sharedZKUserInfo].name = [userInfo nickname];
    [ZKUserInfo sharedZKUserInfo].photo = [userInfo profileImage];
    [ZKUserInfo sharedZKUserInfo].sex = [NSString stringWithFormat:@"%d", [userInfo gender]];
    [[ZKUserInfo sharedZKUserInfo] saveUserInfo];
}

/**
 *  背景被点击
 */
-(void)viewTapped
{

    [self.peopleText  resignFirstResponder];
    [self.passwoderText resignFirstResponder];
    
}
/**
 *  注册
 *
 *  @param sender
 */
- (IBAction)zhuceClick:(UIButton *)sender {
    
    [[BaiduMobStat defaultStat] logEvent:@"btn_regist" eventLabel:@"注册"];
    
    ZKLoginViewController *enroll =[[ZKLoginViewController alloc]init];
    [self.navigationController pushViewController:enroll animated:YES];
}
/**
 *  找回密码
 *
 *  @param sender
 */
- (IBAction)zhaoMiMa:(UIButton *)sender {
    
    ZKFindViewController *find =[[ZKFindViewController alloc]init];
    [self.navigationController pushViewController:find animated:YES];
    
    
}
/**
 *  登录
 *
 *  @param sender
 */
- (IBAction)dlClick:(UIButton *)sender {
    
    [[BaiduMobStat defaultStat] logEvent:@"btn_login" eventLabel:@"登录"];
    
    if (self.peopleText.text.length ==0) {
        [self.peopleText resignFirstResponder];
        
        [self.view makeToast:@"亲，账号不能为空!"];
        
        return;
    }
    
    if (self.passwoderText.text.length ==0) {
        [self.passwoderText resignFirstResponder];
        
        [self.view makeToast:@"亲，密码不能为空!"];
        
        return;
    }
    
    if ([self.peopleText.text rangeOfString:@" "].location != NSNotFound) {
        
        [self.view makeToast:@"亲，账号错误!"];
        return;
    }
    
    if ([self.passwoderText.text rangeOfString:@" "].location != NSNotFound) {
        
        [self.view makeToast:@"亲，密码错误!"];
        return;
    }
    
    
    [self.view endEditing:YES];
    
    [self loginWithMethod:@"login" isThirdLogin:NO thirdLoginIdentifier:nil];
    
    if (_isMy ==NO) {
        //注销后登录界面
        
    }else{ //非注销后登录界面
        
        
        if (self.updateAlertBlock)
        {
            self.updateAlertBlock();
        }
        
    }
    
}

#pragma mark - login
- (void)loginWithMethod:(NSString *)method isThirdLogin:(BOOL)third thirdLoginIdentifier:(NSString *)identifier
{
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    para[@"TimeStamp"] = [ZKUtil timeStamp];
    para[@"method"] = method;
    
    if (!third) {
        para[@"interfaceId"] = @22;
        para[@"account"] = self.peopleText.text;
        para[@"password"] = self.passwoderText.text;
        para[@"type"] = @"huiyuan";
    }else{
        para[@"interfaceId"] = @26;
        para[@"identifier"] = identifier;
    }
    
    
    [SVProgressHUD showWithStatus:@"正在登录中..."];
    self.view.userInteractionEnabled= NO;
    
    [ZKHttp post:ZKPostUrl params:para success:^(id responseObj) {
        NSLog(@"%@", responseObj);
        
        [SVProgressHUD dismiss];
        self.view.userInteractionEnabled= YES;
        //请求成功并能登陆
        if ([responseObj[@"errmsg"] isEqualToString:@"SUCCESS"]) {
            
            //保存用户信息
            ZKUserInfo *userinfo = [ZKUserInfo sharedZKUserInfo];
            userinfo = [ZKUserInfo objectWithKeyValues:responseObj[@"root"][@"member"]];
            userinfo.userMessage = responseObj;
            userinfo.password = self.passwoderText.text;
            
            if (!third) { //非三方登录
                userinfo.account = self.peopleText.text;
            }
            
            userinfo.logined = YES;
            userinfo.thirdLogin = third;
            
            [[ZKUserInfo sharedZKUserInfo] saveUserInfo];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:ZKUserDidLoginedNotification object:nil];
            
            
            if (_isMy) {  // 点击登录

                if (self.updateAlertBlock)
                {
                    self.updateAlertBlock();
                }
                
                [self dismissViewControllerAnimated:YES completion:nil];
                
            }else{
                //注销后再次登录
                ZKcarrierViewController *hom =[[ZKcarrierViewController alloc] init];
                UINavigationController *nav =[[UINavigationController alloc]initWithRootViewController:hom];
                [UIApplication sharedApplication].delegate.window.rootViewController = nav;
                
            }
            
            
        }else{ //请求成功但有错误
            
            [self showCenButton];
            NSString *msg = responseObj[@"errmsg"];
            [self.view makeToast:msg duration:1 position:nil];
            
            if (third) {
                [self cancelAuth];
            }
        }
        
        
    } failure:^(NSError *error) {
        
        [self showCenButton];
        [self.view makeToast:@"网络出错" duration:1 position:nil];
        [SVProgressHUD dismiss];
        self.view.userInteractionEnabled= YES;
        
        if (third) {
            [self cancelAuth];
        }
    }];
    
}

-(void)dengluCG:(UpdateAlertBlock)pk;
{
    
    self.updateAlertBlock =pk;
}
//第三方登录失败取消授权
- (void)cancelAuth{
    
    [[ZKUserInfo sharedZKUserInfo] resetUserInfo];
    
    if ([ShareSDK hasAuthorizedWithType:ShareTypeQQSpace]) {
        [ShareSDK cancelAuthWithType:ShareTypeQQSpace];
        return;
    }
    
    if ([ShareSDK hasAuthorizedWithType:ShareTypeWeixiSession]) {
        [ShareSDK cancelAuthWithType:ShareTypeWeixiSession];
        return;
    }
    
    if ([ShareSDK hasAuthorizedWithType:ShareTypeSinaWeibo]) {
        [ShareSDK cancelAuthWithType:ShareTypeSinaWeibo];
        return;
    }
    
}

- (IBAction)cenceClick:(id)sender {
    
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

-(void)reloadStateWithType:(ShareType)type{
    //现实授权信息，包括授权ID、授权有效期等。
    //此处可以在用户进入应用的时候直接调用，如授权信息不为空且不过期可帮用户自动实现登录。
    id<ISSPlatformCredential> credential = [ShareSDK getCredentialWithType:type];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"TEXT_TIPS", @"提示")
                                                        message:[NSString stringWithFormat:
                                                                 @"uid = %@\ntoken = %@\nsecret = %@\n expired = %@\nextInfo = %@",
                                                                 [credential uid],
                                                                 [credential token],
                                                                 [credential secret],
                                                                 [credential expired],
                                                                 [credential extInfo]]
                                                       delegate:nil
                                              cancelButtonTitle:NSLocalizedString(@"TEXT_KNOW", @"知道了")
                                              otherButtonTitles:nil];
    [alertView show];
}


- (void)loginViewControllerDidSuccessRegister:(ZKLoginViewController *)loginViewController
{
    self.peopleText.text = [ZKUserInfo sharedZKUserInfo].mobile;
    
}

@end
