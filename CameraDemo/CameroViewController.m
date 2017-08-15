//
//  CameroViewController.m
//  CameraDemo
//
//  Created by Jacob on 10/25/16.
//  Copyright © 2016 Jacob. All rights reserved.
//

#import "CameroViewController.h"
#import <Masonry.h>
#import <AVFoundation/AVFoundation.h>
#import "CameroCaptureView.h"
#import "CameroResultView.h"
#import "CameroTopView.h"

@interface CameroViewController ()

/*AVCaptureSession对象来执行输入设备和输出设备之间的数据传递*/
@property (nonatomic, strong) AVCaptureSession *session;
/*输入设备*/
@property (nonatomic, strong) AVCaptureDeviceInput *videoInput;
/*照片输出流*/
@property (nonatomic, strong) AVCaptureStillImageOutput *stillImageOutpu;
/*预览图层*/
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *previewLayer;
/*预览图层大小*/
@property (nonatomic, assign) CGSize previousLayerSize;
/*预览图层的背景View*/
@property (nonatomic, strong) UIView *cameroBgView;
/*相框捕获frame，根据captureSize计算得来的*/
@property (nonatomic, assign) CGRect captureFrame;

///////////////
/*相框描述*/
@property (nonatomic, strong) NSString *titleDescription;
/*相框捕获大小*/
@property (nonatomic, assign) CGSize captureSize;

@property (nonatomic, strong) CameroCaptureView *cameroCaptureView;

@property (nonatomic, strong) CameroResultView *resultView;

// 是否需要截取图片
@property (nonatomic, assign) BOOL isNeedCapture;

@end

@implementation CameroViewController

- (void)dealloc {
    NSLog(@"%s", __func__);
}

- (id)init {
    if (self = [super init]) {
        self.isNeedCapture = NO;
    }
    return self;
}

- (id)initWithTitle:(NSString *)title captureSize:(CGSize)captureSize {
    if (self = [super init]) {
        self.isNeedCapture = YES;
        self.titleDescription = title;
        self.captureSize = captureSize;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if ([self checkCameraAuth]) {
        [self setupAVCaptureSession];
        [self setupUI];
    }
}

- (BOOL)prefersStatusBarHidden {
    return NO;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.session) {
        [self.session startRunning];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (self.session) {
        [self.session stopRunning];
    }
}

- (void)setupAVCaptureSession {
    self.session = [[AVCaptureSession alloc] init];
    
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    // 更改相机设置
    [device lockForConfiguration:nil];
    if ([device isFlashModeSupported:AVCaptureFlashModeAuto]) {
        [device setFlashMode:AVCaptureFlashModeAuto]; // 闪光灯自动
    }
    if ([device isWhiteBalanceModeSupported:AVCaptureWhiteBalanceModeAutoWhiteBalance]) {
        [device setWhiteBalanceMode:AVCaptureWhiteBalanceModeAutoWhiteBalance]; // 白平衡
    }
    
    [device unlockForConfiguration];
    
    self.videoInput = [[AVCaptureDeviceInput alloc] initWithDevice:device error:NULL];
    
    // 输出设置
    self.stillImageOutpu = [[AVCaptureStillImageOutput alloc] init];
    NSDictionary *outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys:AVVideoCodecJPEG, AVVideoCodecKey, nil];
    [self.stillImageOutpu setOutputSettings:outputSettings];
    
    if ([self.session canSetSessionPreset:AVCaptureSessionPresetPhoto]) {
        self.session.sessionPreset = AVCaptureSessionPresetPhoto;
    }
    
    if ([self.session canAddInput:self.videoInput]) {
        [self.session addInput:self.videoInput];
    }
    if ([self.session canAddOutput:self.stillImageOutpu]) {
        [self.session addOutput:self.stillImageOutpu];
    }
}

- (void)updateFlashMode:(AVCaptureFlashMode)flashMode {
    if ([self.videoInput.device hasFlash] && [self.videoInput.device isFlashModeSupported:flashMode]) {
        [self.videoInput.device lockForConfiguration:NULL];
        [self.videoInput.device setFlashMode:flashMode];
        [self.videoInput.device unlockForConfiguration];
    }
}

