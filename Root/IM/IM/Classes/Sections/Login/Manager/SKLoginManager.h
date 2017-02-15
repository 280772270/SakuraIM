//
//  SKLoginManager.h
//  IM
//
//  Created by Tec_yifei on 17/2/15.
//  Copyright © 2017年 Tec_yifei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LoginData : NSObject
@property (nonatomic,copy)  NSString *account;
@property (nonatomic,copy)  NSString *token;

@end

@interface SKLoginManager : NSObject
+ (instancetype)sharedManager;

@property (nonatomic,strong)    LoginData   *currentLoginData;
@end
