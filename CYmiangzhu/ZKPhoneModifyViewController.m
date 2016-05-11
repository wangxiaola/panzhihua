//
//  ZKPhoneModifyViewController.m
//  CYmiangzhu
//
//  Created by 汤亮 on 15/8/28.
//  Copyright (c) 2015年 WangXiaoLa. All rights reserved.
//


#import "ZKPhoneModifyViewController.h"
#import "UIKeyboardView.h"
#import "ZKTextField.h"

#import "ZKMoreReminderView.h"

#import "AFViewShaker.h"
@interface ZKPhoneModifyViewController ()
{
    ZKTextField *phoneField;
    
    UIView *phonView;
    
    ZKTextField *identifyingField;
    
    UIView *identifyingView;
    
    UIButton *identifyingButton;
    
    UIActivityIndicatorView *_activityView;
}

@property (nonatomic, retain) AFViewShaker * viewShaker;

//获取验证码按钮
@property(nonatomic ,weak) UIButton *random;
//验证码
@property (nonatomic, copy) NSString *capcha;
@end

@implementation ZKPhoneModifyViewController




-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    keyBoardController=[[UIKeyboardViewController alloc] initWithControllerDelegate:self];
    [keyBoardController addToolbarToKeyboard];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    keyBoardController =nil;
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [SVProgressHUD dismiss];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titeLabel.text =@"绑定手机";
    self.view.backgroundColor =TabelBackCorl;
    [self initView];
    
    
    // Do any additional setup after loading the view.
}
//初始化View
-(void)initView
{
    
    [self.rittBarButtonItem removeFromSuperview];

    float cellHeight =44;
    UIView * contenView =[[UIView alloc]initWithFrame:CGRectMake(0,26+navigationHeghit, self.view.frame.size.width, cellHeight*4+30)];
    contenView.backgroundColor =[UIColor clearColor];
    [self.view addSubview:contenView];
    
    
    //    电话输入框
    
    phonView =[[UIView alloc]initWithFrame:CGRectMake(10, 0, contenView.frame.size.width-20, cellHeight)];
    phonView.backgroundColor =[UIColor whiteColor];
    phonView.layer.borderColor =TabelBackCorl.CGColor;
    phonView.layer.borderWidth =0.5;
    phonView.layer.cornerRadius =4;
    [contenView addSubview:phonView];
    
    phoneField =[[ZKTextField alloc]initWithFrame:CGRectMake(0, 0, contenView.frame.size.width-80, cellHeight)];
    phoneField.backgroundColor =[UIColor clearColor];
    phoneField.placeholder =@"输入电话号码";
    phoneField.font =[UIFont systemFontOfSize:14];
    phoneField.textColor =[UIColor blackColor];
    //输入框中叉号编辑时出现
    phoneField.clearButtonMode =UITextFieldViewModeWhileEditing;
    //再次编辑就清空
    phoneField.clearsOnBeginEditing =NO;
    phoneField.textAlignment =NSTextAlignmentLeft;
    phoneField.keyboardType =UIKeyboardTypeNumberPad;
    phoneField.returnKeyType =UIReturnKeyDone;
    phoneField.spacing =10;
    [phonView addSubview:phoneField];
    
    
    
    identifyingView =[[UIView alloc]initWithFrame:CGRectMake(10, cellHeight*1+10, contenView.frame.size.width-20, cellHeight)];
    identifyingView.backgroundColor =[UIColor whiteColor];
    identifyingView.layer.borderColor =TabelBackCorl.CGColor;
    identifyingView.layer.borderWidth =0.5;
    identifyingView.layer.cornerRadius =4;
    [contenView addSubview:identifyingView];
    
    identifyingField =[[ZKTextField alloc]initWithFrame:CGRectMake(0, 0, contenView.frame.size.width-20, cellHeight)];
    identifyingField.backgroundColor =[UIColor clearColor];
    identifyingField.placeholder =@"请输入验证码";
    identifyingField.textColor =[UIColor blackColor];
    //输入框中叉号编辑时出现
    identifyingField.font =[UIFont systemFontOfSize:14];
    identifyingField.clearButtonMode =UITextFieldViewModeWhileEditing;
    //再次编辑就清空
    identifyingField.clearsOnBeginEditing =YES;
    identifyingField.textAlignment =NSTextAlignmentLeft;
    identifyingField.keyboardType =UIKeyboardTypeASCIICapable;
    identifyingField.returnKeyType =UIReturnKeyDone;
    //每输入一个字符就变成点 用语密码输入
    identifyingField.secureTextEntry = NO;
    identifyingField.spacing =10;
    [identifyingView addSubview:identifyingField];
    
    
    
    UIButton *random =[[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width-90, 8, 70, cellHeight-16)];
    random.backgroundColor =[UIColor clearColor];
    random.layer.cornerRadius =4;
    random.backgroundColor =CYBColorGreen;
    [random addTarget:self action:@selector(acquire) forControlEvents:UIControlEventTouchUpInside];
    [random setTitle:@"获取验证码" forState:UIControlStateNormal];
    random.titleLabel.font =[UIFont systemFontOfSize:10];
    random.titleLabel.textAlignment =NSTextAlignmentCenter;
    [random setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [random setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [contenView addSubview:random];
    self.random = random;
    
    UIButton *loginButton =[[UIButton alloc]initWithFrame:CGRectMake(10,cellHeight * 3 + 10+navigationHeghit, self.view.frame.size.width-20, cellHeight)];
    loginButton.backgroundColor =CYBColorGreen;
    [loginButton setTitle:@"确认绑定" forState:UIControlStateNormal];
    [loginButton setBackgroundImage:[UIImage imageNamed:@"enroll_1"] forState:UIControlStateNormal];
    [loginButton setBackgroundImage:[UIImage imageNamed:@"enroll_0"] forState:UIControlStateHighlighted];
    loginButton.titleLabel.font =[UIFont boldSystemFontOfSize:18];
    [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [loginButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [loginButton addTarget:self action:@selector(loginClick) forControlEvents:UIControlEventTouchUpInside];
    loginButton.layer.cornerRadius =4;
    [self.view addSubview:loginButton];
    
    _activityView = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
    _activityView .center = CGPointMake(self.view.frame.size.width/2, cellHeight * 3 + 10+navigationHeghit+cellHeight+30);
    //设置菊花样式
    _activityView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    _activityView.color =CYBColorGreen;
    [self.view addSubview:_activityView];
    
    
}
#pragma mark 点击事件


-(void)enterClick
{
    
    
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}


#pragma mark - 获取验证码计时
- (void)fire
{
    __weak typeof(self) weakself = self;
    __block int timeout=60; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [weakself.random setTitle:@"获取验证码" forState:UIControlStateNormal];
                weakself.random.enabled = YES;
                weakself.random.backgroundColor = CYBColorGreen;;
            });
        }else{
            //            int minutes = timeout / 60;
            int seconds = timeout % 60;
            NSString *strTime = [NSString stringWithFormat:@"%.d秒后重发", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [weakself.random setTitle:[NSString stringWithFormat:@"%@",strTime] forState:UIControlStateNormal];
                weakself.random.enabled = NO;
                weakself.random.backgroundColor =[UIColor grayColor];
                
            });
            timeout--;
            
        }
    });
    dispatch_resume(_timer);
}

