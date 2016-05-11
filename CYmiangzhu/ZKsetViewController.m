//
//  ZKsetViewController.m
//  CYmiangzhu
//
//  Created by Daqsoft-Mac on 15/8/14.
//  Copyright (c) 2015年 WangXiaoLa. All rights reserved.
//

#import "ZKsetViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "ZKTextField.h"
#import "ZKCommonImagePickerController.h"
#import "ZKModifyViewController.h"
#import "ZKPhoneModifyViewController.h"
#import "ZKregisterViewController.h"
#import "ZKMapViewController.h"
#import <ShareSDK/ShareSDK.h>
#import "ZKMoreReminderView.h"

#define iPhone4 [UIScreen mainScreen].bounds.size.height == 480

@interface ZKsetViewController ()<UITextFieldDelegate,UIActionSheetDelegate,ZKCommonImagePickerControllerDelegate,UIPickerViewDataSource, UIPickerViewDelegate,ZKMapDelegate,ZKPhoneModifyViewControllerDelegate>

{
    UIImage *skMage;
    
    UIImageView *hedarImage;
    
    ZKTextField *nameText;
    
    ZKTextField *sexText;
    
    ZKTextField *adderText;
    
    ZKTextField  *phonetext;
    
    ZKCommonImagePickerController *imagePickerController;
    
    
}

//性别选择键盘
@property (nonatomic, strong) UIPickerView *sexPicker;
@property (nonatomic, strong)NSArray *sexArray;

//@property (nonatomic, strong)ZKPhoneModifyViewController *pmvc;

//显示地址的label
@property (weak, nonatomic)UILabel *regionLabel;
@end

@implementation ZKsetViewController

//- (ZKPhoneModifyViewController *)pmvc
//{
//    if (_pmvc == nil) {
//        _pmvc = [[ZKPhoneModifyViewController alloc] init];
//    }
//    return _pmvc;
//}

- (NSArray *)sexArray
{
    if (_sexArray == nil) {
        _sexArray = @[@"男", @"女"];
    }
   
    return _sexArray;
}

- (UIPickerView *)sexPicker
{
    if (_sexPicker == nil) {
        _sexPicker = [[UIPickerView alloc] init];
        _sexPicker.delegate = self;
        _sexPicker.dataSource = self;
    }
    return _sexPicker;
}


-(id)init
{
    
    self =[super init];
    
    if (self) {
        self.hidesBottomBarWhenPushed =YES;
    }
    return self;
}


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
    self.titeLabel.text =@"设置";
    
    
    UIButton*retButton =[[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width-4-40, 20, 40, 40)];
    retButton.backgroundColor =[UIColor clearColor];
    [retButton setTitle:@"提交" forState:UIControlStateNormal];
    [retButton setTitleColor:CYBColorGreen forState:UIControlStateNormal];
    retButton.titleLabel.font =[UIFont systemFontOfSize:14];
    retButton.titleLabel.font =[UIFont boldSystemFontOfSize:14];
    [retButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [retButton addTarget:self action:@selector(submit) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationBarView addSubview:retButton];
    
    
    [self initView];
    [self postData];
    
    // Do any additional setup after loading the view.
}

#pragma mark 视图布局

