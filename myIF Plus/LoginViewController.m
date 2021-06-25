//
//  LoginViewController.m
//  myIF Plus
//
//  Created by THAICOM-MAC on 7/7/2557 BE.
//  Copyright (c) 2557 Thaicom Plc. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [[event allTouches] anyObject];
    
    if([self.txtUserName isFirstResponder] && [touch view] != self.txtUserName){
        [self.txtUserName resignFirstResponder];
    }
    if([self.txtPassword isFirstResponder] && [touch view] != self.txtPassword){
        [self.txtPassword resignFirstResponder];
    }
}
- (IBAction)Close:(id)sender {
    [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationSlideLeftLeft];
}

- (IBAction)btnLogin:(id)sender {
}

- (IBAction)btnForgetPassword:(id)sender {
}

- (IBAction)btnRegister:(id)sender {
}
@end
