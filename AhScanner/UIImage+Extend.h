//
//  UIImage+Extend.h
//  BankCard
//
//  Created by XAYQ-FanXL on 16/7/8.
//  Copyright © 2016年 AN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface UIImage (Extend)

+ (UIImage *)imageFromSampleBuffer:(CMSampleBufferRef)sampleBuffer;
+ (UIImage *)getImageStream:(CVImageBufferRef)imageBuffer;
+ (UIImage *)getSubImage:(CGRect)rect inImage:(UIImage*)image;
//+ (CVPixelBufferRef)pixelBufferFromCGImage:(CGImageRef)image;
//+ (CMSampleBufferRef)sampleBufferFromCGImage:(CGImageRef)image;
-(UIImage *)originalImage;

@end
