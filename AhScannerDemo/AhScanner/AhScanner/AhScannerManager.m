//
//  AhScannerManager.m
//  AhScanner
//
//  Created by ah on 2017/3/28.
//  Copyright © 2017年 ah. All rights reserved.
//

#import "AhScannerManager.h"
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "ScannerHeader.h"
#import "excards.h"
#import "IDInfo.h"

@interface AhScannerManager ()<AVCaptureVideoDataOutputSampleBufferDelegate,AVCaptureMetadataOutputObjectsDelegate>

/**摄像头*/
@property (nonatomic,strong) AVCaptureDevice *device;
/**输入数据源,负责管理设备端口  是设备的抽象*/
@property (nonatomic, strong) AVCaptureDeviceInput* videoInput;
/**捕获会话*/
@property (nonatomic,strong) AVCaptureSession *session;
@property (nonatomic,strong) AVCaptureVideoDataOutput *videoDataOutput;
/**输出格式*/
@property (nonatomic,strong) NSNumber *outPutSetting;
/**（用户图像识别）*/
@property (nonatomic,strong) AVCaptureMetadataOutput *metadataOutput;
/**预览图层*/
@property (nonatomic,strong) AVCaptureVideoPreviewLayer *previewLayer;
/**videoDataOutput队列*/
@property (nonatomic,strong) dispatch_queue_t queue;
/**是否打开手电筒*/
@property (nonatomic,assign) BOOL torchOn;
/**是否检测到有效区域*/
@property (nonatomic,assign) BOOL effectiveDetection;
/**是否启用图像识别*/
@property (nonatomic,assign) BOOL faceEable;
@end

@implementation AhScannerManager{
    
    IDCardType _type;
}



//  懒加载
- (void)setVc:(UIViewController *)vc{
    
    if (vc==nil) {
        ScannerLog(@"AhScannerManager中的vc不能为nil");
    }
    _vc = vc;
}
- (AVCaptureDevice *)device{
    
    if (_device==nil) {
        
        _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        NSError *error =nil;
        if ([_device lockForConfiguration:&error]) {  //  锁定设备
            
            [_device isSmoothAutoFocusSupported]?_device.smoothAutoFocusEnabled=YES:ScannerLog(@"不支持平滑对焦");
            [_device isFocusModeSupported:AVCaptureFocusModeContinuousAutoFocus]?_device.focusMode = AVCaptureFocusModeContinuousAutoFocus:ScannerLog(@"不支持持续曝光");
            [_device isWhiteBalanceModeSupported:AVCaptureWhiteBalanceModeContinuousAutoWhiteBalance]?_device.whiteBalanceMode = AVCaptureWhiteBalanceModeContinuousAutoWhiteBalance :ScannerLog(@"不支持自动持续白平衡");
            [_device unlockForConfiguration]; // 解锁设备
            
        }
    }
    
    return _device;
}
- (AVCaptureSession *)session{
    
    if (_session==nil) {
        
        _session = [[AVCaptureSession alloc]init];
        //    AVCaptureSessionPresetHigh  m默认
        _session.sessionPreset = AVCaptureSessionPresetHigh;
        
        if ([_session canAddInput:self.videoInput]) {
            
            [_session addInput:self.videoInput];
        }
        if ([_session canAddOutput:self.videoDataOutput]) {
            [_session addOutput:self.videoDataOutput];
        }
        
        if ([_session canAddOutput:self.metadataOutput] && _type==IDCardTypeFace) {
            
            [_session addOutput:self.metadataOutput];
            
            self.metadataOutput.metadataObjectTypes = @[AVMetadataObjectTypeFace];
        }
        
    }
    return _session;
}

-(NSNumber *)outPutSetting {
    if (_outPutSetting == nil) {
        _outPutSetting = @(kCVPixelFormatType_420YpCbCr8BiPlanarVideoRange);
    }
    
    return _outPutSetting;
}
- (AVCaptureDeviceInput *)videoInput{
    
    if (_videoInput == nil) {
        
        NSError *error = nil;
        _videoInput = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:&error];
        if (error) {
            
            [ScannerTool alertWithmessage:@"未检测到摄像头" btnTitle:@"知道了" vc:self.vc];
        }
    }
    
    return _videoInput;
}

