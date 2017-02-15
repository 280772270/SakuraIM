//
//  SKLogManager.m
//  IM
//
//  Created by Tec_yifei on 17/2/15.
//  Copyright © 2017年 Tec_yifei. All rights reserved.
//

#import "SKLogManager.h"
#import "SKBundleSettings.h"

@interface SKLogManager ()
{
    DDFileLogger *_fileLogger;
}

@end

@implementation SKLogManager

+ (instancetype)sharedManager{
    static SKLogManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[SKLogManager alloc]init];
    });
    return instance;
}

-(instancetype)init {
    self = [super init];
    if (self) {
        [DDLog addLogger:[DDASLLogger sharedInstance]];
        [DDLog addLogger:[DDTTYLogger sharedInstance]];
        [[DDTTYLogger sharedInstance] setColorsEnabled:YES];
        [[DDTTYLogger sharedInstance] setForegroundColor:[UIColor greenColor] backgroundColor:nil forFlag:DDLogFlagDebug];
        _fileLogger = [[DDFileLogger alloc]init];
        _fileLogger.rollingFrequency = 60 * 60 * 24; //24小数
        _fileLogger.logFileManager.maximumNumberOfLogFiles = 7;
        [DDLog addLogger:_fileLogger];
    }
    return self;
    
}

- (void)start
{
    DDLogInfo(@"APP started SDK Version %@\nBundle Setting: %@",[[NIMSDK sharedSDK] sdkVersion] , [SKBundleSettings sharedCongig]);
}
@end