- (void)fireTime
{
    static int i = 60;
    
    NSString *strTime = [NSString stringWithFormat:@"%.d秒后重发", i];
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        i--;
        
        if (i<=0) {
            
            [self.random setTitle:@"获取验证码" forState:UIControlStateNormal];
            self.random.enabled = YES;
            
            return;
            
        }else{
            
            [self.random setTitle:[NSString stringWithFormat:@"%@",strTime] forState:UIControlStateNormal];
            
            self.random.enabled = NO;
            
            [self fireTime];
        }
        
        
    });

}

//获取验证码
-(void)acquire
{
    
    [self.view endEditing:YES];
    
    if (phoneField.text.length == 0) {
        
        [self.view makeToast:@"请填写手机号码" duration:1 position:nil];
        return;
    }
    
    //    if ([ZKUtil timeInterval:@"verification" withTime:60]) {
    
    if (![ZKUtil  isMobileNumber:phoneField.text]) {
        
        [self.view makeToast:@"请填写正确的手机号码" duration:1 position:nil];
        [self shake:phonView];
        return;
    }
    
    
    [self fire];
    
    [_activityView startAnimating];
    
    NSMutableDictionary *dic =[NSMutableDictionary dictionary];
    dic[@"TimeStamp"] = [ZKUtil timeStamp];
    dic[@"interfaceId"]= @32;
    dic[@"method"] = @"sendCaptcha";
    dic[@"phone"] = phoneField.text;
    
    [ZKHttp post:ZKPostUrl params:dic success:^(id responseObj) {
        [_activityView stopAnimating];
        
        NSLog(@"----%@",responseObj);
        
        if ([[responseObj valueForKey:@"errmsg"] isEqualToString:@"SUCCESS"]) {
            
            self.capcha = [NSString stringWithFormat:@"%@",responseObj[@"root"][@"capcha"]];
            
            [self.view makeToast:@"短信发送成功!" duration:1 position:nil];
        }else{
            
            [self.view makeToast:responseObj[@"errmsg"] duration:1 position:nil];
        }
        
    } failure:^(NSError *error) {
        
        [_activityView stopAnimating];
        [self.view makeToast:@"短信发送失败,网络出错了!" duration:1 position:nil];
        
    }];
    
    //    }else{
    //
    //        [self.view makeToast:@"操作过于频繁，请稍等..." duration:1 position:nil];
    //
    //    }
 
}


