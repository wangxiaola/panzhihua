//
//  ZKComplaintsViewController.m
//  CYmiangzhu
//
//  Created by 王小腊 on 15/12/17.
//  Copyright © 2015年 WangXiaoLa. All rights reserved.
//

#import "ZKComplaintsViewController.h"
#import "ZKTextField.h"
#import "GCPlaceholderTextView.h"
@interface ZKComplaintsViewController ()<UITextViewDelegate,UIKeyboardViewControllerDelegate>
{

    UIView *conterView;
    NSArray *titisArray;
    ZKTextField *phoneField;
    ZKTextField *objectField;
    
    GCPlaceholderTextView *textViewS;

     UILabel *inforlabel;
    
    NSString *str;
}
@end

@implementation ZKComplaintsViewController

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    keyBoardController=[[UIKeyboardViewController alloc] initWithControllerDelegate:self];
    [keyBoardController addToolbarToKeyboard];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter  defaultCenter] removeObserver:self name:@"UITextFieldTextDidChangeNotification" object:objectField];
    
    keyBoardController =nil;
}

-(instancetype)init
{
    self =[super init ];
    if (self) {
        
        self.hidesBottomBarWhenPushed =YES;
    }
    return self;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.titeLabel.text =@"在线投诉";
    self.view.backgroundColor =YJCorl(249, 249, 249);
    [self initView];
    
    str = @"侵权投诉";
}
#pragma mark 初始化视图
-(void)initView
{
    
    UIScrollView *scrollview =[[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, kDeviceWidth, TabelHeghit)];
    scrollview.showsHorizontalScrollIndicator =NO;
    scrollview.showsVerticalScrollIndicator =NO;
    scrollview.pagingEnabled =NO;
    [self.view addSubview:scrollview];
    
    titisArray =@[@"侵权投诉",@"欺诈",@"色情",@"其它"];
    float cellW =44;
    conterView =[[UIView alloc]initWithFrame:CGRectMake(0,2, kDeviceWidth, cellW*4)];
    conterView.backgroundColor =[UIColor whiteColor];
    conterView.layer.borderColor =TabelBackCorl.CGColor;
    conterView.layer.borderWidth =0.5;
    [scrollview addSubview:conterView];
    
    for (int i =0; i<4; i++) {
        
        UIImageView *lefImage =[[UIImageView alloc]initWithFrame:CGRectMake((cellW/2-10), (cellW/2-10)+cellW*i, 20, 20)];
        if (i ==0) {
            
          lefImage.image =[UIImage imageNamed:@"checked"];
        }else{
          lefImage.image =[UIImage imageNamed:@"check"];
        }
        lefImage.tag =2000+i;
        [conterView addSubview:lefImage];
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake((cellW/2-10)*2+20, 10+cellW*i, 200, cellW-20)];
        label.text =titisArray[i];
        label.font =[UIFont systemFontOfSize:13];
        label.textColor =[UIColor grayColor];
        [conterView addSubview:label];
        if (i>0) {
            
            UIView *lin = [[UIView alloc]initWithFrame:CGRectMake((cellW/2-10)*2+20, cellW*i, conterView.frame.size.width-(cellW/2-10)*2-30, 1)];
            lin.backgroundColor =TabelBackCorl;
            [conterView addSubview:lin];
        }
        
        
        UIButton *bty =[[UIButton alloc]initWithFrame:CGRectMake(0, cellW*i, kDeviceWidth, cellW)];
        bty.backgroundColor =[UIColor clearColor];
        [bty addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        bty.tag =3000+i;
        [conterView addSubview:bty];
        
    }

    
    UIView *phoneView =[[UIView alloc]initWithFrame:CGRectMake(0, cellW*4+12, kDeviceWidth, cellW)];
    phoneView.backgroundColor =[UIColor whiteColor];
    phoneView.layer.borderColor =TabelBackCorl.CGColor;
    phoneView.layer.borderWidth =0.5;
    [scrollview addSubview:phoneView];
    
    UIImageView *lefImage =[[UIImageView alloc]initWithFrame:CGRectMake((cellW/2-7), (cellW/2-7), 14, 14)];
    lefImage.image =[UIImage imageNamed:@"message_phone"];
    [phoneView addSubview:lefImage];
    
    UIImageView *ritImage =[[UIImageView alloc]initWithFrame:CGRectMake(kDeviceWidth-20, (cellW/2-6), 8, 12)];
    ritImage.image =[UIImage imageNamed:@"jt_Xright"];
    [phoneView addSubview:ritImage];
    
    UILabel *label_0 = [[UILabel alloc]initWithFrame:CGRectMake((cellW/2-10)*2+20, 10, 100, cellW-20)];
    label_0.text =@"联系电话";
    label_0.font =[UIFont systemFontOfSize:13];
    label_0.textColor =[UIColor grayColor];
    [phoneView addSubview:label_0];
    
    
    phoneField =[[ZKTextField alloc]initWithFrame:CGRectMake(100+(cellW/2-7)*2, 0, phoneView.frame.size.width-(120+(cellW/2-7)*2), cellW)];
    phoneField.backgroundColor =[UIColor whiteColor];
    phoneField.placeholder =@"请填写真实电话";
    NSString *number =[ZKUserInfo sharedZKUserInfo].mobile;
    if (strIsEmpty(number)==0) {
        
        phoneField.text =number;
    }
    phoneField.textAlignment =NSTextAlignmentRight;
    phoneField.font =[UIFont systemFontOfSize:13];
    phoneField.textColor =[UIColor blackColor];
    phoneField.keyboardType =UIKeyboardTypeNumberPad;
    phoneField.returnKeyType =UIReturnKeyDone;
    phoneField.spacing =5;
    [phoneView addSubview:phoneField];
    
    
    UIView *objectView =[[UIView alloc]initWithFrame:CGRectMake(0, phoneView.frame.origin.y+cellW+10, kDeviceWidth, cellW)];
    objectView.backgroundColor =[UIColor whiteColor];
    objectView.layer.borderColor =TabelBackCorl.CGColor;
    objectView.layer.borderWidth =0.5;
    [scrollview addSubview:objectView];
    
    UIImageView *ritImage_0 =[[UIImageView alloc]initWithFrame:CGRectMake(kDeviceWidth-20, (cellW/2-6), 8, 12)];
    ritImage_0.image =[UIImage imageNamed:@"jt_Xright"];
    [objectView addSubview:ritImage_0];
    
    UILabel *label_1 = [[UILabel alloc]initWithFrame:CGRectMake((cellW/2-10), 10, 100, cellW-20)];
    label_1.text =@"投诉对象";
    label_1.font =[UIFont systemFontOfSize:13];
    label_1.textColor =[UIColor grayColor];
    [objectView addSubview:label_1];
    
    
    objectField =[[ZKTextField alloc]initWithFrame:CGRectMake(80+(cellW/2-7)*2, 0, phoneView.frame.size.width-(100+(cellW/2-7)*2), cellW)];
    objectField.backgroundColor =[UIColor whiteColor];
    objectField.placeholder =@"请填写投诉对象";
    objectField.textAlignment =NSTextAlignmentRight;
    objectField.font =[UIFont systemFontOfSize:13];
    objectField.textColor =[UIColor blackColor];
    objectField.keyboardType =UIKeyboardTypeDefault;
    objectField.returnKeyType =UIReturnKeyDone;
    objectField.spacing =5;
    [objectView addSubview:objectField];
    
   [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(limitTextField:) name:@"UITextFieldTextDidChangeNotification" object:objectField];
    
    textViewS =[[GCPlaceholderTextView alloc]initWithFrame:CGRectMake(0, objectView.frame.origin.y+cellW+10, self.view.frame.size.width , 100)];
    textViewS.layer.borderColor =[UIColor colorWithRed:224/255.0 green:224/255.0 blue:224/255.0 alpha:1].CGColor;
    textViewS.layer.borderWidth =0.3;
    textViewS.backgroundColor =[UIColor whiteColor];
    textViewS.font =[UIFont systemFontOfSize:13];
    textViewS.autoresizingMask =UIViewAutoresizingFlexibleHeight;
    textViewS.delegate =self;
    textViewS.textColor =[UIColor blackColor];
    [scrollview addSubview:textViewS];
    
    
    inforlabel =[[UILabel alloc]init];
    inforlabel.frame =CGRectMake(10, 5, self.view.frame.size.width -20, 20);
    inforlabel.text = @"请填写您要投诉的内容，不能超过190个字...";
    inforlabel.font =[UIFont systemFontOfSize:13];
    inforlabel.textColor =TabelBackCorl;
    inforlabel.enabled = NO;
    inforlabel.backgroundColor = [UIColor clearColor];
    [textViewS addSubview:inforlabel];

    UIButton *tsBtton =[[UIButton alloc]initWithFrame:CGRectMake(20, textViewS.frame.origin.y+125, kDeviceWidth-40, 30)];
    tsBtton.layer.masksToBounds =YES;
    tsBtton.layer.cornerRadius =8;
     tsBtton.backgroundColor =YJCorl(48, 192, 163);
    [tsBtton setTitle:@"提交投诉" forState:0];
    tsBtton.titleLabel.font =[UIFont systemFontOfSize:14];
    [tsBtton setTitleColor:[UIColor whiteColor] forState:0];
    [tsBtton addTarget:self action:@selector(tsbuttonClick) forControlEvents:UIControlEventTouchUpInside];
    [scrollview addSubview:tsBtton];
    scrollview.contentOffset =CGPointMake(0, 0);
    scrollview.contentSize =CGSizeMake(kDeviceWidth, cellW*6+30+200+12);
    
}