-(void)initView
{
    float margin = 5.0;
    float cellHeghit =44.0;
    float contSviewH = 70;
    if(iPhone4){
        contSviewH = 80;
        cellHeghit = 40;
        margin = 10;
    }
    
    UIView*contSview =[[UIView alloc]initWithFrame:CGRectMake(0,navigationHeghit+10,self.view.frame.size.width, cellHeghit*4+contSviewH)];
    
    contSview.backgroundColor =[UIColor whiteColor];
    contSview.userInteractionEnabled =YES;
    [self.view addSubview:contSview];
    
    
    UIView*contXview =[[UIView alloc]initWithFrame:CGRectMake(0,navigationHeghit+25+contSview.frame.size.height,self.view.frame.size.width, cellHeghit*2)];
    contXview.backgroundColor =[UIColor whiteColor];
    contXview.userInteractionEnabled =YES;
    [self.view addSubview:contXview];
    
    
    UILabel *label =[[UILabel alloc]initWithFrame:CGRectMake(5, 18, 100, 34)];
    label.textAlignment =NSTextAlignmentLeft;
    label.font =[UIFont systemFontOfSize:15];
    label.textColor =[UIColor grayColor];
    label.text =@"头像";
    [contSview addSubview:label];
    
    
    hedarImage =[[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width -60, 10, 50, 50)];
    hedarImage.layer.cornerRadius =4;
    hedarImage.layer.masksToBounds =YES;
    
    //占位头像
    hedarImage.image =[UIImage imageNamed:@"set_zhaoping"];
    //先从本地获取图片
    UIImage * headImage = [ZKUtil fetchImage:[ZKUserInfo sharedZKUserInfo].ID];
    if (headImage) {
        hedarImage.image = headImage;
    }else{  //如果本地没有则而同时用户信息中头像数据不为空，则从网络加载图片
        if ([ZKUserInfo sharedZKUserInfo].photo != nil) {
            [ZKUtil UIimageView:hedarImage NSSting:[ZKUserInfo sharedZKUserInfo].photo duImage:@"set_zhaoping"];
        }
    }

    [contSview addSubview:hedarImage];
    
    UIButton *headrButton =[[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width -75, 1, 70, 68)];
    headrButton.backgroundColor =[UIColor clearColor];
    [headrButton addTarget:self action:@selector(headrClick) forControlEvents:UIControlEventTouchUpInside];
    [contSview addSubview:headrButton];
    
    
    NSArray *titisArray =@[@"昵称",@"性别",@"地址",@"",@"登录密码",@"绑定的手机"];
    
    for (int i=0; i<6; i++) {
        
        
        if (i<4) {
            
            UIView *lin_s =[[UIView alloc]initWithFrame:CGRectMake(5, 70+44*i, self.view.frame.size.width-5, 0.5)];
            lin_s.backgroundColor =TabelBackCorl;
            [contSview addSubview:lin_s];
        
            UILabel *label = nil;
            if (i !=3 ) {
                label =[[UILabel alloc]initWithFrame:CGRectMake(5, 70+44*i+5, 50, 34)];
                label.textAlignment =NSTextAlignmentLeft;
                label.textColor =[UIColor grayColor];
                label.font =[UIFont systemFontOfSize:15];
                label.text =titisArray[i];
                
                UIImageView *ritImage =[[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width -15, 70+44*i+15, 7, 14)];
                ritImage.image =[UIImage imageNamed:@"jt_Xright"];
                [contSview addSubview:ritImage];
            }else{
            
               label =[[UILabel alloc]initWithFrame:CGRectMake(0, 70+cellHeghit*i+margin, contSview.bounds.size.width-12, 34)];
                label.textAlignment =NSTextAlignmentRight;
                label.textColor =[UIColor orangeColor];
                label.font =[UIFont systemFontOfSize:12];
                label.text = @"点击获取位置信息";
                self.regionLabel = label;
                
                
                UIButton *regionSelect = [[UIButton alloc] initWithFrame:CGRectMake(0, 70+44*i+5, contSview.bounds.size.width, 34)];
                [regionSelect addTarget:self action:@selector(regionSelected) forControlEvents:UIControlEventTouchUpInside];
                
                regionSelect.backgroundColor = [UIColor clearColor];
                [contSview addSubview:regionSelect];
            }
            
            
            [contSview addSubview:label];
            
        }else{
            
            
            UIView *lin_s =[[UIView alloc]initWithFrame:CGRectMake(5, 44+44*(i-4), self.view.frame.size.width-5, 0.5)];
            lin_s.backgroundColor =TabelBackCorl;
            [contXview addSubview:lin_s];
            
            UILabel *label =[[UILabel alloc]initWithFrame:CGRectMake(5, 44*(i-4)+5, 100, 34)];
            label.textAlignment =NSTextAlignmentLeft;
            label.font =[UIFont systemFontOfSize:15];
            label.textColor =[UIColor grayColor];
            label.text =titisArray[i];
            [contXview addSubview:label];
            
            UIImageView *ritImage =[[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width -15, 44*(i-4)+15, 7, 14)];
            ritImage.image =[UIImage imageNamed:@"jt_Xright"];
            [contXview addSubview:ritImage];
            
            
        }
        
        
        
        
    }
    
    
    UIButton *tcButton =[[UIButton alloc]initWithFrame:CGRectMake(10, navigationHeghit+40+contSview.frame.size.height+contXview.frame.size.height, self.view.frame.size.width-20, 46)];
    tcButton.layer.cornerRadius =4;
    tcButton.backgroundColor =CYBColorGreen;
    [tcButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [tcButton addTarget:self action:@selector(tcClick) forControlEvents:UIControlEventTouchUpInside];
    tcButton.titleLabel.textAlignment =NSTextAlignmentCenter;
    [tcButton setTitle:@"退出账号" forState:UIControlStateNormal];
    tcButton.titleLabel.font =[UIFont systemFontOfSize:15];
    [self.view addSubview:tcButton];
    
    
    
    nameText =[[ZKTextField alloc]initWithFrame:CGRectMake(50, 75, self.view.frame.size.width-70, cellHeghit-10)];
    nameText.backgroundColor =[UIColor clearColor];
    nameText.placeholder =@"请输入昵称";
    nameText.text = [ZKUserInfo sharedZKUserInfo].name;
    nameText.delegate =self;
    nameText.textColor =YJCorl(104, 104, 104);
    //输入框中叉号编辑时出现
    nameText.font =[UIFont systemFontOfSize:14];
    //    nameText.clearButtonMode =UITextFieldViewModeWhileEditing;
    //再次编辑就清空
    nameText.clearsOnBeginEditing =NO;
    nameText.textAlignment =NSTextAlignmentRight;
    nameText.keyboardType =UIKeyboardTypeDefault;
    nameText.returnKeyType =UIReturnKeyDone;
    nameText.spacing =5;
    [contSview addSubview:nameText];
    
    
    sexText =[[ZKTextField alloc]initWithFrame:CGRectMake(50, 75+44, self.view.frame.size.width-70, cellHeghit-10)];
    sexText.backgroundColor =[UIColor clearColor];
    sexText.placeholder =@"请填写性别";
    sexText.text = [[ZKUserInfo sharedZKUserInfo].sex isEqualToString:@"0"] ? @"男" : @"女";
    sexText.textColor =YJCorl(104, 104, 104);
    //输入框中叉号编辑时出现
    sexText.delegate =self;
    sexText.font =[UIFont systemFontOfSize:14];
    //    sexText.clearButtonMode =UITextFieldViewModeWhileEditing;
    //再次编辑就清空
    //    sexText.clearsOnBeginEditing =NO;
    sexText.textAlignment =NSTextAlignmentRight;
    sexText.keyboardType =UIKeyboardTypeDefault;
    sexText.returnKeyType =UIReturnKeyDone;
    //每输入一个字符就变成点 用语密码输入
    sexText.inputView = self.sexPicker;
    sexText.secureTextEntry = NO;
    sexText.spacing =5;
    [contSview addSubview:sexText];
    
    
    
    adderText =[[ZKTextField alloc]initWithFrame:CGRectMake(50, 75+88, self.view.frame.size.width-70, cellHeghit-10)];
    adderText.backgroundColor =[UIColor clearColor];
    adderText.placeholder =@"请输入地址";
    adderText.text = [ZKUserInfo sharedZKUserInfo].address;
    adderText.textColor =YJCorl(104, 104, 104);
    //输入框中叉号编辑时出现
    adderText.font =[UIFont systemFontOfSize:14];
    adderText.delegate =self;
    //    adderText.clearButtonMode =UITextFieldViewModeWhileEditing;
    //再次编辑就清空
    //    adderText.clearsOnBeginEditing =NO;
    adderText.textAlignment =NSTextAlignmentRight;
    //每输入一个字符就变成点 用语密码输入
    adderText.secureTextEntry = NO;
    adderText.spacing =5;
    [contSview addSubview:adderText];
    
    UILabel *dlLabel =[[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width-100, 12, 75, 20)];
    dlLabel.textAlignment =NSTextAlignmentRight;
    dlLabel.font =[UIFont systemFontOfSize:14];
    dlLabel.textColor =YJCorl(201, 201, 201);
    dlLabel.text =@"修改";
    [contXview addSubview:dlLabel];
    
    UIButton *ritSeled =[[UIButton alloc]initWithFrame:CGRectMake(50, 0, self.view.frame.size.width-60, cellHeghit)];
    ritSeled.backgroundColor =[UIColor clearColor];
    [ritSeled addTarget:self action:@selector(ritSeledClick) forControlEvents:UIControlEventTouchUpInside];
    [contXview addSubview:ritSeled];
    
    
    phonetext =[[ZKTextField alloc]initWithFrame:CGRectMake(100, cellHeghit+5, self.view.frame.size.width-150, cellHeghit-10)];
    phonetext.backgroundColor =[UIColor clearColor];
    phonetext.placeholder =[self zhuangStr:[ZKUserInfo sharedZKUserInfo].mobile];
//    phonetext.text = ;
    phonetext.delegate =self;
    phonetext.enabled = NO;
    phonetext.textColor =YJCorl(104, 104, 104);
    //输入框中叉号编辑时出现
    phonetext.font =[UIFont systemFontOfSize:14];
    //    nameText.clearButtonMode =UITextFieldViewModeWhileEditing;
    //再次编辑就清空
    phonetext.clearsOnBeginEditing =YES;
    phonetext.textAlignment =NSTextAlignmentLeft;
    phonetext.keyboardType =UIKeyboardTypeNumberPad;
    phonetext.returnKeyType =UIReturnKeyDone;
    phonetext.spacing =5;
    [contXview addSubview:phonetext];
    
    UILabel *phoneLabel =[[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width-100, cellHeghit+12, 75, 20)];
    phoneLabel.textAlignment =NSTextAlignmentRight;
    phoneLabel.font =[UIFont systemFontOfSize:14];
    phoneLabel.textColor =YJCorl(201, 201, 201);
    phoneLabel.text =@"修改";
    [contXview addSubview:phoneLabel];
    
    UIButton *phoneXiugai =[[UIButton alloc]initWithFrame:CGRectMake(60, cellHeghit, self.view.frame.size.width-70, cellHeghit)];
    phoneXiugai.backgroundColor =[UIColor clearColor];
    [phoneXiugai addTarget:self action:@selector(xiugaiPhone) forControlEvents:UIControlEventTouchUpInside];
    [contXview addSubview:phoneXiugai];
    
    UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped)];
    
    [self.view addGestureRecognizer:tapGr];
    
}
/**
 *  中间转**
 *
 *  @param t 被转字
 *
 *  @return 返回数
 */
