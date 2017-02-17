//
//  UIView+SK.h
//  IM
//
//  Created by Tec_yifei on 17/2/17.
//  Copyright © 2017年 Tec_yifei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (SK)

@property (nonatomic) CGFloat left;

@property (nonatomic) CGFloat top;

@property (nonatomic) CGFloat right;

@property (nonatomic) CGFloat bottom;

@property (nonatomic) CGFloat width;

@property (nonatomic) CGFloat height;

@property (nonatomic) CGFloat centerX;

@property (nonatomic) CGFloat centerY;

@property (nonatomic) CGPoint origin;

@property (nonatomic) CGSize size;

//找到自己的VC
- (UIViewController *)viewController;

@end

@interface UIView (SKPresent)

//弹出Present的窗口
- (void)presentView:(UIView *)view animated:(BOOL)animated complete:(void(^)()) complete;

//获取上一个View正在被present的view
- (UIView *)presentedView;

- (void)dissmissPresentedView:(BOOL)animated complete:(void (^)()) complete;

//被present的窗口本身的办法，如果自己是被present的，消失掉
- (void)hideSelf:(BOOL)animated complete:(void(^)()) complete;

@end
