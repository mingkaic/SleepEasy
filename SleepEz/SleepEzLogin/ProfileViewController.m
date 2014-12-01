//
//  ProfileViewController.m
//  SleepEzLogin
//
//  Created by Ming Kai Chen on 2014-10-25.
//  Copyright (c) 2014 Ming Kai Chen. All rights reserved.
//

#import "ProfileViewController.h"
#import "AppDelegate.h"
#import "SaveAndLoad.h"

@interface ProfileViewController ()
{
    NSManagedObjectContext *context;
}
@end

@implementation ProfileViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blueColor];
    
    AppDelegate *appdelegate = [[UIApplication sharedApplication]delegate];
    context = [appdelegate managedObjectContext];
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
    NSEntityDescription *entitydesc = [NSEntityDescription entityForName: @"User" inManagedObjectContext:context];
    NSManagedObject *newUser = [[NSManagedObject alloc] initWithEntity:entitydesc insertIntoManagedObjectContext:context];
    
    [newUser setValue: _usrField.text forKey:@"username"];
    [newUser setValue: _emailField.text forKey:@"email"];
    [newUser setValue: _pwField.text forKey:@"password"];
    [newUser setValue: _ageField.text forKey:@"age"];
    NSError *error;
    [context save:&error];
    
    PFUser *user = [PFUser currentUser];
    
    if (user) {
        user.username = _usrField.text;
        user.password = _pwField.text;
        user.email = _emailField.text;
        user[@"age"] = _ageField.text;
        [user saveInBackground];
    }
}

- (IBAction)ResetClick:(id)sender
{
    [self SetText];
}

- (void) SetText
{
    SaveAndLoad *load = [[SaveAndLoad alloc] init];
    
    NSEntityDescription *entitydesc = [NSEntityDescription entityForName: @"User" inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity: entitydesc];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat: @"username like %@", [load loadID]];
    [request setPredicate:predicate];
    
    NSError *error;
    NSArray *matchingData = [context executeFetchRequest:request error:&error];
    
    if (matchingData.count <= 0) {
        _usrField.text = [load loadID];
    } else {
        for (NSManagedObject *object in matchingData) {
            _usrField.text = [object valueForKey:@"username"];
            _pwField.text = [object valueForKey:@"password"];
            _emailField.text = [object valueForKey:@"email"];
            _ageField.text = [object valueForKey:@"age"];
        }
    }
}

- (IBAction)LogoutClick:(id)sender
{
    [PFUser logOut];
    [self dismissViewControllerAnimated:YES
                             completion:nil];
}

@end
