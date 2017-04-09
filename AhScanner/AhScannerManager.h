//
//  AhScannerManager.h
//  AhScanner
//
//  Created by ah on 2017/3/28.
//  Copyright © 2017年 ah. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ScannerHeader.h"
@class IDInfo;
typedef void(^AhScannerManagerBlock)(IDInfo *info,IDCardType type);
@interface AhScannerManager : NSObject

/**人脸检测框区域*/
@property (nonatomic,assign) CGRect faceDetectionFrame;
@property (nonatomic,copy) AhScannerManagerBlock resultHandle;
/**展示拍照功能的控制器*/
@property (nonatomic,strong) UIViewController *vc;
/**操控手电筒 result 设置结果,YES 表示打开*/
- (void)manipulateTorch:(void(^)(BOOL result))resulthandle;
/**检查摄像头权限*/
- (void)checkAuthorizationStatus;
/**人脸识别时的IDCart初始化*/
- (void)initializeIDCart;
- (void)startSession;
- (void)stopSession;
- (instancetype)initWithIDCardType:(IDCardType)type;

@end
