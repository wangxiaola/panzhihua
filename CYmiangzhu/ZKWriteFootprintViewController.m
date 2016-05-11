//
//  ZKWriteFootprintViewController.m
//  CYmiangzhu
//
//  Created by 汤亮 on 15/12/17.
//  Copyright © 2015年 WangXiaoLa. All rights reserved.
//

#import "ZKWriteFootprintViewController.h"
#import "CustomCalendarViewController.h"
#import "ZKCommonImagePickerController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "ZKFootprintModel.h"

@interface ZKWriteFootprintViewController () <CustomCalendarViewControllerDelegate, UIActionSheetDelegate, ZKCommonImagePickerControllerDelegate>
@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIButton *choosePictureButton;

@property (nonatomic, strong) ZKCommonImagePickerController *imagePickerController;

@property (nonatomic, strong) UIImage *selectedImage;
@property (nonatomic, strong) NSString *selectedDateString;
@end

@implementation ZKWriteFootprintViewController

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
    [self setupDefault];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTap)];
    [self.view addGestureRecognizer:tap];
}

- (void)viewTap {
    [self.view endEditing:YES];
}

- (void)setupNav
{
    self.titeLabel.text = @"写足迹";
    self.rittBarButtonItem =[[UIButton alloc]initWithFrame:CGRectMake(kDeviceWidth-2-40, 20, 40, 40)];
    self.rittBarButtonItem.backgroundColor =[UIColor clearColor];
    [self.rittBarButtonItem setImage:[UIImage imageNamed:@"hom"] forState:UIControlStateNormal];
    [self.rittBarButtonItem addTarget:self action:@selector(backToHome) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationBarView addSubview:self.rittBarButtonItem];
}

- (void)backToHome
{
    self.tabBarController.selectedIndex = 0;
    [self.navigationController popToRootViewControllerAnimated:NO];
}

- (IBAction)choosePictrue {
    [self.view endEditing:YES];
    UIActionSheet *sheet=[[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从相册选择",@"拍照", nil];
    [sheet showInView:[self view]];
}


- (void)setupDefault {
    self.titleTextField.text = self.footprintModel.name;
    [ZKUtil UIButton:self.choosePictureButton NSSting:[NSString stringWithFormat:@"%@%@", imageUrlPrefix, self.footprintModel.img]];
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd";
    NSString *addDateStr = nil;
    if (self.footprintModel != nil) {
        NSDate *addDate = [NSDate dateWithTimeIntervalSince1970:self.footprintModel.date / 1000];
        addDateStr = [fmt stringFromDate:addDate];
    }else {
        addDateStr = [fmt stringFromDate:[NSDate date]];
    }
    self.timeLabel.text = addDateStr;
    self.selectedDateString = addDateStr;
}

- (IBAction)selectDate:(UITapGestureRecognizer *)sender {
    CustomCalendarViewController *datePicker = [[CustomCalendarViewController alloc] init];
    datePicker.delegate = self;
    [self presentViewController:datePicker animated:YES completion:nil];
}

- (IBAction)commitFootprint {
    [self.view endEditing:YES];
    if (self.titleTextField.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请填写标题"];
        return;
    }
    __block NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"method"] = @"saveOrUpdateFootprint";
    params[@"memberid"] = [ZKUserInfo sharedZKUserInfo].ID;
    params[@"title"] = self.titleTextField.text;
    params[@"date"] = self.selectedDateString;
    if (self.footprintModel != nil) {
        params[@"id"] = self.footprintModel.ID;
        params[@"img"] = self.footprintModel.img;
    }
    if (self.selectedImage != nil) { //有图片上传
        [self uploadImageWithSuccess:^(id response){
            params[@"img"] = response[@"url"];
            [self uploadMyZujiWithParams:params];
        }];
    }else {
        [self uploadMyZujiWithParams:params];
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

- (void)uploadMyZujiWithParams:(NSMutableDictionary *)params {
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

#pragma mark - 日期选择的回调
- (void)customCalendarViewController:(CustomCalendarViewController *)customCalendarViewController didSelectedDate:(NSDate *)date
{
    if (date == nil) {
        date = [NSDate date];
    }
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-M-d";
    NSString *dateStr = [fmt stringFromDate:date];
    self.timeLabel.text = dateStr;
    self.selectedDateString = dateStr;
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
                    //相册
                    [weakSelf showSelectedImage:assetImageData];
                }
            } failureBlock:^(NSError *error) {
                return;
            }];
        }else{
            //拍照
            [self showSelectedImage:image];
        }
    }
}

- (void)showSelectedImage:(UIImage *)image {
    if (image != nil) {
        self.selectedImage = image;
        [self.choosePictureButton setImage:image forState:UIControlStateNormal];
    }
}

- (void)PimagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

@end