-(NSString*)zhuangStr:(NSString*)t;
{
    if (![ZKUtil isMobileNumber:t]) {
        return @"";
    }
    
    NSMutableString *str =[[NSMutableString alloc]initWithString:t];
    [str replaceCharactersInRange:NSMakeRange(3, 5) withString:@"*****"];
    NSString *pc =[NSString stringWithFormat:@"%@",str];

    return pc;
}

#pragma mark 数据请求

-(void)postData
{
    
    
    
}

#pragma mark 数据更新
-(void)updataView

{



}
#pragma mark 点击事件
/**
 *  提交
 */
-(void)submit
{
    
    [[BaiduMobStat defaultStat] logEvent:@"update_person_info" eventLabel:@"会员修改个人信息"];
    NSData *imageData = UIImageJPEGRepresentation(skMage, 0.6);
  
    if (imageData !=nil) { //有图片上传
        NSMutableDictionary *para1 = [NSMutableDictionary dictionary];
        para1[@"TimeStamp"] = [ZKUtil timeStamp];
        para1[@"interfaceId"] = @14;
        
        [SVProgressHUD showWithStatus:@"保存中"];
        
        [ZKHttp postImage:ZKPostImageUrl params:para1 Data:imageData success:^(id responseObj) {
            
          if ([responseObj[@"errmsg"] isEqualToString:@"上传成功!"]) {
            
            NSMutableDictionary *para2 = [NSMutableDictionary dictionary];
            para2[@"TimeStamp"] = [ZKUtil timeStamp];
            para2[@"interfaceId"] = @25;
            para2[@"method"] = @"modifyMember";
            para2[@"id"] = [ZKUserInfo sharedZKUserInfo].ID;
            para2[@"name"] = nameText.text;
            para2[@"address"] = adderText.text;
            para2[@"sex"] = [sexText.text isEqualToString:@"男"]? @"0" : @"1";
            para2[@"photo"] = responseObj[@"data"];
            
            [ZKHttp post:ZKPostUrl params:para2 success:^(id responseObj) {
                
                [SVProgressHUD dismiss];
                
                if ([responseObj[@"errmsg"] isEqualToString:@"SUCCESS"]) {
                    
                    [SVProgressHUD showSuccessWithStatus:@"保存成功" duration:1];
                    [ZKUserInfo sharedZKUserInfo].name = nameText.text;
                    [ZKUserInfo sharedZKUserInfo].sex = [sexText.text isEqualToString:@"男"]? @"0" : @"1";
                    [ZKUserInfo sharedZKUserInfo].address = adderText.text;
                    [ZKUserInfo sharedZKUserInfo].photo = para2[@"photo"];
                    
                    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[ZKUserInfo sharedZKUserInfo].userMessage];
                    dic[@"photo"] = [ZKUserInfo sharedZKUserInfo].photo;
                    [ZKUserInfo sharedZKUserInfo].userMessage = dic;
                    
                    [[ZKUserInfo sharedZKUserInfo] saveUserInfo];
                    
                    
                    //保存图片到本地
                    [ZKUtil setPhotoToPath:UIImagePNGRepresentation(skMage) isName:[ZKUserInfo sharedZKUserInfo].ID];
                    
                    if ([self.delegate respondsToSelector:@selector(setViewControllerDidOperaton:)]) {
                        [self.delegate setViewControllerDidOperaton:ZKsetOperationSaveUserInfo];
                    }
                    
                    skMage = nil;

                }else{
                    
                    [SVProgressHUD showErrorWithStatus:responseObj[@"errmsg"] duration:1];
    
                }
                
            } failure:^(NSError *error) {
                [SVProgressHUD dismiss];
                [SVProgressHUD showErrorWithStatus:@"网络出错" duration:1];
                
            }];
            
          }else {
              
              [SVProgressHUD dismiss];
              [SVProgressHUD showErrorWithStatus:@"保存失败" duration:1];
            
          }
            
        } failure:^(NSError *error) {
            [SVProgressHUD dismiss];
            [SVProgressHUD showErrorWithStatus:@"网络出错" duration:1];
            
        }];
            
    

    }else{ //无图片上传
        
        NSMutableDictionary *para2 = [NSMutableDictionary dictionary];
        para2[@"TimeStamp"] = [ZKUtil timeStamp];
        para2[@"interfaceId"] = @25;
        para2[@"method"] = @"modifyMember";
        para2[@"id"] = [ZKUserInfo sharedZKUserInfo].ID;
        para2[@"name"] = nameText.text;
        para2[@"address"] = adderText.text;
        para2[@"sex"] = [sexText.text isEqualToString:@"男"]? @"0" : @"1";
        
        [ZKHttp post:ZKPostUrl params:para2 success:^(id responseObj) {
            
            
            
            
            if ([responseObj[@"errmsg"] isEqualToString:@"SUCCESS"]) {
                
                [SVProgressHUD dismiss];
                [SVProgressHUD showSuccessWithStatus:@"保存成功" duration:1];
                [ZKUserInfo sharedZKUserInfo].name = nameText.text;
                [ZKUserInfo sharedZKUserInfo].sex = [sexText.text isEqualToString:@"男"]? @"0" : @"1";
                [ZKUserInfo sharedZKUserInfo].address = adderText.text;
                [[ZKUserInfo sharedZKUserInfo] saveUserInfo];
                
                if ([self.delegate respondsToSelector:@selector(setViewControllerDidOperaton:)]) {
                    [self.delegate setViewControllerDidOperaton:ZKsetOperationSaveUserInfo];
                }
                
            }else{
                
                [SVProgressHUD dismiss];
                [SVProgressHUD showErrorWithStatus:responseObj[@"errmsg"] duration:1];
                
            }
            
        } failure:^(NSError *error) {
            
            
            
            
            [SVProgressHUD dismiss];
            [SVProgressHUD showErrorWithStatus:@"网络出错" duration:1];
            
        }];
    }

}

