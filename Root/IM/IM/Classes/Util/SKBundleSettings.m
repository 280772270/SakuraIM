//
//  SKBundleSettings.m
//  IM
//
//  Created by Tec_yifei on 17/2/15.
//  Copyright © 2017年 Tec_yifei. All rights reserved.
//

#import "SKBundleSettings.h"

@implementation SKBundleSettings

+(instancetype)sharedCongig{
    static SKBundleSettings *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[SKBundleSettings alloc]init];
    });
    return instance;
}

-(NSArray *)ignoreTeamNotificationTypes{
    static NSArray *types = nil;
    if (types == nil) {
        NSString *value = [[NSUserDefaults standardUserDefaults] objectForKey:@"ignore_team_types"];
        if ([value isKindOfClass:[NSString class]])
        {
            NSString *typeDescription = [value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            if ([typeDescription length])
            {
                types = [typeDescription componentsSeparatedByString:@","];
            }
        }
    }
    if (types == nil)
    {
        types = [NSArray array];
    }
    return types;
}
@end
