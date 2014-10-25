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
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)LoginClick:(id)sender
{
    NSInteger success = 0;
    @try {
        
        if([[self.usernametxt text] isEqualToString:@""] || [[self.passwordtxt text] isEqualToString:@""] ) {
            // empty input
            [self alertStatus:@"Please enter Username and Password" :@"Sign in Failed!" :0];
            
        } else {
            // access and request matching identity verification from database
            success = 1;
        }
    }
    @catch (NSException * e) {
        NSLog(@"Exception: %@", e);
        [self alertStatus:@"Sign in Failed." :@"Error!" :0];
    }
    if (success) {
        [self performSegueWithIdentifier:@"login_success" sender:self];
    }
}

- (IBAction)SignupClick:(id)sender
{
    [self performSegueWithIdentifier:@"signup"sender:self];
}

@end