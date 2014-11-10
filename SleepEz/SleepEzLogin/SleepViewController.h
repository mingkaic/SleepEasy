//
//  SleepViewController.h
//  SleepEzLogin
//
//  Created by Ming Kai Chen on 2014-10-25.
//  Copyright (c) 2014 Ming Kai Chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface SleepViewController : UIViewController



@property (weak, nonatomic) IBOutlet UIDatePicker *dateTimePicker;

- (void) presentMessage: (NSString *) msg;

- (void) scheduleLocalNotification: (NSDate*) fireDate;

- (IBAction)AlarmSet:(id)sender;

- (IBAction)AlarmCancel:(id)sender;

- (IBAction)RecordSleep:(id)sender;

- (IBAction)StopSleep:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *sleepBtn;

@property (weak, nonatomic) IBOutlet UIButton *stopsleepBtn;

@property BOOL sleeping;

@property (strong, nonatomic) NSDate *sleepTime;

@end
