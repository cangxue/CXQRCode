//
//  CXQRCodeGenerateManager.h
//  CXQRCode
//
//  Created by xiaoma on 2017/8/12.
//  Copyright © 2017年 CX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CXQRCodeGenerateManager : NSObject

// 生成普通二维码
+ (UIImage *)CX_generateDefaultQRCodeWithData:(NSString *)data imageWidth:(CGFloat)imageWidth;

// 生成一张带有logo的二维码（logoScaleToSuperView：相对于父视图的缩放比取值范围0-1；0，不显示，1，代表与父视图大小相同）
+ (UIImage *)CX_generateWithLogoQRCodeData:(NSString *)data logoImageName:(NSString *)logoImageName logoScaleToSuperView:(CGFloat)logoScaleToSuperView;

@end
