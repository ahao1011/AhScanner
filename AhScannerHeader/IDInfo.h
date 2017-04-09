//
//  IDInfo.h
//  AhScanner
//
//  Created by ah on 2017/3/28.
//  Copyright © 2017年 ah. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface IDInfo : NSObject

@property (nonatomic,copy) NSString *type; //1:正面  2:反面
@property (nonatomic,copy) NSString *num; //身份证号
@property (nonatomic,copy) NSString *name; //姓名
@property (nonatomic,copy) NSString *gender; //性别
@property (nonatomic,copy) NSString *nation; //民族
@property (nonatomic,copy) NSString *address; //地址
@property (nonatomic,copy) NSString *issue; //签发机关
@property (nonatomic,copy) NSString *valid; //有效期
/**大图 1920*1080*/
@property (nonatomic,strong) UIImage *IDFaceImg;
/**小图 */
@property (nonatomic,strong) UIImage *IDFaceSubImg;
/**大图 1920*1080*/
@property (nonatomic,strong) UIImage *IDBackImg;
/**小图 */
@property (nonatomic,strong) UIImage *IDBackSubImg;

+ (instancetype)defaultInfo;


@end