#pragma mark textfild

- (void)limitTextField:(NSNotification *)note {

     if(objectField.text.length>12) {

        [self.view makeToast:@"投诉对象不能超过12个字。"];

    }

}
- (void)textViewDidChange:(UITextView *)textView;
{
    
    if (textViewS.text.length>190) {
        
        return;
        [self.view makeToast:@"投诉内容不能超过190字。"];
    }
    textViewS.text =  textView.text;
    if (textView.text.length == 0) {
        inforlabel.text = @"请填写您要投诉的内容，不能超过190个字...";
    }else{
        
        inforlabel.text = @"";
    }

}



#pragma mark button
-(void)buttonClick:(UIButton*)sender
{

    NSInteger index = sender.tag -1000;
    
    
    
    if (![str isEqualToString:titisArray[sender.tag-3000]]) {
        
        str =titisArray[sender.tag-3000];

        
        for (UIView*vies in conterView.subviews) {
            
            if ([vies isKindOfClass:[UIImageView class]]) {
                
                 UIImageView *image =(UIImageView*)vies;
                if (vies.tag == index) {
                    
                    [image setImage:[UIImage imageNamed:@"checked"]];
                    
                }else{
                
                   [image setImage:[UIImage imageNamed:@"check"]];
                
                }
                
            }
           
            
        }

        
    }
    
}

