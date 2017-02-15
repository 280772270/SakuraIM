//
//  SKConfigDelegate.m
//  IM
//
//  Created by Tec_yifei on 17/2/15.
//  Copyright © 2017年 Tec_yifei. All rights reserved.
//

#import "SKConfigDelegate.h"
#import "SKBundleSettings.h"

@implementation SKConfigDelegate
-(BOOL)shouldIgnoreNotification:(NIMNotificationObject *)notification{
    BOOL ignore = NO;
    NIMNotificationContent *content = notification.content;
    if ([content isKindOfClass:[NIMNotificationContent class]]) {//忽略部分通知的示范
        NSArray *types = [[SKBundleSettings sharedCongig] ignoreTeamNotificationTypes];
        NIMTeamOperationType type = [(NIMTeamNotificationContent *)content operationType];
        for (NSString *item in types)
        {
            if (type == [item integerValue])
            {
                ignore = YES;
                break;
            }
        }
        
    }
    return ignore;
}
@end