- (AVCaptureVideoDataOutput *)videoDataOutput{
    
    if (_videoDataOutput==nil) {
        
        _videoDataOutput = [[AVCaptureVideoDataOutput alloc]init];
        _videoDataOutput.videoSettings = @{(id)kCVPixelBufferPixelFormatTypeKey:self.outPutSetting};
        _videoDataOutput.alwaysDiscardsLateVideoFrames = YES;
        
        
//        dispatch_queue_t queue = dispatch_queue_create("AhSanner_VideoData_queue", NULL);
//        
//        [_videoDataOutput setSampleBufferDelegate:self queue:queue];
        
    }
    
    return _videoDataOutput;
}

- (AVCaptureVideoPreviewLayer *)previewLayer{
    
    if (_previewLayer==nil) {
        
        _previewLayer = [[AVCaptureVideoPreviewLayer alloc]initWithSession:self.session];
        _previewLayer.frame = self.vc.view.frame;
        _previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    }
    return _previewLayer;
}

- (AVCaptureMetadataOutput *)metadataOutput{
    
    if (_metadataOutput==nil) {
        _metadataOutput = [[AVCaptureMetadataOutput alloc]init];
        dispatch_queue_t queue = dispatch_queue_create("AhSanner_medataData_queue", NULL);
        [_metadataOutput setMetadataObjectsDelegate:self queue:queue];
    }
    return _metadataOutput;
}

- (dispatch_queue_t)queue{
    
    if (_queue==nil) {
        _queue = dispatch_queue_create( "AhSanner_VideoData_queue", 0);
    }
    return _queue;
}

- (void)startSession{
    
    [self.session isRunning]?NULL:(dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{[self.session startRunning];}));
}

- (void)stopSession{
    
    [self.session isRunning]?(dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{[self.session stopRunning];})):NULL;
    
}
- (void)manipulateTorch:(void (^)(BOOL))resulthandle{
    
    self.torchOn = !self.torchOn;
    
    if ([self.device hasTorch]) {
        [self.device lockForConfiguration:nil];// 请求独占访问硬件设备
        self.torchOn?[self.device setTorchMode:AVCaptureTorchModeOn]:[self.device setTorchMode:AVCaptureTorchModeOff];
        [self.device unlockForConfiguration];// 请求解除独占访问硬件设备
        if (resulthandle!=nil) {
            resulthandle(self.torchOn);
        }
        
    }else{
        [ScannerTool alertWithmessage:@"手机中未检测到闪光灯" btnTitle:@"知道了" vc:self.vc];
    }
}
- (void)checkAuthorizationStatus{
    
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    
    switch (status) {
        case AVAuthorizationStatusNotDetermined:[self showAuthorizationNotDetermined]; break;// 用户尚未决定授权与否，那就请求授
        case AVAuthorizationStatusAuthorized:[self showAuthorizationAuthorized]; break;// 用户已授权，那就立即使用
        case AVAuthorizationStatusDenied:[self showAuthorizationDenied]; break;// 用户明确地拒绝授权，那就展示提示
        case AVAuthorizationStatusRestricted:[self showAuthorizationRestricted]; break;// 无法访问相机设备，那就展示提示

    }
}
-(void)showAuthorizationNotDetermined {
    __weak __typeof__(self) weakSelf = self;
    [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
        granted? [weakSelf startSession]: [weakSelf showAuthorizationDenied];
    }];
}
-(void)showAuthorizationAuthorized {
    [self startSession];
}

-(void)showAuthorizationDenied {
    [ScannerTool alertWithTitle:@"提示" message:@"相机未授权,请前往设置" btnTitle:@"去设置" btnHandle:^(UIAlertAction *action) {
        // 跳转到该应用的隐私设授权置界面
//        [[UIApplication sharedApplication] openURL:];
        [[UIApplication sharedApplication ]openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{} completionHandler:^(BOOL success) {
            
            [self startSession];
        }];
    } vc:self.vc];
}
-(void)showAuthorizationRestricted {
    [ScannerTool alertWithTitle:@"提示" message:@"无法唤起相机,请检查设备硬件是否正常" btnTitle:@"知道了" btnHandle:nil vc:self.vc];
}