-(void)shake:(UIView*)view;
{
    
    self.viewShaker = [[AFViewShaker alloc]initWithView:view];
    [self.viewShaker shake];
    [self.viewShaker shakeWithDuration:0.5 completion:^{
        
    }];
    
}

-(void)loginClick
{
    if (![ZKUtil isMobileNumber:phoneField.text]) {
        [self shake:phonView];
        [self.view makeToast:@"请输入正确的手机号码！" duration:1 position:nil];
        return;
    }
    
    if (identifyingField.text.length !=6 || ![identifyingField.text isEqualToString:self.capcha]) {
        [self shake:identifyingView];
        [self.view makeToast:@"请输入正确的验证码" duration:1 position:nil];
        return;
    }
    
    NSMutableDictionary *para2 = [NSMutableDictionary dictionary];
    para2[@"TimeStamp"] = [ZKUtil timeStamp];
    para2[@"interfaceId"] = @25;
    para2[@"method"] = @"modifyMember";
    para2[@"id"] = [ZKUserInfo sharedZKUserInfo].ID;
    para2[@"phone"] = phoneField.text;
    
    [SVProgressHUD showWithStatus:@"手机号绑定中..."];
    
    [ZKHttp post:ZKPostUrl params:para2 success:^(id responseObj) {
        
        if ([responseObj[@"errmsg"] isEqualToString:@"SUCCESS"]) {
            
            [SVProgressHUD dismiss];
            [SVProgressHUD showSuccessWithStatus:@"绑定成功" duration:1];

            [ZKUserInfo sharedZKUserInfo].mobile = phoneField.text;
            
            [[ZKUserInfo sharedZKUserInfo] saveUserInfo];
            
            if ([self.delegate respondsToSelector:@selector(phoneModifyViewControllerDidModifyPhone:)]) {
                [self.delegate phoneModifyViewControllerDidModifyPhone:self];
            }
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
            
        }else{
            
            [SVProgressHUD dismiss];
            [SVProgressHUD showErrorWithStatus:responseObj[@"errmsg"] duration:1];
            
        }
        
    } failure:^(NSError *error) {
        
           [SVProgressHUD dismiss];
           [SVProgressHUD showErrorWithStatus:@"网络出错" duration:1];
        
    }];
    
}



@end

