//
//  ScannerHeader.h
//  AhScanner
//
//  Created by ah on 2017/3/27.
//  Copyright © 2017年 ah. All rights reserved.
//

#ifndef ScannerHeader_h
#define ScannerHeader_h

#import "ScannerTool.h"
#import "UIImage+Extend.h"
#import "RectManager.h"
#import "IDInfo.h"



//4. 屏幕宽 高
#define K_ScreenWidth [UIScreen mainScreen].bounds.size.width
#define K_ScreenHeight  [UIScreen mainScreen].bounds.size.height
//5. 设备简单判断

#define Iphone4 ((K_ScreenWidth == 320) && (K_ScreenHeight == 480))
#define Iphone5 ((K_ScreenWidth == 320) && (K_ScreenHeight == 568))
#define Iphone6 ((K_ScreenWidth == 375) && (K_ScreenHeight == 667))
#define Iphone6P ((K_ScreenWidth == 414) && (K_ScreenHeight == 736))

//  last
#ifdef DEBUG  // 调试阶段
#define ScannerLog(...) NSLog(__VA_ARGS__)
#else // 发布阶段
#define ScannerLog(...)
#endif


typedef enum {  // 卡片正反面
    /** 正面 */
    IDCardTypeFace,
    /**反面*/
    IDCardTypeBack
    
}IDCardType;


#endif /* ScannerHeader_h */