//  图像区域检测  做检测区域与目标区域对比 当检测区域>目标区域时  截取图像 进行下面的图像识别工作
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    
    if (metadataObjects.count>0 && _type == IDCardTypeFace) {
        
        AVMetadataMachineReadableCodeObject *ReadableCodeObject = metadataObjects.firstObject;
        AVMetadataObject *transformedMetadataObject = [self.previewLayer transformedMetadataObjectForMetadataObject:ReadableCodeObject];
        ScannerLog(@"didOutputMetadataObjects_AVMetadataObject:%@",transformedMetadataObject);
        CGRect faceRegion = transformedMetadataObject.bounds;
        
        if (ReadableCodeObject.type == AVMetadataObjectTypeFace) {
            
             ScannerLog(@"是否包含头像：%d, facePathRect: %@, faceRegion: %@",CGRectContainsRect(self.faceDetectionFrame, faceRegion),NSStringFromCGRect(self.faceDetectionFrame),NSStringFromCGRect(faceRegion));
            if (CGRectContainsRect(self.faceDetectionFrame, faceRegion)) {
                
                if (self.videoDataOutput.sampleBufferDelegate==nil  ) {
                    
                    dispatch_queue_t queue = dispatch_queue_create("AhSanner_VideoData_queue", NULL);
                    [self.videoDataOutput setSampleBufferDelegate:self queue:queue];
                }
            }
        }
    }
}

