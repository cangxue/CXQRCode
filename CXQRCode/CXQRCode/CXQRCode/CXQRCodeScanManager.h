//
//  CXQRCodeScanManager.h
//  CXQRCode
//
//  Created by xiaoma on 2017/8/10.
//  Copyright © 2017年 CX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@class CXQRCodeScanManager;

@protocol CXQRCodeScanmanagerDelegate <NSObject>

@required
/// 二维码扫描获取数据的回调方法
- (void)CX_QRCodeScanmanager:(CXQRCodeScanManager *)scanManager didOutputMetadataObjects:(NSArray *)metadataObjects;

@end


@interface CXQRCodeScanManager : NSObject

/// CXQRCodeScanmanagerDelegate
@property (nonatomic, weak) id<CXQRCodeScanmanagerDelegate> delegate;

//快速创建单例模式
+ (instancetype)shareManager;

/**
 *  创建扫描二维码会话对象以及会话采集数据类型和扫码支持的编码格式的设置
 *
 *  @param currentController    当前控制器
 */
- (void)CX_setupSessionWithCurrentController:(UIViewController *)currentController;

/** 开始扫码 */
- (void)CX_startQRCode;

/** 停止扫码 */
- (void)CX_stopQRCode;

@end
