//
//  AhIDViewController.h
//  AhScanner
//
//  Created by ah on 2017/3/28.
//  Copyright © 2017年 ah. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ScannerHeader.h"
typedef void(^AhIDViewControllerBlock)(IDInfo *info,IDCardType type);
@interface AhIDViewController : UIViewController
- (instancetype)initWithIDCardType:(IDCardType)type;
@property (nonatomic,copy) AhIDViewControllerBlock handle;
@end
