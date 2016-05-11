//
//  YYCommonImagePickerController.m
//  mocha
//
//  Created by demo on 13-12-17.
//  Copyright (c) 2013年 yunyao. All rights reserved.
//

#import "ZKCommonImagePickerController.h"
#import "UIBarButtonItem+YY.h"
@interface ZKCommonImagePickerController ()
{
    UIBarButtonItem *cancelItem;
    UIBarButtonItem *backItem;
}
@end

@implementation ZKCommonImagePickerController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationBar.barTintColor = CYBColorGreen;
    
    [[UINavigationBar appearance] setShadowImage:[[UIImage alloc] init]];
    
    if (self.sourceType==UIImagePickerControllerSourceTypeCamera)   // iOS7+ only
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        
        [self prefersStatusBarHidden];
        [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
    }
    
    UIButton *cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 22)];
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    cancelButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    cancelButton.layer.borderWidth = 0.5;
    cancelButton.layer.borderColor = [UIColor whiteColor].CGColor;
    cancelButton.layer.cornerRadius = 3;
    [cancelButton addTarget:self action:@selector(cancelButtonClick) forControlEvents:UIControlEventTouchUpInside];
    cancelItem = [[UIBarButtonItem alloc] initWithCustomView:cancelButton];
    
    backItem = [UIBarButtonItem barItemWithImage:[UIImage imageNamed:@"backimage_white"] target:self action:@selector(back)];
    
    self.delegate = self;
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    viewController.navigationItem.rightBarButtonItem = cancelItem;
    if (navigationController.viewControllers.count == 2) {
        viewController.navigationItem.leftBarButtonItem = backItem;
    }
}

-(void)cancelButtonClick
{
    if ([self.imagePickerDelegate respondsToSelector:@selector(PimagePickerControllerDidCancel:)]) {
        [self.imagePickerDelegate PimagePickerControllerDidCancel:self];
    }
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    if ([self.imagePickerDelegate respondsToSelector:@selector(PimagePickerController: didFinishPickingMediaWithInfo:)]) {
        [self.imagePickerDelegate PimagePickerController:picker didFinishPickingMediaWithInfo:info];
    }
}

-(void)back
{
    [self popViewControllerAnimated:YES];
}

- (BOOL)prefersStatusBarHidden
{
    if (self.sourceType==UIImagePickerControllerSourceTypeCamera)   // iOS7+ only
    {
        return YES;
    }else{
        return NO;
    }
}

- (UIViewController *)childViewControllerForStatusBarHidden
{
    return nil;
}

//状态栏白字
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
