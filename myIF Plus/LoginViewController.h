//
//  LoginViewController.h
//  myIF Plus
//
//  Created by THAICOM-MAC on 7/7/2557 BE.
//  Copyright (c) 2557 Thaicom Plc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIViewController+MJPopupViewController.h"

@protocol LoginViewPopupDelegate;

@interface LoginViewController : UIViewController

@property (assign, nonatomic) id <LoginViewPopupDelegate>delegate;

@property (weak, nonatomic) IBOutlet UITextField *txtUserName;
@property (weak, nonatomic) IBOutlet UITextField *txtPassword;

- (IBAction)btnLogin:(id)sender;
- (IBAction)btnForgetPassword:(id)sender;

- (IBAction)btnRegister:(id)sender;

@end
