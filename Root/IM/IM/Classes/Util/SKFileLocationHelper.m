//
//  SKFileLocationHelper.m
//  IM
//
//  Created by Tec_yifei on 17/2/15.
//  Copyright © 2017年 Tec_yifei. All rights reserved.
//

#import "SKFileLocationHelper.h"
#import "SKConfig.h"

#define RDVideo (@"video")
#define RDImage (@"image")

@interface SKFileLocationHelper ()

+ (NSString *)filePathFirDir: (NSString *)direname filename: (NSString *)filename;

@end

@implementation SKFileLocationHelper

+ (BOOL)addSkipBackupAttrubuteToItemAtURL:(NSURL *)URL
{
    assert([[NSFileManager defaultManager] fileExistsAtPath:[URL path]]);
    
    NSError *error = nil;
    BOOL success = [URL setResourceValue:@(YES)
                                  forKey:NSURLIsExcludedFromBackupKey
                                   error:&error];
    if (!success) {
        DDLogError(@"Error exculuding %@ from backup %@", [URL lastPathComponent] ,error);
    }
    return success;
}

+ (NSString *)getAppDocumentPath
{
    static NSString *appDocumentPath = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *appKey = [SKConfig shareConfig].appKey;
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        appDocumentPath = [[NSString alloc]initWithFormat:@"%@/%@/",[paths objectAtIndex:0],appKey];
        if (![[NSFileManager defaultManager] fileExistsAtPath:appDocumentPath])
        {
            [[NSFileManager defaultManager] createDirectoryAtPath:appDocumentPath
                                      withIntermediateDirectories:NO
                                                       attributes:nil
                                                            error:nil];
        }
        [SKFileLocationHelper addSkipBackupAttrubuteToItemAtURL:[NSURL fileURLWithPath:appDocumentPath]];
    });
    return appDocumentPath;
}

+ (NSString *)getAppTempPath
{
    return NSTemporaryDirectory();
}

+ (NSString *)userDirectory
{
    NSString *documentPath = [SKFileLocationHelper getAppDocumentPath];
    NSString *userID = [NIMSDK sharedSDK].loginManager.currentAccount;
    if ([userID length] == 0)
    {
        DDLogError(@"Error : Get User Directory While UserID is Empty");
    }
    NSString *userDirectory = [NSString stringWithFormat:@"%@/%@/",documentPath,userID];
    if (![[NSFileManager defaultManager] fileExistsAtPath:userDirectory])
    {
        [[NSFileManager defaultManager] createDirectoryAtPath:userDirectory
                                  withIntermediateDirectories:NO
                                                   attributes:nil
                                                        error:nil];
    }
    return userDirectory;
}

+ (NSString *)resourceDir: (NSString *)resouceName
{
    NSString *dir = [[SKFileLocationHelper userDirectory]stringByAppendingString:resouceName];
    if (![[NSFileManager defaultManager] fileExistsAtPath:dir]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:dir
                                  withIntermediateDirectories:NO
                                                   attributes:nil
                                                        error:nil];
    }
    return dir;
}

+ (NSString *)filepathForVideo:(NSString *)filename
{
    return [SKFileLocationHelper filePathFirDir:RDVideo
                                       filename:filename];
}

+ (NSString *)filepathForIamge:(NSString *)filename
{
    return [SKFileLocationHelper filePathFirDir:RDImage
                                       filename:filename];
}

+ (NSString *)genFilenameWithExt:(NSString *)ext
{
    CFUUIDRef uuid = CFUUIDCreate(nil);
    NSString *uuidString = (__bridge NSString *)CFUUIDCreateString(nil, uuid);
    CFRelease(uuid);
    NSString *uuidStr = [[uuidString stringByReplacingOccurrencesOfString:@"-" withString:@""] lowercaseString];
    NSString *name = [NSString stringWithFormat:@"%@",uuidStr];
    return [ext length] ? [NSString stringWithFormat:@"%@#.%@",name,ext]:name;
}

#pragma mark - 辅助方法
+ (NSString *)filePathFirDir:(NSString *)direname filename:(NSString *)filename
{
    return [[SKFileLocationHelper resourceDir:direname] stringByAppendingPathComponent:filename];
}

@end
