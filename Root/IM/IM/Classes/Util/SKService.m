//
//  SKService.m
//  IM
//
//  Created by Tec_yifei on 17/2/16.
//  Copyright © 2017年 Tec_yifei. All rights reserved.
//

#import "SKService.h"


#pragma mark - SKServiceMAnagerImpl
@interface SKServiceManagerImpl : NSObject
@property (nonatomic,strong)    NSString                *key;
@property (nonatomic,strong)    NSMutableDictionary     *singletons;

@end

@implementation SKServiceManagerImpl

+ (SKServiceManagerImpl *)coreImpl:(NSString *)key
{
    SKServiceManagerImpl *impl = [[SKServiceManagerImpl alloc]init];
    impl.key = key;
    return impl;
}

- (id)init
{
    if (self = [super init]) {
        _singletons = [[NSMutableDictionary alloc]init];
    }
    return self;
}

- (instancetype)singletonByClass:(Class)singlrtonClass
{
    NSString *singletonClassName = NSStringFromClass(singlrtonClass);
    id singleton = [_singletons objectForKey:singletonClassName];
    if (!singleton)
    {
        [_singletons setObject:singleton forKey:singletonClassName];
    }
    return singleton;
}

- (void)callSingletonSelector: (SEL)selector
{
    NSArray *array = [_singletons allValues];
    for (id obj in array)
    {
        if ([obj respondsToSelector:selector])
        {
            SuppressPerformSelectorLeakWarning([obj performSelector:selector]);
        }
    }
}

@end

#pragma mark - SKManagerService()
@interface SKServiceManager ()

@property (nonatomic,strong)    NSRecursiveLock         *lock;
@property (nonatomic,strong)    SKServiceManagerImpl    *core;
+ (instancetype)sharedManager;
- (id)singletonByClass:(Class)singletonClass;
@end

@implementation SKServiceManager

+ (instancetype)sharedManager
{
    static SKServiceManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[SKServiceManager alloc]init];
    });
    return instance;
}

- (id)init
{
    if (self = [super init]) {
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(callReceiveMemoryWarning)
                                                     name:UIApplicationDidReceiveMemoryWarningNotification
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(onEnterBackground)
                                                     name:UIApplicationDidEnterBackgroundNotification
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(onEnterForeground)
                                                     name:UIApplicationWillEnterForegroundNotification
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(onAppWillTerminate)
                                                     name:UIApplicationWillTerminateNotification
                                                   object:nil];
        
    }
    return self;
}

- (void)start
{
    [_lock lock];
    NSString *key = [[[NIMSDK sharedSDK] loginManager ]currentAccount];
    _core = [SKServiceManagerImpl coreImpl:key];
    [_lock unlock];
}

- (void)destory
{
    [_lock lock];
    [self callSingletonClean];
    _core = nil;
    [_lock unlock];
}

- (id)singletonByClass:(Class)singletonClass
{
    id instance = nil;
    [_lock lock];
    instance = [_core singletonByClass:singletonClass];
    [_lock unlock];
    return instance;
}

#pragma mark - CallFunction

- (void)callSingletonClean
{
    [self callSelector:@selector(onCleanData)];
}

- (void)callReceiveMemoryWarning
{
    [self callSelector:@selector(onReceiveMEmoryWaring)];
}

- (void)callEnterBackground
{
    [self callSelector:@selector(onEnterBackground)];
}

- (void)callOnenterForeground
{
    [self callSelector:@selector(onEnterForeground)];
}

- (void)callAppWillTerminated
{
    [self callSelector:@selector(onAppWillTerminate)];
}

- (void)callSelector:(SEL)selector
{
    [_core callSingletonSelector:selector];
}
@end

#pragma mark - SKService
@implementation SKService

+ (instancetype)sharedInstance
{
    return [[SKServiceManager sharedManager] singletonByClass:[self class]];
}

- (void)start
{
    DDLogDebug(@"SKService %@ Start" , self);
}

@end
