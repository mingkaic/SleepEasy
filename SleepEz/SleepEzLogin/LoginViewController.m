//
//  LoginViewController.m
//  SleepEzLogin
//
//  Created by Ming Kai Chen on 2014-10-24.
//  Copyright (c) 2014 Ming Kai Chen. All rights reserved.
//

#import "LoginViewController.h"
#import "AppDelegate.h"

@interface LoginViewController ()
{
    NSManagedObjectContext *context;
}
@end

@implementation LoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    AppDelegate *appdelegate = [[UIApplication sharedApplication]delegate];
    context = [appdelegate managedObjectContext];
}

- (void)viewDidAppear:(BOOL)animated {
    PFUser *user = [PFUser currentUser];
    if (user.username != nil) {
        [self performSegueWithIdentifier: @"login_success" sender:self];
    }
    
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    
    if (![defaults boolForKey:@"registered"]) {
        NSLog(@"No user registered");
        _loginscreen = NO;
    }
    else {
        NSLog(@"user is registered");
        _loginscreen = YES;
    }
    [self ScreenUpdate];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)ScreenUpdate
{
    _repwField.hidden = _mailField.hidden =
    _signupBtn.hidden = _manLogBtn.hidden = _loginscreen;
    _manRegBtn.hidden = _loginBtn.hidden = !_loginscreen;
}

- (void)ScreenClear
{
    _usrField.text = nil;
    _pwField.text = nil;
    _repwField.text = nil;
    _mailField.text = nil;
}

- (IBAction)SignupClick:(id)sender
{
    [_usrField resignFirstResponder];
    [_pwField resignFirstResponder];
    [_repwField resignFirstResponder];
    [_mailField resignFirstResponder];
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

- (void) checkPasswordMatch
{
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
    NSLog(@"registering new user...");
    
    SaveAndLoad *save = [[SaveAndLoad alloc] init];
    [save saveID: _usrField.text];
    
    // immediately save to local database
    NSEntityDescription *entitydesc = [NSEntityDescription entityForName: @"User" inManagedObjectContext:context];
    NSManagedObject *newUser = [[NSManagedObject alloc] initWithEntity:entitydesc insertIntoManagedObjectContext:context];
    
    [newUser setValue: _usrField.text forKey:@"username"];
    [newUser setValue: _mailField.text forKey:@"email"];
    [newUser setValue: _pwField.text forKey:@"password"];
    [newUser setValue: @"0" forKey:@"age"];
    NSError *error;
    [context save:&error];
    
    // default data
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:YES forKey:@"registered"];
    
    // parse data
    PFUser* newusr = [PFUser user];
    newusr.username = _usrField.text;
    newusr.email = _mailField.text;
    newusr.password = _pwField.text;
    [newusr signUpInBackgroundWithBlock: ^(BOOL succeeded, NSError *error) {
        if (!error) {
            NSLog(@"Online Registration successful");
            [self ScreenClear];
        }
        else {
            NSLog(@"There was an error in online registration");
        }
    }];
    [self performSegueWithIdentifier:@"login_success" sender:self];
}

- (IBAction)LoginClick:(id)sender
{
    SaveAndLoad *save = [[SaveAndLoad alloc] init];
    [save saveID: _usrField.text];
    
    NSEntityDescription *entitydesc = [NSEntityDescription entityForName: @"User" inManagedObjectContext:context];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity: entitydesc];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat: @"username like %@ and password like %@", _usrField.text, _pwField.text];
    [request setPredicate:predicate];
    
    NSError *error;
    NSArray *matchingData = [context executeFetchRequest:request error:&error];
    
    if (matchingData.count > 0) {
        NSLog(@"login credentials correct");
        [self ScreenClear];
        [self performSegueWithIdentifier:@"login_success" sender:self];
        return;
    }
    
    // uses parse server
    [PFUser logInWithUsernameInBackground:_usrField.text password:_pwField.text block:^(PFUser* user, NSError *error) {
        if (!error) {
            // save this into local data
            NSManagedObject *newUser = [[NSManagedObject alloc] initWithEntity:entitydesc insertIntoManagedObjectContext:context];
            
            [newUser setValue: _usrField.text forKey:@"username"];
            [newUser setValue: user.email forKey:@"email"];
            [newUser setValue: _pwField.text forKey:@"password"];
            [newUser setValue: user[@"age"] forKey:@"age"];
            NSError *error;
            [context save:&error];
            
            // authentication successful
            NSLog(@"login credentials correct");
            [self ScreenClear];
            [self performSegueWithIdentifier:@"login_success" sender:self];
        }
        else {
            NSLog(@"Exception: %@", error);
            [self alertStatus:@"Login Failed." :@"Oooops!" :0];
        }
    }];
}

// switch from login page to register page
- (IBAction)ManualRegister:(id)sender {
    _loginscreen = NO;
    [self ScreenClear];
    [self ScreenUpdate];
}

// switch from user page to login page
- (IBAction)ManualLogin:(id)sender {
    _loginscreen = YES;
    [self ScreenClear];
    [self ScreenUpdate];
}

- (IBAction)forgot_pw:(id)sender {
    [self performSegueWithIdentifier:@"forgot_pw" sender:self];
}
@end