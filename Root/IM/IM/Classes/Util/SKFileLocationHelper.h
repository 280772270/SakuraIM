//
//  SKFileLocationHelper.h
//  IM
//
//  Created by Tec_yifei on 17/2/15.
//  Copyright © 2017年 Tec_yifei. All rights reserved.
//

#import <Foundation/Foundation.h>

#define ImageExt (@"jpg")

@interface SKFileLocationHelper : NSObject

+ (NSString *)getAppDocumentPath;

+ (NSString *)getAppTempPath;

+ (NSString *)userDirectory;

+ (NSString *)genFilenameWithExt:(NSString *)ext;

+ (NSString *)filepathForVideo:(NSString *)filename;

+ (NSString *)filepathForIamge:(NSString *)filename;


@end
