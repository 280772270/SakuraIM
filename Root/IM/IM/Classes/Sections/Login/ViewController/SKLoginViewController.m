//
//  SKLoginViewController.m
//  IM
//
//  Created by Tec_yifei on 17/2/16.
//  Copyright © 2017年 Tec_yifei. All rights reserved.
//

#import "SKLoginViewController.h"
#import <AVFoundation/AVFoundation.h>
@interface SKLoginViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;
@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *userPasswordTextField;
@property (weak, nonatomic) IBOutlet UIButton *registButton;

@end

@implementation SKLoginViewController

-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.userNameTextField.tintColor = [UIColor whiteColor];
    [self.userNameTextField setValue:UIColorFromRGBA(0xffffff, .6f) forKeyPath:@"_placeholderLabel.textColor"];
    self.userPasswordTextField.tintColor = [UIColor whiteColor];
    [self.userPasswordTextField setValue:UIColorFromRGBA(0xffffff, .6f) forKeyPath:@"_placeholderLabel.textColor"];
    //TextFiled的ClearButton KVC
    UIButton *pwdClearButton = [self.userPasswordTextField valueForKey:@"_clearButton"];
    [pwdClearButton setImage:[UIImage imageNamed:@"login_icon_clear"] forState:UIControlStateNormal];
    UIButton *userNameClearButton = [self.userNameTextField valueForKey:@"_clearButton"];
    [userNameClearButton setImage:[UIImage imageNamed:@"login_icon_clear"] forState:UIControlStateNormal];
    self.navigationItem.title = @"登录";
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc]
                                     initWithTitle:@"撤退"
                                     style:UIBarButtonItemStylePlain
                                     target:self
                                     action:nil];

    self.navigationItem.backBarButtonItem = cancelButton;
    
}

- (IBAction)registClick:(id)sender {
    SKLoginViewController *vc = [[SKLoginViewController alloc]init];
    vc.navigationItem.title = @"注册";
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
}

#pragma mark - KeyBoardNotification

- (void)keyboardWillShow:(NSNotification *)notification{
    NSDictionary * userinfo = notification.userInfo;
    NSTimeInterval animationDuration;
    UIViewAnimationCurve animationCurve;
    CGRect keyBoardFrame;
    [[userinfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
    [[userinfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
    [[userinfo objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyBoardFrame];
    
    //animation
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:animationDuration];
    [UIView setAnimationCurve:animationCurve];
    CGFloat bottomSpacing = 10.0f;
    UIView *inputView = self.userPasswordTextField.superview;
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