// AVCaptureVideoDataOutput获取实时图像，这个代理方法的回调频率很快，几乎与手机屏幕的刷新频率一样快
-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection {
    
        
    if ([self.outPutSetting isEqualToNumber:[NSNumber numberWithInt:kCVPixelFormatType_420YpCbCr8BiPlanarVideoRange]] || [self.outPutSetting isEqualToNumber:[NSNumber numberWithInt:kCVPixelFormatType_420YpCbCr8BiPlanarFullRange]]) {
        
        CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
        
        if ([captureOutput isEqual:self.videoDataOutput]) {
            // 身份证信息识别
            [self IDCardRecognit:imageBuffer];
            
            // 身份证信息识别完毕后，就将videoDataOutput的代理去掉，防止频繁调用AVCaptureVideoDataOutputSampleBufferDelegate方法而引起的“混乱”
            if (self.videoDataOutput.sampleBufferDelegate&& _type==IDCardTypeFace) {
                [self.videoDataOutput setSampleBufferDelegate:nil queue:self.queue];
            }
        }
    } else {
        ScannerLog(@"输出格式不支持");
    }
    
}
- (void)IDCardRecognit:(CVImageBufferRef)imageBuffer {
    
    CVBufferRetain(imageBuffer);
    
    // Lock the image buffer
    if (CVPixelBufferLockBaseAddress(imageBuffer, 0) == kCVReturnSuccess) {
        size_t width= CVPixelBufferGetWidth(imageBuffer);// 1920
        size_t height = CVPixelBufferGetHeight(imageBuffer);// 1080
        
        CVPlanarPixelBufferInfo_YCbCrBiPlanar *planar = CVPixelBufferGetBaseAddress(imageBuffer);
        size_t offset = NSSwapBigIntToHost(planar->componentInfoY.offset);
        size_t rowBytes = NSSwapBigIntToHost(planar->componentInfoY.rowBytes);
        unsigned char* baseAddress = (unsigned char *)CVPixelBufferGetBaseAddress(imageBuffer);
        unsigned char* pixelAddress = baseAddress + offset;
        
        static unsigned char *buffer = NULL;
        if (buffer == NULL) {
            buffer = (unsigned char *)malloc(sizeof(unsigned char) * width * height);
        }
        
        memcpy(buffer, pixelAddress, sizeof(unsigned char) * width * height);
        
        unsigned char pResult[1024];
        int ret = EXCARDS_RecoIDCardData(buffer, (int)width, (int)height, (int)rowBytes, (int)8, (char*)pResult, sizeof(pResult));
        if (ret <= 0) {
            NSLog(@"ret=[%d]", ret);
        } else {
            NSLog(@"ret=[%d]", ret);
            
            // 播放一下“拍照”的声音，模拟拍照
            AudioServicesPlaySystemSound(1108);
            
            if ([self.session isRunning]) {
                [self.session stopRunning];
            }
            
            char ctype;
            char content[256];
            int xlen;
            int i = 0;
            
            IDInfo *iDInfo = [IDInfo defaultInfo];
            
            ctype = pResult[i++];
            
            //            iDInfo.type = ctype;
            while(i < ret){
                ctype = pResult[i++];
                NSLog(@"测试:%c",ctype);
                for(xlen = 0; i < ret; ++i){
                    if(pResult[i] == ' ') { ++i; break; }
                    content[xlen++] = pResult[i];
                    NSLog(@"测试内容:%s",content);
                }
                
                content[xlen] = 0;
                
                if(xlen) {
                    NSStringEncoding gbkEncoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
                    if(ctype == 0x21) {
                        iDInfo.num = [NSString stringWithCString:(char *)content encoding:gbkEncoding];
                    } else if(ctype == 0x22 && _type==IDCardTypeFace) {
                        iDInfo.name = [NSString stringWithCString:(char *)content encoding:gbkEncoding];
                    } else if(ctype == 0x23&& _type==IDCardTypeFace) {
                        iDInfo.gender = [NSString stringWithCString:(char *)content encoding:gbkEncoding];
                    } else if(ctype == 0x24&& _type==IDCardTypeFace) {
                        iDInfo.nation = [NSString stringWithCString:(char *)content encoding:gbkEncoding];
                    } else if(ctype == 0x25&& _type==IDCardTypeFace) {
                        iDInfo.address = [NSString stringWithCString:(char *)content encoding:gbkEncoding];
                    } else if(ctype == 0x26&& _type==IDCardTypeBack ) {
                        iDInfo.issue = [NSString stringWithCString:(char *)content encoding:gbkEncoding];
                    } else if(ctype == 0x27&& _type==IDCardTypeBack) {
                        iDInfo.valid = [NSString stringWithCString:(char *)content encoding:gbkEncoding];
                    }
                }
            }
            
            if (iDInfo) {// 读取到身份证信息，实例化出IDInfo对象后，截取身份证的有效区域，获取到图像
                ScannerLog(@"\n正面\n姓名：%@\n性别：%@\n民族：%@\n住址：%@\n公民身份证号码：%@\n\n反面\n签发机关：%@\n有效期限：%@",iDInfo.name,iDInfo.gender,iDInfo.nation,iDInfo.address,iDInfo.num,iDInfo.issue,iDInfo.valid);
                
                CGRect effectRect = [RectManager getEffectImageRect:CGSizeMake(width, height)];
                CGRect rect = [RectManager getGuideFrame:effectRect];
                if (_type==IDCardTypeFace) {
                    
                    iDInfo.IDFaceImg = [UIImage getImageStream:imageBuffer];
                    iDInfo.IDFaceSubImg = [UIImage getSubImage:rect inImage:iDInfo.IDFaceImg];
                }else{
                    iDInfo.IDBackImg = [UIImage getImageStream:imageBuffer];
                    iDInfo.IDBackSubImg = [UIImage getSubImage:rect inImage:iDInfo.IDBackImg];
                }
               
                if (_resultHandle!=nil) {
                    
                    _resultHandle(iDInfo,_type);
                }
                [self stopSession];
               
                
            }
        }
        
        CVPixelBufferUnlockBaseAddress(imageBuffer, 0);
    }
    
    CVBufferRelease(imageBuffer);
}

- (void)initializeIDCart{
    
    const char *thePath = [[[NSBundle mainBundle] resourcePath] UTF8String];
    int ret = EXCARDS_Init(thePath);
    if (ret != 0) {
        NSLog(@"初始化失败：ret=%d", ret);
    }
    
    // 添加预览图层
    [self.vc.view.layer addSublayer:self.previewLayer];
   
    if ( _type==IDCardTypeFace) {
        self.metadataOutput.rectOfInterest = [self.previewLayer metadataOutputRectOfInterestForRect:self.faceDetectionFrame];

    }
}


- (instancetype)initWithIDCardType:(IDCardType)type
{
    self = [super init];
    if (self) {
        
        _type = type;
        [self initializeData];
    }
    return self;
}
/**设备初始化*/
- (void)initializeData{
    
    self.torchOn = NO;
    
    if (_type==IDCardTypeFace) {
        
        [self.videoDataOutput setSampleBufferDelegate:nil queue:self.queue];
    }else{
        [self.videoDataOutput setSampleBufferDelegate:self queue:self.queue];
    }
    
}


@end