- (void)setupUI {
    self.view.backgroundColor = [UIColor blackColor];
    
    __weak CameroViewController *weakSelf = self;
    CameroTopView *topView = [[CameroTopView alloc] init];
    [self.view addSubview:topView];
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(topView.superview);
        make.top.equalTo(topView.superview).offset(20);
        make.height.equalTo(@36);
    }];
    [topView setFlashModeChangeBlock:^(NSInteger index) {
        if (index == 0) {
            [weakSelf updateFlashMode:AVCaptureFlashModeAuto];
        } else if (index == 1) {
            [weakSelf updateFlashMode:AVCaptureFlashModeOn];
        } else if (index == 2) {
            [weakSelf updateFlashMode:AVCaptureFlashModeOff];
        }
    }];
    
    UIView *bottomView = [UIView new];
    [self.view addSubview:bottomView];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(bottomView.superview);
        make.height.equalTo(@135);
    }];
    bottomView.backgroundColor = [UIColor blackColor];
    
    UILabel *topTilte = [UILabel new];
    [bottomView addSubview:topTilte];
    [topTilte mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(topTilte.superview);
        make.top.equalTo(topTilte.superview).offset(15);
    }];
    topTilte.text = @"照片";
    topTilte.font = [UIFont systemFontOfSize:16];
    topTilte.textColor = [UIColor colorWithRed:(float)((0xf7bb02 & 0xFF0000) >> 16) / 255.0 green:(float)((0xf7bb02 & 0xFF00) >> 8) / 255.0 blue:(float)(0xf7bb02 & 0xFF) / 255.0 alpha:1.0];
    
    UIButton *cameraButton = [UIButton new];
    [bottomView addSubview:cameraButton];
    [cameraButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(cameraButton.superview);
        make.bottom.equalTo(cameraButton.superview).offset(-15);
        make.size.mas_equalTo(CGSizeMake(66, 66));
    }];
    [cameraButton setImage:[UIImage imageNamed:@"CameraCircle"] forState:UIControlStateNormal];
    [cameraButton addTarget:self action:@selector(onClickCamera) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *cameraChangeButton = [UIButton new];
    [bottomView addSubview:cameraChangeButton];
    [cameraChangeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(cameraButton);
        make.right.equalTo(cameraChangeButton.superview).offset(-15);
        make.size.mas_equalTo(CGSizeMake(30, 22));
    }];
    [cameraChangeButton setImage:[UIImage imageNamed:@"CameraChange"] forState:UIControlStateNormal];
    [cameraChangeButton addTarget:self action:@selector(onClickCameraChangeButton) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *dismissButton = [UIButton new];
    [bottomView addSubview:dismissButton];
    [dismissButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(dismissButton.superview).offset(15);
        make.centerY.equalTo(cameraButton);
        make.size.mas_equalTo(CGSizeMake(40, 30));
    }];
    [dismissButton setTitle:@"取消" forState:UIControlStateNormal];
    [dismissButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    dismissButton.titleLabel.font = [UIFont systemFontOfSize:17];
    [dismissButton addTarget:self action:@selector(onClickDismiss) forControlEvents:UIControlEventTouchUpInside];
    
    //////////////////
    // 计算相框及捕获区域
    UIView *cameroBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 36 + 20, [UIScreen mainScreen].bounds.size.width, self.view.frame.size.height - 36 - 20 - 135)];
    [self.view addSubview:cameroBgView];
    cameroBgView.backgroundColor = [UIColor clearColor];
    self.cameroBgView = cameroBgView;
    self.previousLayerSize = CGSizeMake(cameroBgView.frame.size.width, cameroBgView.frame.size.height);
    
    if (self.isNeedCapture) {
        CGFloat x,y;
        if (self.captureSize.width >= self.previousLayerSize.width) {
            x = 0;
        } else {
            x = (self.previousLayerSize.width - self.captureSize.width) / 2;
        }
        if (self.titleDescription.length > 0) {
            if (self.captureSize.height >= self.previousLayerSize.height - 60) {
                y = 0;
            } else {
                y = (self.previousLayerSize.height - self.captureSize.height) / 2 - 30;
            }
        } else {
            // 没有文字居中显示截取区域
            if (self.captureSize.height >= self.previousLayerSize.height) {
                y = 0;
            } else {
                y = (self.previousLayerSize.height - self.captureSize.height) / 2;
            }
        }
        
        self.captureFrame = CGRectMake(x, y, self.captureSize.width, self.captureSize.height);
    }
    
    // 相机预览图层
    self.previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.session];
    [self.previewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    self.previewLayer.frame = CGRectMake(0, 0, self.previousLayerSize.width, self.previousLayerSize.height);
    cameroBgView.layer.masksToBounds = YES;
    [cameroBgView.layer addSublayer:self.previewLayer];
    
    if (self.isNeedCapture) {
        [self setupCaptureArea];
    }
}

