//
//  SignupViewController.h
//  SleepEzLogin
//
//  Created by Ming Kai Chen on 2014-10-24.
//  Copyright (c) 2014 Ming Kai Chen. All rights reserved.
//

#import "ViewController.h"

@interface SignupViewController : ViewController

@property (weak, nonatomic) IBOutlet UITextField *usernametxt;

@property (weak, nonatomic) IBOutlet UITextField *passwordtxt;

@property (weak, nonatomic) IBOutlet UITextField *emailtxt;

- (IBAction)SignupSubmission:(id)sender;

- (IBAction)BackToLogin:(id)sender;
@end