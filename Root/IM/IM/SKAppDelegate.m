//
//  SKAppDelegate.m
//  IM
//
//  Created by Tec_yifei on 17/2/15.
//  Copyright © 2017年 Tec_yifei. All rights reserved.
//

#import "SKAppDelegate.h"
#import "SKConfigDelegate.h"
#import "SKConfig.h"
#import "SKCustomAttachmentDecoder.h"
#import "SKCellLayoutConfig.h"
#import "SKLogManager.h"
#import "SKLogManager.h"
#import "SKNotificationCenter.h"
#import <UserNotifications/UserNotifications.h> //iOS 10 里面变了，更改之前的UINotification为UNNotification

NSString *SKNotifiCationLogOut = @"SKNotifiCationLogOut";
@interface SKAppDelegate ()

@property (nonatomic,strong) SKConfigDelegate *sdkConfigDelegate;

@end

@implementation SKAppDelegate

-(BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
    //注册 NIMSDK appkey 之前注册配置信息，是否需要多端同步，以及忽略通知
    self.sdkConfigDelegate = [[SKConfigDelegate alloc]init];
    [[NIMSDKConfig sharedConfig] setDelegate:self.sdkConfigDelegate];
    [[NIMSDKConfig sharedConfig] setShouldSyncUnreadCount:YES];
    
    //注册appkey
    NSString *appkey = [SKConfig shareConfig].appKey;
    NSString *cerName = [SKConfig shareConfig].cerName;
    [[NIMSDK sharedSDK] registerWithAppID:appkey
                                  cerName:cerName];
    
    //注册自定义消息的解析器
    [NIMCustomObject registerCustomDecoder:[SKCustomAttachmentDecoder new]];
    
    //注册 NIMKit 自定义消息排版配置
    [[NIMKit sharedKit] registerLayoutConfig:[SKCellLayoutConfig class]];
    
    
    [self setupServices];
    [self registapns];
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor grayColor];
    [self.window makeKeyAndVisible];
//    [application setStatusBarStyle:UIStatusBarStyleLightContent];
    
    
    return YES;
}

#pragma mark - misc apns
- (void)registapns
{
    [[UIApplication sharedApplication] registerForRemoteNotifications];
}

- (void)commonInitListListenEvents
{
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(Logout:)
                                                name:SKNotifiCationLogOut object:nil];
}

#pragma mark logOut
- (void)Logout:(NSNotification *)note
{
//    []
}

- (void)doLogout
{
    
}

#pragma mark - logic impl
- (void)setupServices
{
    [[SKLogManager sharedManager]start];
    [[SKNotificationCenter sharedCenter] start];
}
@end
