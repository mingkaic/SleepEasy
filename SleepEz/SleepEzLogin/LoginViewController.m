//
//  LoginViewController.m
//  SleepEzLogin
//
//  Created by Ming Kai Chen on 2014-10-24.
//  Copyright (c) 2014 Ming Kai Chen. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    
    if (![defaults boolForKey:@"registered"]) {
        NSLog(@"No user registered");
        _loginBtn.hidden = YES;
    }
    else {
        NSLog(@"user is registered");
        _repwField.hidden = YES;
        _mailField.hidden = YES;
        _signupBtn.hidden = YES;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)SignupClick:(id)sender
{
    @try {
        if([[self.usrField text] isEqualToString:@""] ||
           [[self.pwField text] isEqualToString:@""] ||
           [[self.repwField text] isEqualToString:@""] ||
           [[self.mailField text] isEqualToString:@""]) {
            // empty input
            [self alertStatus:@"You must complete all fields" :@"Oooops!" :0];
        } else {
            // access and request matching identity verification from database
            [self checkPasswordMatch];
        }
    }
    @catch (NSException * e) {
        NSLog(@"Exception: %@", e);
        [self alertStatus:@"Signup Failed." :@"Error!" :0];
    }
}

- (void) checkPasswordMatch {
    if ([_pwField.text isEqualToString:_repwField.text]) {
        NSLog(@"Passwords match");
        [self registerNewUser];
    }
    else {
        [self alertStatus:@"Your entered passwords do not match." :@"Oooops!" :0];
    }
}

- (void) registerNewUser
{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    //PFObject* usrData = [PFObject objectWithClassName:@"usrData"];
    
    [defaults setObject:_usrField.text forKey:@"username"];
    [defaults setObject:_pwField.text forKey:@"password"];
    [defaults setObject:_mailField.text forKey:@"email"];
    [defaults setBool:YES forKey:@"registered"];
    
    [self performSegueWithIdentifier:@"login_success" sender:self];
    [self alertStatus:@"you have registered a new user" : @"Success!" :0];
}

- (IBAction)LoginClick:(id)sender
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    @try {
        if([_usrField.text isEqualToString: [defaults objectForKey:@"username"]] &&
           [_pwField.text isEqualToString: [defaults objectForKey:@"password"]]) {
            _usrField.text = nil;
            _pwField.text = nil;
            // verification successful
            NSLog(@"login credentials correct");
            [self performSegueWithIdentifier:@"login_success" sender:self];
        } else {
            [self alertStatus:@"Incorrect Username or Password" :@"Sign in Failed!" :0];
        }
    }
    @catch (NSException * e) {
        NSLog(@"Exception: %@", e);
        [self alertStatus:@"Login Failed." :@"Error!" :0];
    }
}

@end