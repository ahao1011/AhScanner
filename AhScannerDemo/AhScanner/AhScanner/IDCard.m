//
//  IDCardFacade.m
//  AhScanner
//
//  Created by ah on 2017/3/27.
//  Copyright © 2017年 ah. All rights reserved.
//



#define IDWidth  (Iphone4?220:(Iphone5?250:(Iphone6?280:310)))
#define IDHeight  IDWidth * 1.574
#define IDPoint  CGRectMake(0, 0, IDWidth, IDHeight)
#define IDRect CGRectMake((K_ScreenWidth-IDWidth)*0.5, (K_ScreenHeight-IDHeight)*0.5, IDWidth, IDHeight)

#import "IDCard.h"


@interface IDCard ()
//  动画layer
@property (nonatomic,strong) CALayer *anilayer;
@property (nonatomic,strong) CAShapeLayer *IDMarginLayer;

@end

@implementation IDCard{
    
    IDCardType _type;
}

- (instancetype)initWithFrame:(CGRect)frame IDCardType:(IDCardType)type{
    self = [super initWithFrame:frame];
    if (self) {
        _type = type;
        self.backgroundColor = [UIColor clearColor];
        [self addIDWiodow];
    }
    return self;
}

/**添加身份证区域*/
- (void)addIDWiodow{
    
    // 扫描动画
    [self.layer addSublayer:self.anilayer];
    
    // ID边框线
    CAShapeLayer *IDMarginLayer = [CAShapeLayer layer];
    IDMarginLayer.position = self.layer.position;
    IDMarginLayer.bounds = IDPoint;
    IDMarginLayer.borderWidth = 2.0f;
    IDMarginLayer.borderColor = [UIColor whiteColor].CGColor;
    IDMarginLayer.cornerRadius = 15.0f;
    self.IDMarginLayer = IDMarginLayer;
    [self.layer addSublayer:IDMarginLayer];
    
    //  背景  半透明
    UIBezierPath *backpath = [UIBezierPath bezierPathWithRect:self.frame];
    // ID 镂空区  透明
    UIBezierPath *IDpath = [UIBezierPath bezierPathWithRoundedRect:IDMarginLayer.frame cornerRadius:15.0];
    
    [backpath appendPath:IDpath];
    [backpath setUsesEvenOddFillRule:YES];
    
    CAShapeLayer *filllayer = [CAShapeLayer layer];
    filllayer.path = backpath.CGPath;
    filllayer.fillRule = kCAFillRuleEvenOdd;
    filllayer.fillColor = [UIColor blackColor].CGColor;
    filllayer.opacity = 0.5;
    [self.layer addSublayer:filllayer];
    
    //  文字提示
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, K_ScreenWidth, 15)];
    label.text = _type==IDCardTypeFace? @"请将身份证正面放置该区域,对准头像进行扫描":@"请将身份证背面放置到白色指示区内,进行扫描";
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    CGPoint center = self.center;
    center.x = CGRectGetMaxX(IDMarginLayer.frame)+15;
    label.center = center;
    label.transform = CGAffineTransformMakeRotation(M_PI_2);
    [self addSubview:label];
    
//    //  头像有效区域
    if (_type==IDCardTypeFace) {
        
        CGFloat faceW = IDWidth*0.576;
        CGFloat faceH = faceW*0.763;
        CGFloat faceX = CGRectGetMaxX(self.IDMarginLayer.frame)-45-faceW;
        CGFloat faceY = CGRectGetMaxY(self.IDMarginLayer.frame)-40-faceH;
        self.faceRect = CGRectMake(faceX,faceY , faceW, faceH);
    }
    CABasicAnimation *ani = [CABasicAnimation animation];
    ani.keyPath = @"position";
    CGFloat lx = (K_ScreenWidth-IDWidth)*0.5;
    CGFloat ly = (K_ScreenHeight-IDHeight)*0.5+2;
    ani.fromValue = [NSValue valueWithCGPoint:CGPointMake(lx+IDWidth-7, ly)];
    ani.toValue =[NSValue valueWithCGPoint:CGPointMake(lx+7, ly)];    // 添加动画
    ani.duration = 1.8f; // 持续时间
    ani.repeatCount = MAXFLOAT;
    CAMediaTimingFunction *timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    ani.timingFunction =  timingFunction;
    [self.anilayer addAnimation:ani forKey:@"ah"];
}


- (void)drawRect:(CGRect)rect {

    if (_type==IDCardTypeFace) {
        //  头像有效区域
        CGFloat faceW = IDWidth*0.576;
        CGFloat faceH = faceW*0.763;
        CGFloat faceX = CGRectGetMaxX(self.IDMarginLayer.frame)-45-faceW;
        CGFloat faceY = CGRectGetMaxY(self.IDMarginLayer.frame)-40-faceH;
        self.faceRect = CGRectMake(faceX,faceY , faceW, faceH);
        
        // 头像示意图
        UIImageView *IDImg = [[UIImageView alloc] initWithFrame:self.faceRect];
        IDImg.image = [UIImage imageNamed:@"Resoure.bundle/icon/idcard_first_head_5"];
        IDImg.transform = CGAffineTransformMakeRotation(M_PI_2);
        IDImg.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:IDImg];
        // 头像边框
        [[UIColor whiteColor]set];
        UIRectFrame(self.faceRect);
    }
    
}
- (CALayer *)anilayer{
    
    if (_anilayer==nil) {
        
        _anilayer = [CALayer layer];
        _anilayer.anchorPoint = CGPointZero;
        _anilayer.bounds = CGRectMake(0, 0, 1, IDHeight-4);
        CGFloat lx = (K_ScreenWidth-IDWidth)*0.5+IDWidth;
        CGFloat ly = (K_ScreenHeight-IDHeight)*0.5+2;
        _anilayer.position = CGPointMake(lx,ly);
        _anilayer.backgroundColor = [UIColor yellowColor].CGColor;
    }
    return _anilayer;
}
- (void)dealloc{
    
    [self stopani];

}

- (void)stopani{
    
    [self.anilayer removeAnimationForKey:@"ah"];
}


@end
