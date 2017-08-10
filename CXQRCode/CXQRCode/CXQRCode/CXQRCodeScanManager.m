//
//  CXQRCodeScanManager.m
//  CXQRCode
//
//  Created by xiaoma on 2017/8/10.
//  Copyright © 2017年 CX. All rights reserved.
//

#import "CXQRCodeScanManager.h"
#import <AVFoundation/AVFoundation.h>
//全屏宽和高大小
#define FUll_VIEW_WIDTH ([[UIScreen mainScreen] bounds].size.width)

#define FUll_VIEW_HEIGHT ([[UIScreen mainScreen] bounds].size.height)

@interface CXQRCodeScanManager () <AVCaptureMetadataOutputObjectsDelegate>

/** 输入／输出会话 */
@property (nonatomic, strong) AVCaptureSession *captureSession;

/** 会话预览图层 */
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *videoPreviewLayer;

@end

@implementation CXQRCodeScanManager

+ (instancetype)shareManager {
    static CXQRCodeScanManager *_shareInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        _shareInstance = [[CXQRCodeScanManager alloc] init];
    });
    
    return _shareInstance;
}

#pragma mark - setupCamera
- (void)CX_setupSessionWithCurrentController:(UIViewController *)currentController {
    // 1、 相机是否授权
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (status == AVAuthorizationStatusNotDetermined) {
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            NSLog(@"请打开相机权限");
            return;
        }];
    } else if (status == AVAuthorizationStatusDenied || status == AVAuthorizationStatusRestricted) {
        NSLog(@"请打开相机权限");
        return;
    }
    
    // 2、获取摄像设备
    AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    // 3、创建设备输入流
    NSError *error;
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:&error];
    if (!input) {
        NSLog(@"该设备不可用");
        return;
    }
    
    // 4、创建数据输出流
    AVCaptureMetadataOutput *output = [[AVCaptureMetadataOutput alloc] init];
    //   设置代理：在主线程里刷新
    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    // 5、创建会话对象
    _captureSession = [[AVCaptureSession alloc] init];
    // 会话采集率: AVCaptureSessionPresetHigh
    [_captureSession setSessionPreset:AVCaptureSessionPresetHigh];
    
    // 6、添加设备输入流到会话对象
    if ([_captureSession canAddInput:input]) {
        [_captureSession addInput:input];
    }
    
    // 7、添加设备输入流到会话对象
    if ([_captureSession canAddOutput:output]) {
        [_captureSession addOutput:output];
    }
    
    // 8、设置数据输出类型，需要将数据输出添加到会话后，才能指定元数据类型，否则会报错
    // 设置扫码支持的编码格式(如下设置条形码和二维码兼容)
    // @[AVMetadataObjectTypeQRCode, AVMetadataObjectTypeEAN13Code,  AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code]
    NSArray *array = @[AVMetadataObjectTypeQRCode, AVMetadataObjectTypeEAN13Code,  AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code];
    output.metadataObjectTypes =  array;
    
    // 9、实例化预览图层, 传递_session是为了告诉图层将来显示什么内容
    _videoPreviewLayer = [AVCaptureVideoPreviewLayer layerWithSession:_captureSession];
    _videoPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    _videoPreviewLayer.frame = CGRectMake(0, 0, FUll_VIEW_WIDTH, FUll_VIEW_HEIGHT);
    [currentController.view.layer insertSublayer:_videoPreviewLayer atIndex:0];
    
    
    // 10、启动会话
    [_captureSession startRunning];
    
}

#pragma mark - AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection {

    if (self.delegate && [self.delegate respondsToSelector:@selector(CX_QRCodeScanmanager:didOutputMetadataObjects:)]) {
        [self.delegate CX_QRCodeScanmanager:self didOutputMetadataObjects:metadataObjects];
    }
}

#pragma mark - action
- (void)CX_startQRCode {
    if (_captureSession && ![_captureSession isRunning]) {
        [_captureSession startRunning];
    }
}

- (void)CX_stopQRCode {
    if ([_captureSession isRunning]) {
        [_captureSession stopRunning];
    }
}

@end
