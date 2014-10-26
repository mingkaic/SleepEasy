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
    _sleeping = NO;
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
    _sleeping = NO;
    NSLog(@"No longer sleeping");
    
    _sleepBtn.hidden = NO;
    _stopsleepBtn.hidden = YES;
    
    NSDate *endtime = [NSDate date];
    
    PFUser *usr = [PFUser currentUser];
    PFObject *object = [PFObject objectWithClassName:@"Sleep"];
    
    object[@"username"] = usr.username;
    object[@"beginSleep"] = _sleepTime;
    object[@"endSleep"] = endtime;
    [object saveInBackground];
}

@end
