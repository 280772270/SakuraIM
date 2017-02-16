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
#import "SKLoginManager.h"
#import "SKService.h"
#import "SKMainTabController.h"
#import "SKLoginViewController.h"
#import <UserNotifications/UserNotifications.h> //iOS 10 里面变了，更改之前的UINotification为UNNotification

NSString *SKNotifiCationLogOut = @"SKNotifiCationLogOut";
@interface SKAppDelegate ()<NIMLoginManagerDelegate>

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
    [self setupMainController];
    
    return YES;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    [[[NIMSDK sharedSDK] loginManager] removeDelegate:self];
}

#pragma mark - ApplicationDelefate

- (void)applicationWillResignActive:(UIApplication *)application{
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application{
    NSInteger count = [[[NIMSDK sharedSDK] conversationManager ]allUnreadCount];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:count];
}

- (void)applicationWillEnterForeground:(UIApplication *)application{
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application{
    
}

- (void)applicationWillTerminate:(UIApplication *)application{
    
}

- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(nonnull NSData *)deviceToken
{
    [[NIMSDK sharedSDK] updateApnsToken:deviceToken];
    DDLogInfo(@"didRegisterForRemoteNotificationsWithDeviceToken : %@" ,deviceToken);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    DDLogInfo(@"receive remote notification : %@" , userInfo);
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    DDLogInfo(@"fail get apns token Error : %@" , error);
}

#pragma mark - misc apns
- (void)registapns
{
    [[UIApplication sharedApplication] registerForRemoteNotifications];
}

- (void)setupMainController
{
    LoginData *data = [[SKLoginManager sharedManager] currentLoginData];
    NSString *account = [data account];
    NSString *token = [data token];
    
    if ([account length] && [token length])
    {
        [[[NIMSDK sharedSDK] loginManager] autoLogin:account
                                               token:token];
        [[SKServiceManager sharedManager] start];
        SKMainTabController *mainTab = [[SKMainTabController alloc]initWithNibName:nil bundle:nil];
        self.window.rootViewController = mainTab;
    }else{
        [self setUpLoginViewController];
    }
}

- (void)commonInitListListenEvents
{
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(Logout:)
                                                name:SKNotifiCationLogOut object:nil];\
    
    [[[NIMSDK sharedSDK] loginManager ] addDelegate:self];
}

- (void)setUpLoginViewController
{
    SKLoginViewController *loginController = [[SKLoginViewController alloc]init];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:loginController];
    self.window.rootViewController = nav;
}

#pragma mark logOut
- (void)Logout:(NSNotification *)note
{
    [self doLogout];
}

- (void)doLogout
{
    [[SKLoginManager sharedManager] setCurrentLoginData:nil];
    [[SKServiceManager sharedManager]destory];
    [self setupMainController];
}

#pragma mark - logic impl
- (void)setupServices
{
    [[SKLogManager sharedManager]start];
    [[SKNotificationCenter sharedCenter] start];
}
@end
