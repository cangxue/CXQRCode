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

@end
