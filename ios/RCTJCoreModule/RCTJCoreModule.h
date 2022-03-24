//
//  RCTJCoreModule.h
//  RCTJCoreModule
//
//  Created by oshumini on 2017/8/8.
//  Copyright © 2017年 HXHG. All rights reserved.
//

#import <Foundation/Foundation.h>
#if __has_include(<React/RCTBridge.h>)
#import <React/RCTEventEmitter.h>
#import <React/RCTRootView.h>
#import <React/RCTBridge.h>
#elif __has_include("RCTBridge.h")
#import "RCTEventEmitter.h"
#import "RCTRootView.h"
#import "RCTBridge.h"
#endif

#import <React/RCTRootView.h>
#import <React/RCTBundleURLProvider.h>

@interface RCTJCoreModule : RCTEventEmitter<RCTBridgeModule>

@end
