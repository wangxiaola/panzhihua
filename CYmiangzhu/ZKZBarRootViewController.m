
//
//  RootViewController.m
//  NewProject
//
//  Created by 学鸿 张 on 13-11-29.
//  Copyright (c) 2013年 Steven. All rights reserved.
//

#import "ZKZBarRootViewController.h"

@interface ZKZBarRootViewController ()

@end

@implementation ZKZBarRootViewController

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
    self.view.backgroundColor = [UIColor grayColor];
    
    UILabel * labIntroudction= [[UILabel alloc] initWithFrame:CGRectMake(15, 40, 290, 50)];
    labIntroudction.backgroundColor = [UIColor clearColor];
    labIntroudction.numberOfLines=2;
    labIntroudction.textColor=[UIColor whiteColor];
    labIntroudction.text=@"将二维码图像置于矩形方框内，离手机摄像头10CM左右，系统会自动识别。";
    [self.view addSubview:labIntroudction];
    
    
    UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 100, self.view.frame.size.width-20, 300)];
    imageView.image = [UIImage imageNamed:@"pick_bg"];
    [self.view addSubview:imageView];
    
    upOrdown = NO;
    num =0;
    _line = [[UIImageView alloc] initWithFrame:CGRectMake(40, 10, self.view.frame.size.width-80, 2)];
    _line.image = [UIImage imageNamed:@"line.png"];
    [imageView addSubview:_line];
    
    timer = [NSTimer scheduledTimerWithTimeInterval:.02 target:self selector:@selector(animation1) userInfo:nil repeats:YES];
    
   
    UIButton * scanButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [scanButton setTitle:@"取  消" forState:UIControlStateNormal];
    scanButton.frame = CGRectMake((self.view.frame.size.width/2)-60, imageView.frame.origin.y+imageView.frame.size.height+26, 120, 40);
    scanButton.layer.masksToBounds =YES;
    scanButton.titleLabel.font =[UIFont systemFontOfSize:18];
    scanButton.titleLabel.font =[UIFont boldSystemFontOfSize:18];
    [scanButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [scanButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:scanButton];

}
-(void)animation1
{
    if (upOrdown == NO) {
        num ++;
        _line.frame = CGRectMake(40, 10+2*num, self.view.frame.size.width-80, 2);
        if (2*num ==280) {
            upOrdown = YES;
        }
    }
    else {
        num --;
        _line.frame = CGRectMake(40, 10+2*num, self.view.frame.size.width-80, 2);
        if (num == 0) {
            upOrdown = NO;
        }
    }

}
-(void)backAction
{
    
    [self dismissViewControllerAnimated:YES completion:^{
        [timer invalidate];
    }];
}
-(void)viewWillAppear:(BOOL)animated
{
    [self setupCamera];
}
- (void)setupCamera
{
    // Device
    _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    // Input
    _input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:nil];
    
    // Output
    _output = [[AVCaptureMetadataOutput alloc]init];
    [_output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    // Session
    _session = [[AVCaptureSession alloc]init];
    [_session setSessionPreset:AVCaptureSessionPresetHigh];
    if ([_session canAddInput:self.input])
    {
        [_session addInput:self.input];
    }
    
    if ([_session canAddOutput:self.output])
    {
        [_session addOutput:self.output];
    }
    
    // 条码类型 AVMetadataObjectTypeQRCode
    _output.metadataObjectTypes =@[AVMetadataObjectTypeQRCode];
    
    // Preview
    _preview =[AVCaptureVideoPreviewLayer layerWithSession:self.session];
    _preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
    _preview.frame =CGRectMake(20,110,self.view.frame.size.width-40,280);
    [self.view.layer insertSublayer:self.preview atIndex:0];
    

    
    // Start
    [_session startRunning];
}
#pragma mark AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
   
    NSString *stringValue;
    
    if ([metadataObjects count] >0)
    {
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex:0];
        stringValue = metadataObject.stringValue;
    }
    
    [_session stopRunning];
   [self dismissViewControllerAnimated:YES completion:^
    {
        [timer invalidate];
        
        self.pcc(stringValue);
        
    }];
}

-(void)rtConter:(zbarConter)pc;
{

    self.pcc =pc;

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
