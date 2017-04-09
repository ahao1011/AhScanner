//
//  ScannerTool.h
//  AhScanner
//
//  Created by ah on 2017/3/28.
//  Copyright © 2017年 ah. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ScannerTool : NSObject

+ (instancetype)defaultTool;
+ (void)alertWithTitle:(NSString*)title message:(NSString *)msg leftTitle:(NSString *)lefttitle leftHandle:(void (^)(UIAlertAction *action))leftHandle rightTitle:(NSString*)rightTitle rightHandle:(void(^)(UIAlertAction *action))rightHandle vc:(UIViewController*)vc;
+ (void)alertWithTitle:(NSString*)title message:(NSString *)msg btnTitle:(NSString *)btnTitle btnHandle:(void (^)(UIAlertAction *action))btnHandle vc:(UIViewController*)vc;
+ (void)alertWithTitle:(NSString*)title message:(NSString *)msg btnTitle:(NSString *)btnTitle vc:(UIViewController*)vc;
+ (void)alertWithmessage:(NSString *)msg btnTitle:(NSString *)btnTitle vc:(UIViewController*)vc;
//- (void)PtotoActionWithTarget:(UIViewController*)target resultHandle:(void (^)(UIImage* img))resultHandle;
@end
