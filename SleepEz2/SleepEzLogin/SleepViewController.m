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
    NSDate *endtime = [NSDate date];
    _sleeping = NO;
    NSLog(@"No longer sleeping");
    
    _sleepBtn.hidden = NO;
    _stopsleepBtn.hidden = YES;
    
    NSLog(@"sending sleep data...");
    PFUser *usr = [PFUser currentUser];
    PFObject *object = [PFObject objectWithClassName:@"Sleep"];
    
    NSTimeInterval interval = [endtime timeIntervalSinceDate:_sleepTime];
    
    NSString* duration = [NSString stringWithFormat:@"%02li:%02li:%02li",
                     lround(floor(interval / 3600.)) % 100,
                     lround(floor(interval / 60.)) % 60,
                     lround(floor(interval)) % 60];
    
    object[@"userId"] = usr.objectId;
    NSLog(usr.objectId);
    object[@"beginSleep"] = _sleepTime;
    object[@"durationSleep"] = duration;
    [object saveInBackground];
}

//  Written by Yingjie Wu on 2014-11-09.

// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
- (void)applicationDidEnterBackground:(UIApplication *)application

{
    NSCalendar *gregCalrender = [[NSCalendar alloc]initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSDateComponents *dateComponent = [gregCalrender components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit fromDate:[NSDate date]];
    
    [dateComponent setYear:2014];
    
    [dateComponent setMonth:11];
    
    [dateComponent setDay:9];
    
    [dateComponent setHour:16];
    
    [dateComponent setMinute:31];
    
    UIDatePicker *dd = [[UIDatePicker alloc]init];
    
    [dd setDate:[gregCalrender dateFromComponents:dateComponent]];
    
    //UILocalNotification *notification = [[UILocalNotification alloc]init];
    
    //[notification setAlertBody: @" It's time to wake up!"];
    
    //[notification setFireDate:[NSDate dateWithTimeIntervalSinceNow:5]];
    
    // [notification setFireDate:dd.date];
    
    //[notification setTimeZone:[NSTimeZone defaultTimeZone]];
    
    //[application setScheduledLocalNotifications:[NSArray arrayWithObjects:notification]];
    
    NSDate *alarmTime = [[NSDate date] dateByAddingTimeInterval:5.0];
    
    UIApplication *app = [UIApplication sharedApplication];
    
    UILocalNotification *notifyAlarm = [[UILocalNotification alloc]init];
    
    if(notifyAlarm){
        notifyAlarm.fireDate = alarmTime;
        
        notifyAlarm.timeZone = [NSTimeZone defaultTimeZone];
        
        notifyAlarm.repeatInterval = 0;
        
        notifyAlarm.soundName=@"";
        
        notifyAlarm.alertBody=@"Time to Wake Up!";
        
        [app scheduleLocalNotification:notifyAlarm];
    }
}

// Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
- (void)applicationWillEnterForeground:(UIApplication *)application
{
    UIApplication *app =[UIApplication sharedApplication];

    NSArray *oldNotifications = [app scheduledLocalNotifications];

    if ([oldNotifications count]>0) {
        
        [app cancelAllLocalNotifications];
        
    }
}

@end