-(void)tsbuttonClick
{


    if (![ZKUtil isMobileNumber:phoneField.text]) {
        
        [self.view makeToast:@"请填写真实的电话..."];
        return;
    }
    
    if (objectField.text.length == 0) {
        
        [self.view makeToast:@"请填写投诉对象..."];
        return;
    }
    
    if(objectField.text.length>12) {
        
        [self.view makeToast:@"投诉对象不能超过16个字。"];
        return;
    }
    
    if (textViewS.text.length == 0) {
        
        [self.view makeToast:@"请填写投诉内容..."];
        return;
    }
    
    
       [self postData];
}


#pragma mark  数据请求


/****  请求方式  ******/

-(void)postData;
{
    NSString *typer ;
    if ([str isEqualToString:titisArray[0]]) {
        
        typer =@"complaintType01";
    }else if ([str isEqualToString:titisArray[1]]){
        
       typer =@"complaintType02";
    }else if ([str isEqualToString:titisArray[2]]){
        typer =@"complaintType03";
        
    }else if ([str isEqualToString:titisArray[3]]){
        
       typer =@"complaintType04";
        
    }

    
    NSMutableDictionary *list = [NSMutableDictionary dictionary];
    list[@"method"] = @"messageResouceSave";
    [list setObject:typer forKey:@"complaintType"];
    [list setObject:[ZKUserInfo sharedZKUserInfo].ID forKey:@"memberid"];
    [list setObject:objectField.text forKey:@"complaintObject"];
    [list setObject:phoneField.text forKey:@"phone"];
    [list setObject:textViewS.text forKey:@"content"];
    
    [ZKHttp Post:@"" params:list success:^(id responseObj) {
        
        NSLog(@"%@", responseObj);
        
        NSString *messg =[responseObj valueForKey:@"state"];
        
        if ([messg isEqualToString:@"success"]) {
            if (self.succeedTousu) {
                self.succeedTousu();
            }
            [SVProgressHUD showSuccessWithStatus:@"投诉成功" duration:1.5];
                
            [self.navigationController popViewControllerAnimated:YES];
            
        }else{
        
        [SVProgressHUD showErrorWithStatus:@"投诉失败" duration:1.5];
        }
        
    } failure:^(NSError *error) {

         [SVProgressHUD showErrorWithStatus:@"网络错误..." duration:1.5];
     
        
    }];
    
}

#pragma mark textDelegate
- (void)alttextFieldDidEndEditing:(UITextField *)textField;
{
    NSLog(@"-----");

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
