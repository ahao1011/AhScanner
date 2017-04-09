//
//  IDInfo.m
//  AhScanner
//
//  Created by ah on 2017/3/28.
//  Copyright © 2017年 ah. All rights reserved.
//

#import "IDInfo.h"

@implementation IDInfo

+ (instancetype)defaultInfo{
    
    static IDInfo *mt = nil;
    // 线程锁
    @synchronized (self){
        
        if (!mt) {
            mt = [[self alloc]init];
        }
    }
    return mt;
}

@end
