//
//  ProgressTableViewController.m
//  SleepEz
//
//  Created by Ming Kai Chen on 2014-10-26.
//  Copyright (c) 2014 Ming Kai Chen. All rights reserved.
//

#import "ProgressTableViewController.h"
#import "TableCell.h"
#import "AppDelegate.h"
#import "SaveAndLoad.h"

@interface ProgressTableViewController ()
{
    NSManagedObjectContext *context;
}
@end

@implementation ProgressTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _formatter= [[NSDateFormatter alloc] init];
    _formatter.timeZone = [NSTimeZone defaultTimeZone];
    _formatter.timeStyle = NSDateFormatterShortStyle;
    _formatter.dateStyle = NSDateFormatterShortStyle;
    
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    
    AppDelegate *appdelegate = [[UIApplication sharedApplication]delegate];
    context = [appdelegate managedObjectContext];
}

- (void)viewDidAppear:(BOOL)animated
{
    [self retrieveData]; // refreshes whenever reviewing progress tab
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// retrieve from Parse
- (void)retrieveData
{
    _sleepData = [[NSMutableArray alloc] init];
    _exercData = [[NSMutableArray alloc] init];
    
    // attempt to login if not already:
    SaveAndLoad *load = [[SaveAndLoad alloc] init];
    PFUser *user = [PFUser currentUser];
    if (!user) {
        NSEntityDescription *entitydesc = [NSEntityDescription entityForName: @"User" inManagedObjectContext:context];
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        [request setEntity: entitydesc];
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat: @"username like %@", [load loadID]];
        [request setPredicate:predicate];
        
        NSError *error;
        NSArray *matchingData = [context executeFetchRequest:request error:&error];
        if (matchingData.count <= 0)
            return; // Can't do anything :(
        NSManagedObject *locUser = matchingData[0];
        [PFUser logInWithUsernameInBackground:[load loadID] password:[locUser valueForKey: @"password"] block:^(PFUser* user, NSError *error) {
            if (!error) {
                // authentication successful
                NSLog(@"online login credentials correct");
            }
            else {
                NSLog(@"Exception: %@", error); // damn
                return;
            }
        }];
        user = [PFUser currentUser];
    }
    
    // local data
    NSMutableArray *localSleep = [self localRetrieval:@"Sleep"];
    NSMutableArray *localExerc = [self localRetrieval:@"SleepEzExerc"];
    
    if (!user) {
        _sleepData = localSleep;
        _exercData = localExerc;
        return;
    }
    
    // parse data
    NSMutableArray *parseSleep = [self parseRetrieval:@"Sleep"];
    NSMutableArray *parseExerc = [self parseRetrieval:@"Exercise"];
    
    // synchronize
    NSMutableArray *parse = [[NSMutableArray alloc] init];
    NSMutableArray *local = [[NSMutableArray alloc] init];
    
    NSEntityDescription *entitydescSleep= [NSEntityDescription entityForName: @"Sleep" inManagedObjectContext:context];
    NSEntityDescription *entitydescExerc= [NSEntityDescription entityForName: @"SleepEzExerc" inManagedObjectContext:context];
    
    // comparing sleep parse to local sleep
    if (parseSleep.count > localSleep.count) { // download from online to local
        for (NSManagedObject *object in localSleep) {
            [local addObject: [object valueForKey:@"starttime"]];
        }
        for (PFObject *object in parseSleep) {
            if ([local containsObject: object[@"beginSleep"]])
                [parseSleep removeObject:object];
        }
        // populate local
        for (PFObject *object in parseSleep) {
            NSManagedObject *newSleep = [[NSManagedObject alloc] initWithEntity:entitydescSleep insertIntoManagedObjectContext:context];
            
            [newSleep setValue: [load loadID] forKey:@"username"];
            [newSleep setValue: object[@"beginSleep"] forKey:@"starttime"];
            [newSleep setValue: object[@"durationSleep"] forKey:@"duration"];
            NSError *error;
            [context save:&error];
        }
        _sleepData = [self localRetrieval:@"Sleep"];
    }
    if (parseSleep.count < localSleep.count) { // upload from local to online
        for (PFObject *object in parseSleep) {
            [parse addObject: object[@"beginSleep"]];
        }
        for (NSManagedObject *object in localSleep) {
            if ([parse containsObject: [object valueForKey: @"starttime"]])
                [localSleep removeObject:object];
        }
        // update parse
        for (NSManagedObject *object in localSleep) {
            
            PFObject *parseObject = [PFObject objectWithClassName:@"Sleep"];
            
            parseObject[@"userId"] = user.objectId;
            parseObject[@"beginSleep"] = [object valueForKey: @"starttime"];
            parseObject[@"durationSleep"] = [object valueForKey: @"duration"];
            [parseObject saveInBackground];
        }
        _sleepData = localSleep;
    }
    localSleep = nil;
    
    [parse removeAllObjects];
    [local removeAllObjects];
    // comparing exerc parse to local exerc
    if (parseExerc.count > localExerc.count) { // download from online to local
        for (NSManagedObject *object in localExerc) {
            [local addObject: [object valueForKey:@"starttime"]];
        }
        for (PFObject *object in parseExerc) {
            if ([local containsObject: object[@"BeginTime"]])
                [parseExerc removeObject:object];
        }
        // populate local
        for (PFObject *object in parseExerc) {
            NSManagedObject *newExerc = [[NSManagedObject alloc] initWithEntity:entitydescExerc insertIntoManagedObjectContext:context];
            
            [newExerc setValue: [load loadID] forKey:@"username"];
            [newExerc setValue: object[@"BeginTime"] forKey:@"starttime"];
            [newExerc setValue: object[@"runtime"] forKey:@"duration"];
            [newExerc setValue: object[@"speed"] forKey:@"speed"];
            [newExerc setValue: object[@"distance"] forKey:@"distance"];
            NSError *error;
            [context save:&error];
        }
        _exercData = [self localRetrieval:@"SleepEzExerc"];
    }
    if (parseExerc.count < localExerc.count) { // upload from local to online
        for (PFObject *object in parseExerc) {
            [parse addObject: object[@"BeginTime"]];
        }
        for (NSManagedObject *object in localExerc) {
            if ([parse containsObject: [object valueForKey: @"starttime"]])
                [localExerc removeObject:object];
        }
        // update parse
        for (NSManagedObject *object in localExerc) {
            
            PFObject *parseObject = [PFObject objectWithClassName:@"Exercise"];
            
            parseObject[@"userId"] = user.objectId;
            parseObject[@"BeginTime"] = [object valueForKey: @"starttime"];
            parseObject[@"runtime"] = [object valueForKey: @"duration"];
            parseObject[@"speed"] = [object valueForKey: @"speed"];
            parseObject[@"distance"] = [object valueForKey: @"distance"];
            [parseObject saveInBackground];
        }
        _exercData = localExerc;
    }
    localExerc = nil;
}

