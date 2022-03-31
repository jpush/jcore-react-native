//
//  RCTJCoreModule.m
//  RCTJCoreModule
//
//  Created by oshumini on 2017/8/8.
//  Copyright © 2017年 HXHG. All rights reserved.
//

#import "RCTJCoreModule.h"
#import "JGInforCollectionAuth.h"

@implementation RCTJCoreModule

#define JgLog(fmt, ...) NSLog((@"| JGER | iOS | " fmt), ##__VA_ARGS__)

RCT_EXPORT_MODULE(JCoreModule);

#pragma mark --- 设备信息采集授权接口（合规接口）
RCT_EXPORT_METHOD(setAuth: (BOOL *)enable)
{
    JgLog("JCollectionAuth %d",enable);
    __block BOOL isAuth= enable;
    [JGInforCollectionAuth JCollectionAuth:^(JGInforCollectionAuthItems * _Nonnull authInfo) {
        authInfo.isAuth = isAuth;
    }];
}

//事件处理
- (NSArray<NSString *> *)supportedEvents
{
    return @[];
}

@end