/**
 *  头像点击
 */
-(void)headrClick
{

    
    UIActionSheet *sheet=[[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从相册选择",@"拍照", nil];
    [sheet showInView:[self view]];
    
}
/**
 *  退出点击
 */
-(void)tcClick
{
    [[ZKUserInfo sharedZKUserInfo] resetUserInfo];
    popLoginCount = 0;
    
    ZKMoreReminderView *more =[[ZKMoreReminderView alloc]initTs:@" 温馨提示" MarkedWords:@"亲。真的要退出当前账号吗？"];
    [more show];
    
    [more  sectec:^(int pgx) {
        
        if (pgx ==1) {
            
            [[ZKUserInfo sharedZKUserInfo] resetUserInfo];
            
            if ([ShareSDK hasAuthorizedWithType:ShareTypeQQSpace]) {
                [ShareSDK cancelAuthWithType:ShareTypeQQSpace];
            }
            
            if ([ShareSDK hasAuthorizedWithType:ShareTypeWeixiSession]) {
                [ShareSDK cancelAuthWithType:ShareTypeWeixiSession];
            }
            
            if ([ShareSDK hasAuthorizedWithType:ShareTypeSinaWeibo]) {
                [ShareSDK cancelAuthWithType:ShareTypeSinaWeibo];
            }
            
            if ([self.delegate respondsToSelector:@selector(setViewControllerDidOperaton:)]) {
                [self.delegate setViewControllerDidOperaton:ZKsetOperationCancelAuth];
            }
            
            [self.navigationController popViewControllerAnimated:YES];
            
        }
    }];
    
    

    
    
}
/**
 *  修改密码点击
 *
 *  @param sender
 */
-(void)ritSeledClick{
   
    if ([ZKUserInfo sharedZKUserInfo].isLogined == YES) {
        
        ZKModifyViewController *mod =[[ZKModifyViewController alloc]init];

        [self.navigationController pushViewController:mod animated:YES];
        
        
    }else{
    
        [self.view makeToast:@"请先登录"];
    
    }
}

/**
 *  修改电话点击
 *
 *  @param sender
 */
- (void)xiugaiPhone
{
    
    if ([ZKUserInfo sharedZKUserInfo].isLogined == YES) {
        
        ZKPhoneModifyViewController *pmvc = [[ZKPhoneModifyViewController alloc] init];
        pmvc.delegate = self;
        [self.navigationController pushViewController:pmvc animated:YES];
    }else{
        
        [self.view makeToast:@"请先登录"];
        
    }
}

/**
 *  修改地址点击
 *
 *  @param sender
 */
- (void)regionSelected
{
    ZKMapViewController *regionMap = [[ZKMapViewController alloc] init];
    regionMap.delegate = self;
    [self.navigationController pushViewController:regionMap animated:YES];
}

- (void)site:(NSString *)loc Lon:(NSString *)lon Lat:(NSString *)lat
{
//    self.regionLabel.text = loc;
    adderText.text = loc;

}

/**
 *  屏幕点击
 */
-(void)viewTapped
{
    
    [nameText resignFirstResponder];
    [phonetext resignFirstResponder];
    
}

#pragma mark - ZKPhoneModifyViewControllerDelegate
- (void)phoneModifyViewControllerDidModifyPhone:(ZKPhoneModifyViewController *)phoneModifyViewController
{
   phonetext.placeholder =[self zhuangStr:[ZKUserInfo sharedZKUserInfo].mobile];
}

#pragma mark - textfilddelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField;
{
    
    
    [textField resignFirstResponder];
    
    return YES;
}



#pragma mark UIImagePickerControllerDelegate
-(void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex{
    
    
    if(buttonIndex == 2){
        return;
    }
    if(imagePickerController == nil){
        imagePickerController = [[ZKCommonImagePickerController alloc] init];
        imagePickerController.imagePickerDelegate = self;
        
    }
    if(buttonIndex == 0){
        imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }else if(buttonIndex == 1){
        imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    [self presentViewController:imagePickerController animated:YES completion:nil];
}


- (void)PimagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info;
{
    
    NSLog(@"info-------%@",info);
    
    @autoreleasepool {
        [self dismissViewControllerAnimated:YES completion:nil];
        
        UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
        if(!image){
            image = [info objectForKey:UIImagePickerControllerOriginalImage];
        }
        if(!image){
            return;
        }
        
        NSURL *url = [info objectForKey:UIImagePickerControllerReferenceURL];
        
        //添加选择的图片
        if(url){
            ALAssetsLibrary *assetLibrary = [[ALAssetsLibrary alloc] init];
            [assetLibrary assetForURL:url resultBlock:^(ALAsset *asset)  {
                if(asset){
                    ALAssetRepresentation *representation = asset.defaultRepresentation;
                    UIImage *assetImageData = [UIImage imageWithCGImage:representation.fullResolutionImage scale:representation.scale orientation:(UIImageOrientation)representation.orientation];
                    
                    if (assetImageData) {
                        //相册
                        skMage =[UIImage imageWithCGImage:asset.thumbnail];
  
                        
                    }else{
                        
                        skMage =[UIImage imageWithCGImage:asset.thumbnail];
                        
                    }
                    
                      [self addDataImage];
                }
                
            } failureBlock:^(NSError *error) {
                
            }];
        }else{
            //拍照
            skMage =[image imageByScalingAndCroppingForSize:CGSizeMake(157, 157)];
            [self addDataImage];
            
        }
    }
}

//保存图片
-(void)addDataImage
{
    hedarImage.image =skMage;

}


- (void)PimagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}



#pragma mark - UIPickViewDelegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.sexArray.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    
    return self.sexArray[row];
    
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    sexText.text = self.sexArray[row];
}
@end
