//
//  ZKEvaluationViewController.m
//  CYmiangzhu
//
//  Created by 王小腊 on 16/1/8.
//  Copyright © 2016年 WangXiaoLa. All rights reserved.
//

#import "ZKEvaluationViewController.h"
#import "CYmiangzhu-Swift.h"

@interface ZKEvaluationViewController ()<UITextViewDelegate,UIKeyboardViewControllerDelegate>
{

    evaluat _evaluat;
    RatingBar *pjRatingBar;
    ZKGoodsOneMode *data;
    UITextView *textViewS;
    UILabel *inforlabel;
}
@property(nonatomic,strong)UILabel *pjPriceLabel;

@end

@implementation ZKEvaluationViewController

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    keyBoardController=[[UIKeyboardViewController alloc] initWithControllerDelegate:self];
    [keyBoardController addToolbarToKeyboard];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    keyBoardController =nil;
}

-(id)initData:(ZKGoodsOneMode*)list;
{
    
    self =[super init];
    
    if (self) {
        
        data =list;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor =YJCorl(250, 250, 250);
    self.titeLabel.text =data.name;
    [self initView];
}


-(void)initView
{
    
    [[BaiduMobStat defaultStat] logEvent:@"btn_go_write_comment" eventLabel:@"去写评论"];
    
   UIView* pingjiaView =[[UIView alloc]initWithFrame:CGRectMake(0, 10+64, kDeviceWidth, 45+160)];
    [self.view addSubview:pingjiaView];
    [self layeBode:pingjiaView];
    
    UIView *pjheaderView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, 45)];
    [self layeBode:pjheaderView];
    [pingjiaView addSubview:pjheaderView];
    
    pjRatingBar = [[RatingBar alloc] init];
    pjRatingBar.frame =CGRectMake(8, 14.5, 140, 16);
    pjRatingBar.isIndicator = NO;
    pjRatingBar.numStars = 5;
    pjRatingBar.ratingMax = 5;
    
    __weak typeof(self)weekSelf =self;
    
    pjRatingBar.rantingCallback = ^(CGFloat rating){
    weekSelf.pjPriceLabel.text =[NSString stringWithFormat:@"%.1f分",rating];
    };
    
    pjRatingBar.rating=data.exponent.floatValue;
    [pjheaderView addSubview:pjRatingBar];
    
    _pjPriceLabel =[[UILabel alloc]initWithFrame:CGRectMake(180, 12.5, 80, 20)];
    _pjPriceLabel.textColor =[UIColor orangeColor];
    _pjPriceLabel.font =[UIFont systemFontOfSize:13];
    _pjPriceLabel.text =[NSString stringWithFormat:@"%.1f分",[data.exponent floatValue]];
    [pjheaderView addSubview:_pjPriceLabel];

    
    textViewS =[[UITextView alloc]initWithFrame:CGRectMake(0, 45+5, self.view.frame.size.width , 155)];
    textViewS.backgroundColor =[UIColor whiteColor];
    textViewS.font =[UIFont systemFontOfSize:13];
    textViewS.autoresizingMask =UIViewAutoresizingFlexibleHeight;
    textViewS.delegate =self;
    textViewS.textColor =[UIColor blackColor];
    [pingjiaView addSubview:textViewS];
    [self layeBode:textViewS];
    
    inforlabel =[[UILabel alloc]init];
    inforlabel.frame =CGRectMake(10, 5, self.view.frame.size.width -20, 20);
    inforlabel.text = @"请填写评价...";
    inforlabel.font =[UIFont systemFontOfSize:13];
    inforlabel.textColor =TabelBackCorl;
    inforlabel.enabled = NO;
    inforlabel.backgroundColor = [UIColor clearColor];
    [textViewS addSubview:inforlabel];
    
    UIButton *tsBtton =[[UIButton alloc]initWithFrame:CGRectMake(20, 300, kDeviceWidth-40, 30)];
    tsBtton.layer.masksToBounds =YES;
    tsBtton.layer.cornerRadius =8;
    tsBtton.backgroundColor =YJCorl(48, 192, 163);
    [tsBtton setTitle:@"提交评价" forState:0];
    tsBtton.titleLabel.font =[UIFont systemFontOfSize:14];
    [tsBtton setTitleColor:[UIColor whiteColor] forState:0];
    [tsBtton addTarget:self action:@selector(tsbuttonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:tsBtton];
    
}


-(void)tsbuttonClick
{

    NSString *str =[textViewS.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    if (str.length ==0) {
        [self.view makeToast:@"请填写评价内容!"];
        return;
    }
    
    if (pjRatingBar.rating==0) {
        [self.view makeToast:@"评价指数不能为零!"];
        return;
        
    }
    
    [[BaiduMobStat defaultStat] logEvent:@"btn_commit_comment" eventLabel:@"提交评论"];
    
    NSString *image =[ZKUserInfo sharedZKUserInfo].photo ;

    [SVProgressHUD showWithStatus:@"提交中"];
    NSMutableDictionary *info = [NSMutableDictionary dictionary];
    [info setObject:data.type forKey:@"type"];
    [info setObject:textViewS.text forKey:@"content"];
    [info setObject:@"commentSave" forKey:@"method"];
    [info setObject:[ZKUserInfo sharedZKUserInfo].ID forKey:@"memberid"];
    [info setObject:data.ID forKey:@"resourceId"];
    if (image) {
       [info setObject:image forKey:@"image"];
    }

    [info setObject:[NSString stringWithFormat:@"%.1f",pjRatingBar.rating] forKey:@"score"];
    
    [ZKHttp Post:@"" params:info success:^(id responseObj) {

        if ([[responseObj valueForKey:@"state"] isEqualToString:@"success"]) {
            [SVProgressHUD dismissWithSuccess:@"评价成功"];
            if (_evaluat) {
                 _evaluat();
            }
           
            [self.navigationController popViewControllerAnimated:YES];
            
        }else{
        
           [SVProgressHUD dismissWithError:@"评价失败"];
        }
        
        
    } failure:^(NSError *error) {
        
       [SVProgressHUD dismissWithError:@"评价失败"];
        
    }];


}

-(void)layeBode:(UIView*)views
{
    views.backgroundColor =[UIColor whiteColor];
    views.layer.borderWidth =0.4;
    views.layer.borderColor =TabelBackCorl.CGColor;
    
}

-(void)succeed:(void(^)())evalual;
{

    _evaluat =evalual;

}

#pragma mark textfild

- (BOOL)textViewShouldEndEditing:(UITextView *)textView;
{
        NSLog(@"2111");
    return YES;
}
- (void)textViewDidEndEditing:(UITextView *)textView;
{

    NSLog(@"0000");
}
- (void)textViewDidChange:(UITextView *)textView;
{
    
    if (textViewS.text.length>190) {
        
        return;
        [self.view makeToast:@"评价内容不能超过40字。"];
    }
    textViewS.text =  textView.text;
    if (textView.text.length == 0) {
        inforlabel.text = @"请填写评价...";
    }else{
        
        inforlabel.text = @"";
    }
    
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
