//
//  CXQRCodeScanViewController.m
//  CXQRCode
//
//  Created by xiaoma on 2017/8/10.
//  Copyright © 2017年 CX. All rights reserved.
//

#import "CXQRCodeScanViewController.h"
#import "CXQRCodeScanView.h"
#import "CXQRCodeScanManager.h"

@interface CXQRCodeScanViewController () <CXQRCodeScanmanagerDelegate>

@property (nonatomic, strong) CXQRCodeScanView *scanView;

@property (nonatomic, strong) CXQRCodeScanManager *scanManager;

@end

@implementation CXQRCodeScanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor clearColor];
    
    [self.scanManager CX_startQRCode];
    
    [self.view addSubview:self.scanView];
    

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.scanView startLineMove];
    [self.scanManager CX_setupSessionWithCurrentController:self];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.scanView stopLineMove];
    [self.scanManager CX_stopQRCode];
}

#pragma mark
- (void)CX_QRCodeScanmanager:(CXQRCodeScanManager *)scanManager didOutputMetadataObjects:(NSArray *)metadataObjects {
    if ([metadataObjects count] > 0) {
        AVMetadataMachineReadableCodeObject *metadataObject = [metadataObjects objectAtIndex:0];
        NSString *objectValue = metadataObject.stringValue;
        
        [scanManager CX_stopQRCode];
        [_scanView stopLineMove];
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:objectValue preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"重新扫描" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [scanManager CX_startQRCode];
            [_scanView startLineMove];
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"返回" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [self.navigationController popViewControllerAnimated:YES];
        }]];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

#pragma mark - lazy

- (CXQRCodeScanView *)scanView {
    if (!_scanView) {
        _scanView = [CXQRCodeScanView scanningViewWithFrame:self.view.frame layer:self.view.layer];
        self.scanManager.delegate = self;
    }
    
    return _scanView;
}

- (CXQRCodeScanManager *)scanManager {
    if (!_scanManager) {
        _scanManager = [CXQRCodeScanManager shareManager];
        
    }
    
    return _scanManager;
}


@end