- (NSMutableArray *) localRetrieval: (NSString *) entity
{
    NSMutableArray *retArr = [[NSMutableArray alloc] init];
    SaveAndLoad *load = [[SaveAndLoad alloc] init];
    
    NSEntityDescription *entitydesc= [NSEntityDescription entityForName: entity inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSPredicate *predicate = [NSPredicate predicateWithFormat: @"username like %@", [load loadID]];
    NSError *error;
    [request setPredicate:predicate];
    [request setEntity: entitydesc];
    
    NSArray *locArr = [context executeFetchRequest:request error:&error];
    for (NSManagedObject *object in locArr) {
        [retArr addObject:object];
    }
    
    return retArr;
}

- (NSMutableArray *) parseRetrieval: (NSString *) entity
{
    PFUser *user = [PFUser currentUser];
    if (!user)
        return [[NSMutableArray alloc] init];
    
    PFQuery *query = [PFQuery queryWithClassName:entity];
    NSMutableArray *parseData = [NSMutableArray array];
    
    [query whereKey:@"userId" equalTo:user.objectId];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        NSLog(@"Retrieving %@ data...", entity);
        if (!error) {
            // search successful.
            for (PFObject* object in objects) {
                [parseData addObject: object];
            }
            NSLog(@"end %@ retrieval", entity);
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
    return parseData;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"section %lu", (long unsigned)section);
    // Return the number of rows in the section.
    if (section == 0) {
        return _sleepData.count;
    }
    else {
        return _exercData.count;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return @"Sleep Data";
    }
    else {
        return @"Exercise Data";
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"TableCell";
    TableCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    int row = [indexPath row];
    
    if (indexPath.section == 0) {
        NSLog(@"Populating sleep row %d", row);
        NSDate* start = [_sleepData[row] valueForKey:@"starttime"];
        cell.DurationLabel.text = [_sleepData[row] valueForKey:@"duration"];
        
        cell.StartLabel.text = [_formatter stringFromDate: start];
        cell.SpeedLabel.hidden = cell.DistanceLabel.hidden =
        cell.SpeedTag.hidden = cell.DistanceTag.hidden = YES;
    }
    else {
        NSLog(@"Populating exercise row %d", row);
        NSDate* start = [_exercData[row] valueForKey:@"starttime"];
        cell.DurationLabel.text = [_exercData[row] valueForKey:@"duration"];
        cell.SpeedLabel.text = [_exercData[row] valueForKey:@"speed"];
        cell.DistanceLabel.text = [_exercData[row] valueForKey:@"distance"];
        
        cell.StartLabel.text = [_formatter stringFromDate: start];
        cell.SpeedLabel.hidden = cell.DistanceLabel.hidden =
        cell.SpeedTag.hidden = cell.DistanceTag.hidden = NO;
    }
    
    return cell;
}

// Override to support editing the table view.
// limitation: can only remove from online version
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    SaveAndLoad *load = [[SaveAndLoad alloc] init];
    NSMutableArray* search;
    PFQuery *query;
    if (indexPath.section == 0) {
        query = [PFQuery queryWithClassName:@"Sleep"];
        search = _sleepData;
    } else {
        query = [PFQuery queryWithClassName:@"Exercise"];
        search = _exercData;
    }
    
    NSDate *comObj = [search[indexPath.row] valueForKey:@"starttime"];
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete local data source
        [context deleteObject:search[indexPath.row]];
        
        // Delete the row from the online data source
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (!error) {
                if (!objects) {
                    NSLog(@"Did not find a match");
                    return;
                }
                for (PFObject *object in objects) {
                    if (search == _sleepData) {
                        if ([object[@"beginSleep"] compare: comObj] == NSOrderedSame) {
                            NSLog(@"found");
                            [object deleteInBackground];
                        }
                    } else {
                        if ([object[@"BeginTime"] compare: comObj] == NSOrderedSame) {
                            NSLog(@"found");
                            [object deleteInBackground];
                        }
                    }
                }
            }
        }];
        [search removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else {
        NSLog(@"Unhandled editing style! %d", editingStyle);
    }
    NSLog(@"finished deleting %d", indexPath.row);
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
