//
//  SleepViewController.m
//  SleepEzLogin
//
//  Created by Ming Kai Chen on 2014-10-25.
//  Copyright (c) 2014 Ming Kai Chen. All rights reserved.
//

#import "SleepViewController.h"

@interface SleepViewController ()

@end

@implementation SleepViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self performSegueWithIdentifier: @"begin_login" sender:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
