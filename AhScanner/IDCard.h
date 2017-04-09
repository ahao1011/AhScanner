//
//  IDCardFacade.h
//  AhScanner
//
//  Created by ah on 2017/3/27.
//  Copyright © 2017年 ah. All rights reserved.
//

//  🆔正面

#import <UIKit/UIKit.h>
#import "ScannerHeader.h"

@interface IDCard : UIView

/**检测的有效区.正面有效*/
@property (nonatomic,assign) CGRect faceRect;

- (instancetype)initWithFrame:(CGRect)frame IDCardType:(IDCardType)type;
- (void)stopani;
@end
