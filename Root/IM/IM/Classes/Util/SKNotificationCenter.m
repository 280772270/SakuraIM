//
//  SKNotificationCenter.m
//  IM
//
//  Created by Tec_yifei on 17/2/15.
//  Copyright © 2017年 Tec_yifei. All rights reserved.
//

#import "SKNotificationCenter.h"

@interface SKNotificationCenter ()<NIMSystemNotificationManagerDelegate,NIMNetCallManagerDelegate,NIMRTSConferenceManagerDelegate,NIMRTSManagerDelegate,NIMChatManagerDelegate>

@end

@implementation SKNotificationCenter

+  (instancetype)sharedCenter
{
    static SKNotificationCenter *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[SKNotificationCenter alloc]init];
    });
    return instance;
}

-(instancetype)init
{
    self = [super init];
    if (self) {
#pragma warning
        //提示音没加
        [[NIMSDK sharedSDK].systemNotificationManager addDelegate:self];
        [[NIMSDK sharedSDK].netCallManager addDelegate:self];
        [[NIMSDK sharedSDK].rtsManager addDelegate:self];
        [[NIMSDK sharedSDK].chatManager addDelegate:self];
    }
    return self;
}
- (void)start
{
    DDLogInfo(@"NOtification Center Setup");
}
@end