- (void)setupCaptureArea {
    CameroCaptureView *captureView = [[CameroCaptureView alloc] initWithFrame:self.cameroBgView.bounds title:self.titleDescription captureFrame:self.captureFrame];
    captureView.alpha = 0.4;
    self.cameroCaptureView = captureView;
    [self.cameroBgView addSubview:captureView];
}

- (BOOL)checkCameraAuth {
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusDenied) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请打开相机权限" message:@"设置-隐私-相机" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
        [alert show];
        return NO;
    }
    
    return YES;
}

- (void)onClickDismiss {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)onClickCamera {
    AVCaptureConnection *stillImageConnection = [self.stillImageOutpu connectionWithMediaType:AVMediaTypeVideo];
    UIDeviceOrientation curDeviceOrientation = [[UIDevice currentDevice] orientation];
    AVCaptureVideoOrientation avcaptureOrientation = [self avOrientationForDeviceOrientation:curDeviceOrientation];
    [stillImageConnection setVideoOrientation:avcaptureOrientation];
    [stillImageConnection setVideoScaleAndCropFactor:1];
    
    __weak CameroViewController *weakSelf = self;
    [self.stillImageOutpu captureStillImageAsynchronouslyFromConnection:stillImageConnection completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
        if (imageDataSampleBuffer) {
            NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
            
            UIImage *image = [[UIImage alloc] initWithData:imageData];
            
            CGSize scaleToSize = self.previousLayerSize;
            if (weakSelf.isNeedCapture) {
                if (image.size.height < image.size.width) {
                    image = [self image:image rotation:UIImageOrientationRight];
                }
                image = [weakSelf imageWithImage:image scaledToSize:scaleToSize];
                
                // 截取图片
                image = [weakSelf imageFromImage:image inRect:weakSelf.captureFrame];
            } else {
                if (image.size.height < image.size.width && !weakSelf.isNeedCapture) {
                    scaleToSize = CGSizeMake(self.previousLayerSize.width, self.previousLayerSize.width / self.previousLayerSize.height * self.previousLayerSize.width);
                }

                image = [weakSelf imageWithImage:image scaledToSize:scaleToSize];
            }
            
            NSData *data = UIImagePNGRepresentation(image);
            NSLog(@"%ld", data.length);
            
            [weakSelf.resultView showWithImage:image];
        }
    }];
}

- (void)onClickCameraChangeButton {
    
    NSUInteger cameraCount = [[AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo] count];
    if (cameraCount > 1) {
        CATransition *animation = [CATransition animation];
        animation.duration = 0.5f;
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        animation.type = @"oglFlip";
        
        AVCaptureDevice *newCamera = nil;
        AVCaptureDeviceInput *newInput = nil;
        AVCaptureDevicePosition position = [[self.videoInput device] position];
        if (position == AVCaptureDevicePositionFront) {
            newCamera = [self cameraWithPosition:AVCaptureDevicePositionBack];
            animation.subtype = kCATransitionFromLeft;
        } else {
            newCamera = [self cameraWithPosition:AVCaptureDevicePositionFront];
            animation.subtype = kCATransitionFromRight;
        }
        
        newInput = [AVCaptureDeviceInput deviceInputWithDevice:newCamera error:NULL];
        [self.previewLayer addAnimation:animation forKey:nil];
        [self.cameroCaptureView.layer addAnimation:animation forKey:nil];
        if (newInput != nil) {
            [self.session beginConfiguration];
            [self.session removeInput:self.videoInput];
            if ([self.session canAddInput:newInput]) {
                [self.session addInput:newInput];
                self.videoInput = newInput;
            } else {
                [self.session addInput:self.videoInput];
            }
            [self.session commitConfiguration];
        }
    }
}

#pragma mark Camero private methods

