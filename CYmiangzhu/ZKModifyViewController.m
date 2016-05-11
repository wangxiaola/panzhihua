//
//  ZKLoginViewController.m
//  weipeng
//
//  Created by Daqsoft-Mac on 15/1/17.
//  Copyright (c) 2015年 WangXiaoLa. All rights reserved.
//

#import "ZKModifyViewController.h"
#import "UIKeyboardView.h"
#import "ZKTextField.h"

#import "ZKMoreReminderView.h"
#import "ZKRegisterViewController.h"

#import "AFViewShaker.h"
@interface ZKModifyViewController ()
{
    
    
    ZKTextField *paswordField;
    
    UIView *pasordView;
    
    ZKTextField *verifyPaswordField;
    
    UIView *verify;
    
    ZKTextField *identifyingField;
    
    UIView *identifyingView;
    
    UIButton *identifyingButton;
    
    NSString *strChange ;
    
    ZKregisterViewController *reg;
    
}

@property (nonatomic, retain) AFViewShaker * viewShaker;



@end

@implementation ZKModifyViewController



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
    self.titeLabel.text =@"找回密码";
    self.view.backgroundColor =TabelBackCorl;
    [self initView];
    
    
    // Do any additional setup after loading the view.
}
//初始化View
-(void)initView
{
    
    [self.rittBarButtonItem removeFromSuperview];
    
    float cellHeight =44;
    UIView * contenView =[[UIView alloc]initWithFrame:CGRectMake(0,navigationHeghit, self.view.frame.size.width, cellHeight*3+30)];
    contenView.backgroundColor =[UIColor clearColor];
    [self.view addSubview:contenView];

    
    identifyingView =[[UIView alloc]initWithFrame:CGRectMake(10, cellHeight*0+10, contenView.frame.size.width-20, cellHeight)];
    identifyingView.backgroundColor =[UIColor whiteColor];
    identifyingView.layer.borderColor =TabelBackCorl.CGColor;
    identifyingView.layer.borderWidth =0.5;
    identifyingView.layer.cornerRadius =4;
    [contenView addSubview:identifyingView];
    
    identifyingField =[[ZKTextField alloc]initWithFrame:CGRectMake(0, 0, contenView.frame.size.width-20, cellHeight)];
    identifyingField.backgroundColor =[UIColor clearColor];
    identifyingField.placeholder =@"当前密码";
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
    identifyingField.secureTextEntry = YES;
    identifyingField.spacing =10;
    [identifyingView addSubview:identifyingField];
    
    pasordView =[[UIView alloc]initWithFrame:CGRectMake(10, cellHeight*1+20, contenView.frame.size.width-20, cellHeight)];
    pasordView.backgroundColor =[UIColor whiteColor];
    pasordView.layer.borderColor =TabelBackCorl.CGColor;
    pasordView.layer.borderWidth =0.5;
    pasordView.layer.cornerRadius =4;
    [contenView addSubview:pasordView];
    
    paswordField =[[ZKTextField alloc]initWithFrame:CGRectMake(0,0, contenView.frame.size.width-20, cellHeight)];
    paswordField.backgroundColor =[UIColor clearColor];
    paswordField.placeholder =@"新密码";
    paswordField.textColor =[UIColor blackColor];
    paswordField.font =[UIFont systemFontOfSize:14];
    //输入框中叉号编辑时出现
    paswordField.clearButtonMode =UITextFieldViewModeWhileEditing;
    //再次编辑就清空
    paswordField.clearsOnBeginEditing =YES;
    paswordField.textAlignment =NSTextAlignmentLeft;
    paswordField.keyboardType =UIKeyboardTypeASCIICapable;
    paswordField.returnKeyType =UIReturnKeyDone;
    //每输入一个字符就变成点 用语密码输入
    paswordField.secureTextEntry = YES;
    paswordField.spacing =10;
    [pasordView addSubview:paswordField];
    
    
    verify =[[UIView alloc]initWithFrame:CGRectMake(10, cellHeight*2+30, contenView.frame.size.width-20, cellHeight)];
    verify.backgroundColor =[UIColor whiteColor];
    verify.layer.borderColor =TabelBackCorl.CGColor;
    verify.layer.borderWidth =0.5;
    verify.layer.cornerRadius =4;
    [contenView addSubview:verify];
    
    verifyPaswordField =[[ZKTextField alloc]initWithFrame:CGRectMake(0, 0, contenView.frame.size.width-20, cellHeight)];
    verifyPaswordField.backgroundColor =[UIColor clearColor];
    verifyPaswordField.placeholder =@"确认新密码";
    verifyPaswordField.textColor =[UIColor blackColor];
    //输入框中叉号编辑时出现
    verifyPaswordField.font =[UIFont systemFontOfSize:14];
    verifyPaswordField.clearButtonMode =UITextFieldViewModeWhileEditing;
    //再次编辑就清空
    verifyPaswordField.clearsOnBeginEditing =YES;
    verifyPaswordField.textAlignment =NSTextAlignmentLeft;
    verifyPaswordField.keyboardType =UIKeyboardTypeASCIICapable;
    verifyPaswordField.returnKeyType =UIReturnKeyDone;
    //每输入一个字符就变成点 用语密码输入
    verifyPaswordField.secureTextEntry = YES;
    verifyPaswordField.spacing =10;
    [verify addSubview:verifyPaswordField];
    
    
    UIButton *loginButton =[[UIButton alloc]initWithFrame:CGRectMake(10,20+contenView.frame.size.height+navigationHeghit, self.view.frame.size.width-20, cellHeight)];
    loginButton.backgroundColor =CYBColorGreen;
    [loginButton setTitle:@"确认提交" forState:UIControlStateNormal];
    [loginButton setBackgroundImage:[UIImage imageNamed:@"enroll_1"] forState:UIControlStateNormal];
    [loginButton setBackgroundImage:[UIImage imageNamed:@"enroll_0"] forState:UIControlStateHighlighted];
    loginButton.titleLabel.font =[UIFont boldSystemFontOfSize:18];
    [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [loginButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [loginButton addTarget:self action:@selector(loginClick) forControlEvents:UIControlEventTouchUpInside];
    loginButton.layer.cornerRadius =4;
    [self.view addSubview:loginButton];
    
}
#pragma mark 点击事件

-(void)shake:(UIView*)view;
{
    
    self.viewShaker = [[AFViewShaker alloc]initWithView:view];
    [self.viewShaker shake];
    [self.viewShaker shakeWithDuration:0.5 completion:^{
        
    }];
    
}

-(void)loginClick
{
    
    if (identifyingField.text.length==0) {
        [self shake:identifyingView];
        return;
    }
    
    if (paswordField.text.length==0) {
        [self shake:pasordView];
        return;
    }
    
    if (verifyPaswordField.text.length==0) {
        
        [self shake:verify];
        return;
    }
    
    if (![ZKUtil character:paswordField.text]) {
        [self shake:pasordView];
        [self.view makeToast:@"亲，密码必须以字母开头！" duration:1 position:nil];
        return;
    }
    
    if ([paswordField.text length]<=5) {
        [self shake:pasordView];
        [self.view makeToast:@"密码必须大于6位!" duration:1 position:nil];
        return;
    }
    
    if ([paswordField.text isEqualToString:identifyingField.text]) {
        [self.view makeToast:@"新密码不能和旧密码一样"];
        return;
    }
 
    if (![verifyPaswordField.text isEqualToString:paswordField.text]) {
        [self.view makeToast:@"2次输入不一样！"];
        return;
    }
    
    if (![identifyingField.text isEqualToString:[ZKUserInfo sharedZKUserInfo].password]) {
        [self.view makeToast:@"原密码错误！"];
        return;
    }

    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    para[@"TimeStamp"] = [ZKUtil timeStamp];
    para[@"interfaceId"] = @24;
    para[@"method"] = @"modifyPwd";
    para[@"id"] = [ZKUserInfo sharedZKUserInfo].ID;
    para[@"password"] =paswordField.text;
    
    [SVProgressHUD showWithStatus:@"密码修改中..."];
    
    [ZKHttp post:ZKPostUrl params:para success:^(id responseObj) {
        
        [SVProgressHUD dismiss];
        
        if ([responseObj[@"errmsg"] isEqualToString:@"SUCCESS"]) {
            
            [ZKUserInfo sharedZKUserInfo].password = paswordField.text;
            
            [[ZKUserInfo sharedZKUserInfo] saveUserInfo];
            
            [SVProgressHUD showSuccessWithStatus:@"修改密码成功" duration:1];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }else{
        
            [SVProgressHUD showErrorWithStatus:responseObj[@"errmsg"] duration:1];
        }
        
    } failure:^(NSError *error) {
        
        [SVProgressHUD showErrorWithStatus:@"网络出错了" duration:1];
    }];

}



@end
