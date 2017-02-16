//
//  SKService.h
//  IM
//
//  Created by Tec_yifei on 17/2/16.
//  Copyright © 2017年 Tec_yifei. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol SKService <NSObject>

@optional
- (void)onCleanData;
- (void)onReceiveMEmoryWaring;
- (void)onEnterBackground;
- (void)onEnterForeground;
- (void)onAppWillTerminate;

@end

@interface SKService : NSObject<SKService>
+ (instancetype) sharedInstance;

- (void)start;
@end

@interface SKServiceManager : NSObject

+ (instancetype)sharedManager;

- (void)start;
- (void)destory;

@end
