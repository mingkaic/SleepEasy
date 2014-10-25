//
//  SignupViewController.m
//  SleepEzLogin
//
//  Created by Ming Kai Chen on 2014-10-24.
//  Copyright (c) 2014 Ming Kai Chen. All rights reserved.
//

#import "SignupViewController.h"

@interface SignupViewController ()

@end

@implementation SignupViewController

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

- (IBAction)SignupSubmission:(id)sender
{
    NSInteger success = 0;
    @try {
        
        if([[self.usernametxt text] isEqualToString:@""] ||
           [[self.passwordtxt text] isEqualToString:@""] ||
           [[self.emailtxt text] isEqualToString:@""]) {
            // empty input
            [self alertStatus:@"Please enter Username, Password, and Email" :@"Submission Failed!" :0];
            
        } else {
            // access and send input data to database
            success = 1;
        }
    }
    @catch (NSException * e) {
        NSLog(@"Exception: %@", e);
        [self alertStatus:@"Submission Failed." :@"Error!" :0];
    }
    if (success) {
        [self performSegueWithIdentifier:@"signup_login" sender:self];
    }
}

- (IBAction)BackToLogin:(id)sender {
    [self performSegueWithIdentifier:@"back_to_login" sender:self];
}

@end
