//
//  CXQRCodeScanView.m
//  CXQRCode
//
//  Created by xiaoma on 2017/8/10.
//  Copyright © 2017年 CX. All rights reserved.
//

#import "CXQRCodeScanView.h"

#import <AVFoundation/AVFoundation.h>



/** 扫描内容的Y值 */
#define scanContent_Y self.frame.size.height * 0.24
/** 扫描内容的X值 */
#define scanContent_X self.frame.size.width * 0.15


/** 扫描内容外部View的alpha值 */
static CGFloat const scanBorderOutsideViewAlpha = 0.4;
/** 二维码冲击波动画时间 */
static CGFloat const scanningLineAnimation = 0.05;
/** 扫描动画线(冲击波) 的高度 */
static CGFloat const scanninglineHeight = 2;

@interface CXQRCodeScanView ()



/** 刷新位置 */
@property (nonatomic, strong) CADisplayLink *displayLink;

/** 扫码线条 */
@property (nonatomic, strong) UIImageView *scanningline;

/** 父视图layer */
@property (nonatomic, strong) CALayer *superLayer;

@end

@implementation CXQRCodeScanView

- (instancetype)initWithFrame:(CGRect)frame layer:(CALayer *)layer {
    if (self = [super initWithFrame:frame]) {
//        self.superLayer = layer;
        
        // 扫描动画添加
        [self.layer addSublayer:self.scanningline.layer];
        
        //设置扫码框
        [self setupSubViews];

    }
    
    return self;
}

+ (instancetype)scanningViewWithFrame:(CGRect )frame layer:(CALayer *)layer {
    return [[self alloc] initWithFrame:frame layer:layer];
}

- (void)startLineMove {
    
    self.scanningline.hidden = NO;
    self.displayLink.paused = NO;
}

- (void)stopLineMove {
    
    self.displayLink.paused = YES;
}



#pragma mark - 刷新扫描条位置
- (void)handleDisplayLink:(CADisplayLink *)displayLink {
    [self scanAnimate];
}

- (void)scanAnimate {
    __block CGRect frame = _scanningline.frame;
    static BOOL flag = YES;
    if (flag) {
        flag = NO;
        frame.origin.y = scanContent_Y;
        [UIView animateWithDuration:scanningLineAnimation animations:^{
            frame.origin.y += 5;
            _scanningline.frame = frame;
        }];
    } else {
        if (_scanningline.frame.origin.y >= scanContent_Y) {
            CGFloat scanContent_MaxY = scanContent_Y + self.frame.size.width - 2 * scanContent_X;
            if (_scanningline.frame.origin.y >= scanContent_MaxY - 10) {
                frame.origin.y = scanContent_Y;
                _scanningline.frame = frame;
                flag = YES;
            } else {
                [UIView animateWithDuration:scanningLineAnimation animations:^{
                    frame.origin.y += 5;
                    _scanningline.frame = frame;
                } completion:nil];
            }
        } else {
            flag = !flag;
        }
    }
}

#pragma mark - lazy 
- (CADisplayLink *)displayLink {
    if (!_displayLink) {
        _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(handleDisplayLink:)];
        _displayLink.frameInterval = 2;
        [_displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
        _displayLink.paused = YES;
    }
    
    return _displayLink;
}

- (UIImageView *)scanningline {
    if (!_scanningline) {
        _scanningline = [[UIImageView alloc] init];
        _scanningline.image = [UIImage imageNamed:@"scan_line"];
        _scanningline.frame = CGRectMake(scanContent_X, scanContent_Y , self.frame.size.width - scanContent_X*2 , scanninglineHeight);
    }
    return _scanningline;
}



#pragma mark - setUI
- (void)setupSubViews {
    // 扫描内容的创建
    CALayer *scanContent_layer = [[CALayer alloc] init];
    CGFloat scanContent_layerX = scanContent_X;
    CGFloat scanContent_layerY = scanContent_Y;
    CGFloat scanContent_layerW = self.frame.size.width - 2 * scanContent_X;
    CGFloat scanContent_layerH = scanContent_layerW;
    scanContent_layer.frame = CGRectMake(scanContent_layerX, scanContent_layerY, scanContent_layerW, scanContent_layerH);
    scanContent_layer.borderColor = [[UIColor whiteColor] colorWithAlphaComponent:0.6].CGColor;
    scanContent_layer.borderWidth = 0.7;
    scanContent_layer.backgroundColor = [UIColor clearColor].CGColor;
    [self.layer addSublayer:scanContent_layer];
    
#pragma mark - - - 扫描外部View的创建
    // 顶部layer的创建
    CALayer *top_layer = [[CALayer alloc] init];
    CGFloat top_layerX = 0;
    CGFloat top_layerY = 0;
    CGFloat top_layerW = self.frame.size.width;
    CGFloat top_layerH = scanContent_layerY;
    top_layer.frame = CGRectMake(top_layerX, top_layerY, top_layerW, top_layerH);
    top_layer.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:scanBorderOutsideViewAlpha].CGColor;
    [self.layer addSublayer:top_layer];
    
    // 左侧layer的创建
    CALayer *left_layer = [[CALayer alloc] init];
    CGFloat left_layerX = 0;
    CGFloat left_layerY = scanContent_layerY;
    CGFloat left_layerW = scanContent_X;
    CGFloat left_layerH = scanContent_layerH;
    left_layer.frame = CGRectMake(left_layerX, left_layerY, left_layerW, left_layerH);
    left_layer.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:scanBorderOutsideViewAlpha].CGColor;
    [self.layer addSublayer:left_layer];
    
    // 右侧layer的创建
    CALayer *right_layer = [[CALayer alloc] init];
    CGFloat right_layerX = CGRectGetMaxX(scanContent_layer.frame);
    CGFloat right_layerY = scanContent_layerY;
    CGFloat right_layerW = scanContent_X;
    CGFloat right_layerH = scanContent_layerH;
    right_layer.frame = CGRectMake(right_layerX, right_layerY, right_layerW, right_layerH);
    right_layer.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:scanBorderOutsideViewAlpha].CGColor;
    [self.layer addSublayer:right_layer];
    
    // 下面layer的创建
    CALayer *bottom_layer = [[CALayer alloc] init];
    CGFloat bottom_layerX = 0;
    CGFloat bottom_layerY = CGRectGetMaxY(scanContent_layer.frame);
    CGFloat bottom_layerW = self.frame.size.width;
    CGFloat bottom_layerH = self.frame.size.height - bottom_layerY;
    bottom_layer.frame = CGRectMake(bottom_layerX, bottom_layerY, bottom_layerW, bottom_layerH);
    bottom_layer.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:scanBorderOutsideViewAlpha].CGColor;
    [self.layer addSublayer:bottom_layer];

}

@end
