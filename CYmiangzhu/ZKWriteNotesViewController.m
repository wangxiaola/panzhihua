//
//  ZKWriteNotesViewController.m
//  CYmiangzhu
//
//  Created by 汤亮 on 15/12/16.
//  Copyright © 2015年 WangXiaoLa. All rights reserved.
//

#import "ZKWriteNotesViewController.h"
#import "ZKCommonImagePickerController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "NBTextView.h"

@interface ZKWriteNotesViewController () <ZKCommonImagePickerControllerDelegate, UIActionSheetDelegate, UITextViewDelegate,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *containerViewTopMargin;
@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UIButton *choosePictureButton;
@property (weak, nonatomic) IBOutlet NBTextView *contentTextView;

@property (nonatomic, strong) ZKCommonImagePickerController *imagePickerController;

@property (nonatomic, strong) UIImage *selectedImage;
@end

@implementation ZKWriteNotesViewController

- (ZKCommonImagePickerController *)imagePickerController
{
    if(_imagePickerController == nil){
        _imagePickerController = [[ZKCommonImagePickerController alloc] init];
        _imagePickerController.imagePickerDelegate = self;
    }
    return _imagePickerController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNav];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTap)];
    [self.view addGestureRecognizer:tap];
}

- (void)setupNav
{
    self.titeLabel.text = @"写游记";
    self.rittBarButtonItem =[[UIButton alloc]initWithFrame:CGRectMake(kDeviceWidth-2-40, 20, 40, 40)];
    self.rittBarButtonItem.backgroundColor =[UIColor clearColor];
    [self.rittBarButtonItem setImage:[UIImage imageNamed:@"hom"] forState:UIControlStateNormal];
    [self.rittBarButtonItem addTarget:self action:@selector(backToHome) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationBarView addSubview:self.rittBarButtonItem];
    
    self.titleTextField.delegate = self;
    self.titleTextField.returnKeyType = UIReturnKeySend;

}

- (void)backToHome
{
    self.tabBarController.selectedIndex = 0;
    [self.navigationController popToRootViewControllerAnimated:NO];
}

- (void)viewTap {
    [self.view endEditing:YES];
}

- (IBAction)choosePictrue {
    [self.view endEditing:YES];
    UIActionSheet *sheet=[[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从相册选择",@"拍照", nil];
    [sheet showInView:[self view]];
}

- (IBAction)commitYouji {
    __block NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"method"] = @"strategySave";
    params[@"memberid"] = [ZKUserInfo sharedZKUserInfo].ID;
    if (self.titleTextField.text.length > 0) {
        params[@"title"] = self.titleTextField.text;
    }
    if (self.contentTextView.text.length > 0) {
        params[@"content"] = self.contentTextView.text;
    }
    if (self.selectedImage != nil) { //有图片上传
        [self uploadImageWithSuccess:^(id response){
            params[@"images"] = response[@"url"];
            [self uploadMyYoujiWithParams:params];
        }];
    }else {
        [self uploadMyYoujiWithParams:params];
    }
}

- (void)uploadImageWithSuccess:(void (^)(id response))success {
    NSData *imageData = UIImageJPEGRepresentation(self.selectedImage, 0.44);
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"method"] = @"uploadFile";
    [SVProgressHUD showWithStatus:@"上传中..."];
    [ZKHttp PostImage:@"" params:params Data:imageData success:^(id responseObj) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObj options:0 error:nil];
        if (success) {
            success(dic);
        }
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"请检查网络连接"];
    }];
}

- (void)uploadMyYoujiWithParams:(NSMutableDictionary *)params {
    [SVProgressHUD showWithStatus:@"上传中..."];
    [ZKHttp Post:@"" params:params success:^(id responseObj) {
        if ([responseObj[@"state"] isEqualToString:@"success"]) {
            [SVProgressHUD showSuccessWithStatus:@"上传成功"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
                if (self.succeedUploadCallback) {
                    self.succeedUploadCallback();
                }
            });
        }else {
            [SVProgressHUD showErrorWithStatus:responseObj[@"msg"]];
        }
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"请检查网络连接"];
    }];
}

#pragma mark - UIActionSheetDelegate
-(void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if(buttonIndex == 2) { return; }
    if(buttonIndex == 0) {
        self.imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }else if(buttonIndex == 1) {
        self.imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    [self presentViewController:self.imagePickerController animated:YES completion:nil];
}

#pragma mark - UIImagePickerControllerDelegate
- (void)PimagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
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
            __unsafe_unretained typeof(self) weakSelf = self;
            ALAssetsLibrary *assetLibrary = [[ALAssetsLibrary alloc] init];
            [assetLibrary assetForURL:url resultBlock:^(ALAsset *asset)  {
                if(asset){
                    ALAssetRepresentation *representation = asset.defaultRepresentation;
                    UIImage *assetImageData = [UIImage imageWithCGImage:representation.fullResolutionImage scale:representation.scale orientation:(UIImageOrientation)representation.orientation];
                    if (assetImageData) {
                        //相册
                        weakSelf.selectedImage = assetImageData;
                    }else{
                        weakSelf.selectedImage = assetImageData;
                    }
                    [weakSelf showSelectedImage];
                }
            } failureBlock:^(NSError *error) {
                return;
            }];
        }else{
            //拍照
            self.selectedImage = image;
            [self showSelectedImage];
        }
    }
}

- (void)showSelectedImage {
    if (self.selectedImage != nil) {
        [self.choosePictureButton setImage:self.selectedImage forState:UIControlStateNormal];
    }
}

- (void)PimagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma  mark - UITextViewDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    
    [textField resignFirstResponder];
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;
{
    if ([string isEqualToString:@"\n"])
    {
        
        [self.view endEditing:YES];
        return NO;
    }
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    self.containerViewTopMargin.constant = -88;
    [UIView animateWithDuration:0.25 animations:^{
        [self.containerView layoutIfNeeded];
    }];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    self.containerViewTopMargin.constant = 66;
    [UIView animateWithDuration:0.25 animations:^{
        [self.containerView layoutIfNeeded];
    }];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    
    if ([text isEqualToString:@"\n"]) {
        [self.view endEditing:YES];
        return NO;
    }
    return YES;
}
- (void)textViewDidChange:(UITextView *)textView
{
    
    [self.contentTextView setNeedsDisplay];
}

@end
