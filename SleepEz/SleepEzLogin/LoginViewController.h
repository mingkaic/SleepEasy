//
//  LoginViewController.h
//  SleepEzLogin
//
//  Created by Ming Kai Chen on 2014-10-24.
//  Copyright (c) 2014 Ming Kai Chen. All rights reserved.
//

#import "ViewController.h"
#import <Parse/Parse.h>

@interface LoginViewController : ViewController

@property (weak, nonatomic) IBOutlet UITextField *usrField;

@property (weak, nonatomic) IBOutlet UITextField *pwField;

@property (weak, nonatomic) IBOutlet UITextField *repwField;

@property (weak, nonatomic) IBOutlet UITextField *mailField;

@property (weak, nonatomic) IBOutlet UIButton *loginBtn;

@property (weak, nonatomic) IBOutlet UIButton *signupBtn;

- (IBAction)SignupClick:(id)sender;

- (IBAction)LoginClick:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *manRegBtn;

@property (weak, nonatomic) IBOutlet UIButton *manLogBtn;

- (IBAction)ManualRegister:(id)sender;

- (IBAction)ManualLogin:(id)sender;

@property BOOL loginscreen;

@end