- (AVCaptureDevice *)cameraWithPosition:(AVCaptureDevicePosition)position {
    for (AVCaptureDevice *device in [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo]) {
        if (device.position == position) {
            return device;
        }
    }
    
    return nil;
}

-(AVCaptureVideoOrientation)avOrientationForDeviceOrientation:(UIDeviceOrientation)deviceOrientation {
    AVCaptureVideoOrientation result = (AVCaptureVideoOrientation)deviceOrientation;
    if ( deviceOrientation == UIDeviceOrientationLandscapeLeft )
        result = AVCaptureVideoOrientationLandscapeRight;
    else if ( deviceOrientation == UIDeviceOrientationLandscapeRight )
        result = AVCaptureVideoOrientationLandscapeLeft;
    return result;
}

/**设置image的大小*/
-(UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize {
    // 按比例创建bitmap
    UIGraphicsBeginImageContextWithOptions(newSize, NO, [[UIScreen mainScreen] scale]);
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return newImage;
}

- (UIImage *)imageFromImage:(UIImage *)image inRect:(CGRect)rect {
    CGImageRef sourceImageRef = [image CGImage];
    //
    CGFloat scale = [[UIScreen mainScreen] scale];
    rect = CGRectMake(rect.origin.x * scale, rect.origin.y * scale, rect.size.width * scale, rect.size.height * scale);
    CGImageRef newImageRef = CGImageCreateWithImageInRect(sourceImageRef, rect);
    UIImage *newImage = [UIImage imageWithCGImage:newImageRef scale:scale orientation:UIImageOrientationUp];
    
    // 压缩
    NSData *imageData = UIImageJPEGRepresentation(newImage, 0.6);
    newImage = [UIImage imageWithData:imageData scale:scale];
    
    return newImage;
}

- (CameroResultView *)resultView {
    if (_resultView == nil) {
        CameroResultView *resultView = [[CameroResultView alloc] init];
        [self.view addSubview:resultView];
        [resultView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(resultView.superview);
        }];
        __weak CameroViewController *weakSelf = self;
        [resultView setUsePhotoBlock:^{
            if (weakSelf.useImageBlock) {
                weakSelf.useImageBlock(weakSelf.resultView.image);
            }
            [weakSelf dismissViewControllerAnimated:YES completion:nil];
        }];
        [resultView setResetBlock:^{
            weakSelf.resultView = nil;
        }];
        _resultView = resultView;
    }
    return _resultView;
}

// 旋转
- (UIImage *)image:(UIImage *)image rotation:(UIImageOrientation)orientation {
    long double rotate = 0.0;
    CGRect rect;
    float translateX = 0;
    float translateY = 0;
    float scaleX = 1.0;
    float scaleY = 1.0;
    
    switch (orientation) {
        case UIImageOrientationLeft:
            rotate = M_PI_2;
            rect = CGRectMake(0, 0, image.size.height, image.size.width);
            translateX = 0;
            translateY = -rect.size.width;
            scaleY = rect.size.width/rect.size.height;
            scaleX = rect.size.height/rect.size.width;
            break;
        case UIImageOrientationRight:
            rotate = 3 * M_PI_2;
            rect = CGRectMake(0, 0, image.size.height, image.size.width);
            translateX = -rect.size.height;
            translateY = 0;
            scaleY = rect.size.width/rect.size.height;
            scaleX = rect.size.height/rect.size.width;
            break;
        case UIImageOrientationDown:
            rotate = M_PI;
            rect = CGRectMake(0, 0, image.size.width, image.size.height);
            translateX = -rect.size.width;
            translateY = -rect.size.height;
            break;
        default:
            rotate = 0.0;
            rect = CGRectMake(0, 0, image.size.width, image.size.height);
            translateX = 0;
            translateY = 0;
            break;
    }
    
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    //做CTM变换
    CGContextTranslateCTM(context, 0.0, rect.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextRotateCTM(context, rotate);
    CGContextTranslateCTM(context, translateX, translateY);
    
    CGContextScaleCTM(context, scaleX, scaleY);
    //绘制图片
    CGContextDrawImage(context, CGRectMake(0, 0, rect.size.width, rect.size.height), image.CGImage);
    
    UIImage *newPic = UIGraphicsGetImageFromCurrentImageContext();
    
    return newPic;
}

@end
