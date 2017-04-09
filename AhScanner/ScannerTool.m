//
//  ScannerTool.m
//  AhScanner
//
//  Created by ah on 2017/3/28.
//  Copyright © 2017年 ah. All rights reserved.
//

#import "ScannerTool.h"
typedef void (^imgHandle)(UIImage* img);

// <UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@interface ScannerTool ()

@property (nonatomic,copy)imgHandle block;
@property (nonatomic,strong)  UIImagePickerController *imgController; // 相册管理

@end


@implementation ScannerTool

+ (instancetype)defaultTool{
    
    static ScannerTool *mt = nil;
    // 线程锁
    @synchronized (self){
        
        if (!mt) {
            mt = [[self alloc]init];
        }
    }
    return mt;
}

+ (void)alertWithTitle:(NSString*)title message:(NSString *)msg leftTitle:(NSString *)lefttitle leftHandle:(void (^)(UIAlertAction *action))leftHandle rightTitle:(NSString*)rightTitle rightHandle:(void(^)(UIAlertAction *action))rightHandle vc:(UIViewController*)vc{
    
    UIAlertAction *leftAction =  lefttitle!=nil?[UIAlertAction actionWithTitle:lefttitle style:UIAlertActionStyleDefault handler:(leftHandle!=nil?leftHandle:nil)]:nil;
    UIAlertAction *rightAction = rightTitle!=nil?[UIAlertAction actionWithTitle:rightTitle style:UIAlertActionStyleDefault handler:(rightHandle!=nil?rightHandle:nil)]:nil;
    UIAlertController *con = [UIAlertController alertControllerWithTitle:title message:msg preferredStyle:UIAlertControllerStyleAlert];
    if (leftAction!=nil) {
        
        [con addAction:leftAction];
    }
    if (rightAction!=nil) {
        
        [con addAction:rightAction];
    }
    
    [vc presentViewController:con animated:YES completion:nil];
    
}
+ (void)alertWithTitle:(NSString*)title message:(NSString *)msg btnTitle:(NSString *)btnTitle btnHandle:(void (^)(UIAlertAction *action))btnHandle vc:(UIViewController*)vc{
    
    [self alertWithTitle:title message:msg leftTitle:btnTitle leftHandle:btnHandle rightTitle:nil rightHandle:nil vc:vc];
}
+ (void)alertWithTitle:(NSString*)title message:(NSString *)msg btnTitle:(NSString *)btnTitle vc:(UIViewController*)vc{
    
    [self alertWithTitle:title message:msg btnTitle:btnTitle btnHandle:nil vc:vc];
}
+ (void)alertWithmessage:(NSString *)msg btnTitle:(NSString *)btnTitle vc:(UIViewController*)vc{
    
    [self alertWithTitle:@"提示" message:msg btnTitle:btnTitle vc:vc];
}

//  调取相册
//- (UIImagePickerController *)imgController{
//    
//    if (_imgController==nil) {
//        
//        _imgController = [UIImagePickerController new];
////        _imgController.delegate = self;
//        _imgController.allowsEditing = NO;
//    }
//    return _imgController;
//}
///** 相册 */
//- (void)PtotoActionWithTarget:(UIViewController*)target resultHandle:(void (^)(UIImage* img))resultHandle{
//    
//    if (resultHandle!=nil) {
//        
//        _block = resultHandle;
//    }
//    
//    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]){
//        
//        self.imgController.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
//        [target presentViewController:_imgController animated:YES completion:^{
////            ScannerTool(@"调取相册");
//        }];
//        
//    }
//}
//- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
//    
//    _imgController.allowsEditing = YES;
//    if (picker.sourceType==UIImagePickerControllerSourceTypeCamera) {
//        
//        UIImageWriteToSavedPhotosAlbum([info objectForKey:UIImagePickerControllerEditedImage], nil, nil, nil);
//        
//    }else{
//        
//    }
//    if (_block) {
//        
//        _block([info objectForKey:UIImagePickerControllerOriginalImage]);
//    }
//    
//    [_imgController dismissViewControllerAnimated:YES completion:nil];
//}

@end
