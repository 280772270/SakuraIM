//
//  SKBundleSettings.h
//  IM
//
//  Created by Tec_yifei on 17/2/15.
//  Copyright © 2017年 Tec_yifei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SKBundleSettings : NSObject

+ (instancetype)sharedCongig;

- (NSArray *)ignoreTeamNotificationTypes;           //需要忽略的群通知类型
@end
