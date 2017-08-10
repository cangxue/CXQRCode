//
//  CXQRCodeScanView.h
//  CXQRCode
//
//  Created by xiaoma on 2017/8/10.
//  Copyright © 2017年 CX. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CXQRCodeScanView : UIView

/**
 *  对象方法创建CXQRCodeScanView
 *
 *  @param frame     frame
 *  @param layer     父视图 layer
 */
- (instancetype)initWithFrame:(CGRect)frame layer:(CALayer *)layer;
/**
 *  类方法创建CXQRCodeScanView
 *
 *  @param frame     frame
 *  @param layer     父视图 layer
 */
+ (instancetype)scanningViewWithFrame:(CGRect )frame layer:(CALayer *)layer;

/** 开始扫码 */
- (void)startLineMove;
/** 停止扫码 */
- (void)stopLineMove;


@end
