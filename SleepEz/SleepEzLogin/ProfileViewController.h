//
//  ProfileViewController.h
//  SleepEzLogin
//
//  Created by Ming Kai Chen on 2014-10-25.
//  Copyright (c) 2014 Ming Kai Chen. All rights reserved.
//

#import "ViewController.h"
#import <Parse/Parse.h>

@interface ProfileViewController : ViewController

@property (weak, nonatomic) IBOutlet UITextField *usrField;

@property (weak, nonatomic) IBOutlet UITextField *pwField;

@property (weak, nonatomic) IBOutlet UITextField *emailField;

@property (weak, nonatomic) IBOutlet UITextField *ageField;

- (IBAction)UpdateClick:(id)sender;

- (IBAction)ResetClick:(id)sender;

- (IBAction)LogoutClick:(id)sender;

@end
