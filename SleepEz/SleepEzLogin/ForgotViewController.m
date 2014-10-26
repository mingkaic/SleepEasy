//
//  ForgotViewController.m
//  SleepEz
//
//  Created by Ming Kai Chen on 2014-10-25.
//  Copyright (c) 2014 Ming Kai Chen. All rights reserved.
//

#import "ForgotViewController.h"

@interface ForgotViewController ()

@end

@implementation ForgotViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)ResetPw:(id)sender {
    [PFUser requestPasswordResetForEmailInBackground:_emailField.text];
    [self performSegueWithIdentifier:@"remember" sender:self];
}

- (IBAction)remember:(id)sender {
    [self performSegueWithIdentifier:@"remember" sender:self];
}
@end
