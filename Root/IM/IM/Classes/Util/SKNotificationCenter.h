//
//  SKNotificationCenter.h
//  IM
//
//  Created by Tec_yifei on 17/2/15.
//  Copyright © 2017年 Tec_yifei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SKNotificationCenter : NSObject

+ (instancetype)sharedCenter;
- (void)start;

@end
