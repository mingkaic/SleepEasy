//
//  ProfileViewController.m
//  SleepEzLogin
//
//  Created by Ming Kai Chen on 2014-10-25.
//  Copyright (c) 2014 Ming Kai Chen. All rights reserved.
//

#import "ProfileViewController.h"

@interface ProfileViewController ()

@end

@implementation ProfileViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated {
    [self SetText];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)UpdateClick:(id)sender
{
    PFUser *user = [PFUser currentUser];
    user.username = _usrField.text;
    user.password = _pwField.text;
    user.email = _emailField.text;
    user[@"age"] = _ageField.text;
    [user saveInBackground];
}

- (IBAction)ResetClick:(id)sender
{
    [self SetText];
}

- (void) SetText
{
    PFUser *user = [PFUser currentUser];
    _usrField.text = user.username;
    _pwField.text = user.password;
    _emailField.text = user.email;
    _ageField.text = user[@"age"];
}

- (IBAction)LogoutClick:(id)sender
{
    [PFUser logOut];
    [self dismissViewControllerAnimated:YES
                             completion:nil];
}

@end
