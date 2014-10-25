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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)LogoutClick:(id)sender {
    [self dismissViewControllerAnimated:YES
                             completion:nil];
}
@end
