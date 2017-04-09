//
//  AhIDViewController.m
//  AhScanner
//
//  Created by ah on 2017/3/28.
//  Copyright © 2017年 ah. All rights reserved.
//

#import "AhIDViewController.h"
#import "AhScannerManager.h"
#import "IDCard.h"
#import "ScannerHeader.h"

@interface AhIDViewController ()

@property (nonatomic,strong) AhScannerManager *manager;
@property (nonatomic,strong) IDCard *IDFace;
@end

@implementation AhIDViewController{
    
    IDCardType _type;
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [[[self.navigationController.navigationBar subviews] objectAtIndex:0] setAlpha:0];
    [self.manager checkAuthorizationStatus];
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [self.manager stopSession];
    _IDFace = nil;
    [[[self.navigationController.navigationBar subviews] objectAtIndex:0] setAlpha:1];
    [super viewWillDisappear:animated];
}

- (instancetype)initWithIDCardType:(IDCardType)type
{
    self = [super init];
    if (self) {
        
        _type = type;
    }
    return self;
}

- (AhScannerManager *)manager{
    
    if (_manager==nil) {
        
        _manager = [[AhScannerManager alloc]initWithIDCardType:_type];
        _manager.vc = self;
    }
    return _manager;
}

- (IDCard *)IDFace{
    
    if (_IDFace==nil) {
        
        _IDFace = [[IDCard alloc]initWithFrame:self.view.frame IDCardType:_type];
    }
    return _IDFace;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"扫描身份证";
    self.manager.faceDetectionFrame = self.IDFace.faceRect;
    [self.manager initializeIDCart];  //  与上边代码前后顺序不能调
    [self.view addSubview:self.IDFace];
    __unsafe_unretained AhIDViewController *weakself = self;
    self.manager.resultHandle = ^(IDInfo *info,IDCardType type){
        
        if (weakself.handle!=nil) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakself.IDFace stopani];
                weakself.handle(info,type);
                [weakself.navigationController popViewControllerAnimated:YES];
                
            }); 
        }
    };
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectZero];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
    //  功能区布局  这里写的就比较随便了,包括图片的命名, 放到项目里可以把这里规范下
    
    CGFloat cW = 40;
    CGFloat cH = 40;
    CGFloat cx = K_ScreenWidth - cW-20;
    CGFloat cy = K_ScreenHeight - cH -18;
    
    UIButton *closeBtn = [[UIButton alloc]initWithFrame:CGRectMake(cx, cy, cW, cH)];
    [closeBtn setImage:[UIImage imageNamed:@"Resoure.bundle/icon/close"] forState:UIControlStateNormal];
    closeBtn.transform = CGAffineTransformMakeRotation(M_PI_2);
    closeBtn.titleLabel.textColor = [UIColor whiteColor];
    closeBtn.backgroundColor = [UIColor blackColor];
    closeBtn.alpha = 0.65;
    closeBtn.layer.cornerRadius = closeBtn.frame.size.width * 0.5;
    [closeBtn addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:closeBtn];
    
    CGFloat sx = cx-20-cW;
    UIButton *SBtn = [[UIButton alloc]initWithFrame:CGRectMake(sx, cy, cW, cH)];
    [SBtn setImage:[UIImage imageNamed:@"Resoure.bundle/icon/dtg"] forState:UIControlStateNormal];
    SBtn.titleLabel.textColor = [UIColor whiteColor];
    SBtn.transform = CGAffineTransformMakeRotation(M_PI_2);
    SBtn.backgroundColor = [UIColor blackColor];
    SBtn.alpha = 0.65;
    SBtn.layer.cornerRadius = SBtn.frame.size.width * 0.5;
    [SBtn addTarget:self action:@selector(shan:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:SBtn];
    
    CGFloat cex = sx-20-cW;
    UIButton *CBtn = [[UIButton alloc]initWithFrame:CGRectMake(cex, cy, cW, cH)];
    [CBtn setImage:[UIImage imageNamed:@"Resoure.bundle/icon/xc"] forState:UIControlStateNormal];
    CBtn.transform = CGAffineTransformMakeRotation(M_PI_2);
    CBtn.titleLabel.textColor = [UIColor whiteColor];
    CBtn.backgroundColor = [UIColor blackColor];
    CBtn.alpha = 0.65;
    CBtn.layer.cornerRadius = CBtn.frame.size.width * 0.5;
    [CBtn addTarget:self action:@selector(xiangce) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:CBtn];
    

    
}
- (void)shan:(UIButton*)btn{
    
    [self.manager manipulateTorch:^(BOOL result) {
        
        if (result) {
            
            [btn setImage:[UIImage imageNamed:@"Resoure.bundle/icon/dtk"] forState:UIControlStateNormal];


        }else{
             [btn setImage:[UIImage imageNamed:@"Resoure.bundle/icon/dtg"] forState:UIControlStateNormal];
        }
    }];
}

- (void)close{
    
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)xiangce{
    
    ScannerLog(@"暂未实现");
//    [[ScannerTool defaultTool]PtotoActionWithTarget:self resultHandle:^(UIImage *img) {
//        
//        //  暂未实现 有大神可以尝试解决下 
////        CMSampleBufferRef sampleBuffer = [UIImage sampleBufferFromCGImage:img.CGImage];
////        [self.manager IDCardRecognit:CMSampleBufferGetImageBuffer(sampleBuffer)];
//    }];
}



@end
