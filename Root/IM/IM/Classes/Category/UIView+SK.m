//
//  UIView+SK.m
//  IM
//
//  Created by Tec_yifei on 17/2/17.
//  Copyright © 2017年 Tec_yifei. All rights reserved.
//

#import "UIView+SK.h"
#import <objc/runtime.h>

@implementation UIView (SK)

- (CGFloat)left{
    return self.frame.origin.x;
}

- (void)setLeft:(CGFloat)x{
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (CGFloat)top{
    return self.frame.origin.y;
}

- (void)setTop:(CGFloat)y{
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)right{
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setRight:(CGFloat)right{
    CGRect frame = self.frame;
    frame.origin.x = right - frame.size.width;
    self.frame = frame;
}

- (CGFloat)bottom{
    return self.frame.origin.y + self.frame.size.height;
}

- (CGFloat)centerX{
    return self.center.x;
}

- (void)setCenterX:(CGFloat)centerX{
    self.center = CGPointMake(centerX, self.center.y);
}

- (CGFloat)centerY{
    return self.center.y;
}

- (void)setCenterY:(CGFloat)centerY{
    self.center = CGPointMake(self.center.x, centerY);
}

- (CGFloat)width{
    return self.frame.size.width;
}

- (void)setWidth:(CGFloat)width{
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (CGFloat)height{
    return self.frame.size.height;
}

- (void)setHeight:(CGFloat)height{
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (CGPoint)origin{
    return self.frame.origin;
}

- (void)setOrigin:(CGPoint)origin{
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

- (CGSize)size{
    return self.frame.size;
}

- (void)setSize:(CGSize)size{
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

- (UIViewController *)viewController{
    for (UIView *next; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]])
        {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}

@end

@implementation UIView (SKPresent)

static char PresentedViewAddress;       //被Present的View
static char PresentingViewAddress;      //正在被Present其他视图的View

#define AnimationDuration .25f
- (void)presentView:(UIView *)view animated:(BOOL)animated complete:(void (^)())complete{
    if (!self.window) {
        return;
    }
    [self.window addSubview:view];
    objc_setAssociatedObject(self, &PresentedViewAddress, view, OBJC_ASSOCIATION_RETAIN);
    objc_setAssociatedObject(view, &PresentingViewAddress, self, OBJC_ASSOCIATION_RETAIN);
    if (animated)
    {
//        [self]
    }
}

#pragma mark - Animation
- (void)doAlertAnimate:(UIView *)view complete:(void(^)()) complete{
    CGRect bounds = view.bounds;
    //放大
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"bounds"];
    scaleAnimation.duration     = AnimationDuration;
    scaleAnimation.toValue      = [NSValue valueWithCGRect:CGRectMake(0, 0, 1, 1)];
    
    // 移动
    CABasicAnimation *moveAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
    moveAnimation.duration      = AnimationDuration;
    moveAnimation.toValue       = [NSValue valueWithCGPoint:[self.superview convertPoint:self.center toView:nil]];
    
    CAAnimationGroup *group     = [CAAnimationGroup animation];
    group.beginTime             = CACurrentMediaTime();
    group.duration              = AnimationDuration;
    group.animations            = [NSArray arrayWithObjects:moveAnimation,scaleAnimation    , nil];
    group.timingFunction        = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    group.fillMode              = kCAFillModeForwards;
    group.removedOnCompletion   = NO;
    group.autoreverses          = NO;
    
    [self hideAllSubView:view];
    [view.layer addAnimation:group forKey:@"groupAnimationAlert"];
    
    __weak UIView *WS = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(AnimationDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        view.layer.bounds       = bounds;
        view.layer.position     = WS.superview.center;
        [WS showAllSubView:view];
        if (complete) {
            complete();
        }
    });
    
}

static char *HideViewsAddress = "hideViewsAddress";
- (void)hideAllSubView:(UIView *)view{
    for (UIView * subView in self.subviews) {
        NSMutableArray *array = [[NSMutableArray alloc]init];
        if (subView.hidden) {
            [array addObject:subView];
        }
        objc_setAssociatedObject(self, &HideViewsAddress, array, OBJC_ASSOCIATION_RETAIN);
        subView.hidden = YES;
    }
}

- (void)showAllSubView:(UIView *)view{
    NSMutableArray *array = objc_getAssociatedObject(self, &HideViewsAddress);
    for (UIView *subView  in view.subviews) {
        subView.hidden = [array containsObject:subView];
    }
}
@end





