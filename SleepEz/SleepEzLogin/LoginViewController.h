//
//  LoginViewController.h
//  SleepEzLogin
//
//  Created by Ming Kai Chen on 2014-10-24.
//  Copyright (c) 2014 Ming Kai Chen. All rights reserved.
//

#import "ViewController.h"

@interface LoginViewController : ViewController

@property (weak, nonatomic) IBOutlet UITextField *usernametxt;

@property (weak, nonatomic) IBOutlet UITextField *passwordtxt;

- (IBAction)LoginClick:(id)sender;

- (IBAction)SignupClick:(id)sender;
@end