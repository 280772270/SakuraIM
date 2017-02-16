//
//  SKMainTabController.m
//  IM
//
//  Created by Tec_yifei on 17/2/16.
//  Copyright © 2017年 Tec_yifei. All rights reserved.
//

#import "SKMainTabController.h"
#import "SKAppDelegate.h"
@interface SKMainTabController ()

@end

@implementation SKMainTabController

+ (instancetype)instance
{
    SKAppDelegate *delegate = (SKAppDelegate *)[UIApplication sharedApplication].delegate;
    UIViewController *vc = delegate.window.rootViewController;
    if ([vc isKindOfClass:[SKMainTabController class]])
    {
        return (SKMainTabController *) vc;
    }
    else{
        return nil;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
