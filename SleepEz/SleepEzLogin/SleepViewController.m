//
//  SleepViewController.m
//  SleepEzLogin
//
//  Created by Ming Kai Chen on 2014-10-25.
//  Copyright (c) 2014 Ming Kai Chen. All rights reserved.
//

#import "SleepViewController.h"
#import "AppDelegate.h"
#import "SaveAndLoad.h"

@interface SleepViewController ()
{
    NSManagedObjectContext *context;
}
@end

@implementation SleepViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor orangeColor];
    
    _dateTimePicker.datePickerMode=UIDatePickerModeTime;
    _sleeping = NO;
    
    AppDelegate *appdelegate = [[UIApplication sharedApplication]delegate];
    context = [appdelegate managedObjectContext];
}

- (void)viewDidAppear:(BOOL)animated {
    if (_sleeping) {
        _sleepBtn.hidden = YES;
        _stopsleepBtn.hidden = NO;
    }
    else {
        _sleepBtn.hidden = NO;
        _stopsleepBtn.hidden = YES;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void) presentMessage: (NSString *) msg
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Alarm Clock"
                                                        message:msg
                                                       delegate:self
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil, nil];
    [alertView show];
}

- (void) scheduleLocalNotification: (NSDate*) fireDate
{
    NSDateFormatter* datef = [[NSDateFormatter alloc] init];
    datef.timeZone = [NSTimeZone defaultTimeZone];
    datef.timeStyle = NSDateFormatterShortStyle;
    datef.dateStyle = NSDateFormatterShortStyle;
    NSString* dateTimeString = [datef stringFromDate: fireDate];
    
    NSLog(@"Alarm Set: %@", dateTimeString);
    
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    
    notification.fireDate = fireDate;
    notification.alertBody = @"WALK UP!";
    notification.soundName = @"sound.caf";
    
    [[UIApplication sharedApplication] scheduleLocalNotification: notification];
}

- (IBAction)AlarmSet:(id)sender
{
    NSLog(@"Alarm Set Tapped");
    
    [self scheduleLocalNotification:_dateTimePicker.date];
    
    [self presentMessage:@"Alarm Set"];
}

- (IBAction)AlarmCancel:(id)sender
{
    NSLog(@"Alarm Cancel Tapped");
    
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    
    [self presentMessage: @"Alarm cancelled"];
}

- (IBAction)RecordSleep:(id)sender {
    _sleeping = YES;
    NSLog(@"Sleeping");
    
    _sleepBtn.hidden = YES;
    _stopsleepBtn.hidden = NO;
    
    _sleepTime = [NSDate date];
}

- (IBAction)StopSleep:(id)sender {
    NSDate *endtime = [NSDate date];
    _sleeping = NO;
    NSLog(@"No longer sleeping");
    
    _sleepBtn.hidden = NO;
    _stopsleepBtn.hidden = YES;
    
    NSTimeInterval interval = [endtime timeIntervalSinceDate:_sleepTime];
    
    NSString* duration = [NSString stringWithFormat:@"%02li:%02li:%02li",
                          lround(floor(interval / 3600.)) % 100,
                          lround(floor(interval / 60.)) % 60,
                          lround(floor(interval)) % 60];
    
    NSLog(@"sending sleep data...");
    SaveAndLoad *load = [[SaveAndLoad alloc] init];
    NSEntityDescription *entitydesc = [NSEntityDescription entityForName: @"Sleep" inManagedObjectContext:context];
    NSManagedObject *newSleep = [[NSManagedObject alloc] initWithEntity:entitydesc insertIntoManagedObjectContext:context];
    
    [newSleep setValue: [load loadID] forKey:@"username"];
    [newSleep setValue: _sleepTime forKey:@"starttime"];
    [newSleep setValue: duration forKey:@"duration"];
    NSError *error;
    [context save:&error];
    
    PFUser *usr = [PFUser currentUser];
    PFObject *object = [PFObject objectWithClassName:@"Sleep"];
    
    if (usr) {
        object[@"userId"] = usr.objectId;
        object[@"beginSleep"] = _sleepTime;
        object[@"durationSleep"] = duration;
        [object saveInBackground];
    }
}

@end
