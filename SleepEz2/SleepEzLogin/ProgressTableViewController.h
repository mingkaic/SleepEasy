//
//  ProgressTableViewController.h
//  SleepEz
//
//  Created by Ming Kai Chen on 2014-10-26.
//  Copyright (c) 2014 Ming Kai Chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface ProgressTableViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSMutableArray* sleepTimeData;
@property (strong, nonatomic) NSMutableArray* sleepDurData;

@property (strong, nonatomic) NSMutableArray* exercStartTimeData;
@property (strong, nonatomic) NSMutableArray* exercTimeData;
@property (strong, nonatomic) NSMutableArray* exercSpeedData;
@property (strong, nonatomic) NSMutableArray* exercDistData;

@end
