//
//  SKLoginManager.m
//  IM
//
//  Created by Tec_yifei on 17/2/15.
//  Copyright © 2017年 Tec_yifei. All rights reserved.
//

#import "SKLoginManager.h"
#import "SKFileLocationHelper.h"

#define SKAccount @"account"
#define SkToken   @"token"

@interface LoginData ()<NSCoding>

@end

@implementation LoginData

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        _account    = [aDecoder decodeObjectForKey:SKAccount];
        _token      = [aDecoder decodeObjectForKey:SkToken];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    if ([_account length]) {
        [encoder encodeObject:_account forKey:SKAccount];
    }
    if ([_token length]) {
        [encoder encodeObject:_token forKey:SkToken];
    }
}

@end

@interface SKLoginManager ()
@property (nonatomic,copy)  NSString    *filepath;

@end

@implementation SKLoginManager

+ (instancetype)sharedManager
{
    static SKLoginManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *filepath = [[SKFileLocationHelper getAppDocumentPath]stringByAppendingPathComponent:@"nim_sdk_login_data"];
        instance = [[SKLoginManager alloc]initWithFilePath:filepath];
    });
    return instance;
}

-(instancetype)initWithFilePath:(NSString *)filepath
{
    self = [super init];
    if (self) {
        _filepath = filepath;
        [self readData];
    }
    return self;
}

-(void)setCurrentLoginData:(LoginData *)currentLoginData
{
    _currentLoginData = currentLoginData;
    [self saveData];
}



/*读写登录信息,从文件里读写用户密码*/
- (void)readData
{
    NSString *filepath = [self filepath];
    if ([[NSFileManager defaultManager] fileExistsAtPath:filepath]) {
        id object = [NSKeyedUnarchiver unarchiveObjectWithFile:filepath];
        _currentLoginData = [object isKindOfClass:[LoginData class]] ? object : nil;
        
    }
}

- (void)saveData
{
    NSData *data = [NSData data];
    if (_currentLoginData)
    {
        data = [NSKeyedArchiver archivedDataWithRootObject:_currentLoginData];
    }
    [data writeToFile:[self filepath] atomically:YES];
}

@end
