//
//  ForgotViewController.h
//  SleepEz
//
//  Created by Ming Kai Chen on 2014-10-25.
//  Copyright (c) 2014 Ming Kai Chen. All rights reserved.
//

#import "ViewController.h"
#import <Parse/Parse.h>

@interface ForgotViewController : ViewController

@property (weak, nonatomic) IBOutlet UITextField *emailField;

- (IBAction)ResetPw:(id)sender;

- (IBAction)remember:(id)sender;

@end
