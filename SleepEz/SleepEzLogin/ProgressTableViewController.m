//
//  ProgressTableViewController.m
//  SleepEz
//
//  Created by Ming Kai Chen on 2014-10-26.
//  Copyright (c) 2014 Ming Kai Chen. All rights reserved.
//

#import "ProgressTableViewController.h"
#import "TableCell.h"

@interface ProgressTableViewController ()

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
    //[self retrieveData];
}

- (void)viewDidAppear:(BOOL)animated
{
    [self retrieveData]; // refreshes whenever reviewing progress tab
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// retrieve from Parse
- (void)retrieveData
{
    _sleepTimeData = [NSMutableArray array];
    _sleepDurData = [NSMutableArray array];
    _exercStartTimeData = [NSMutableArray array];
    _exercTimeData = [NSMutableArray array];
    _exercSpeedData = [NSMutableArray array];
    _exercDistData = [NSMutableArray array];
    
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    formatter.timeZone = [NSTimeZone defaultTimeZone];
    formatter.timeStyle = NSDateFormatterShortStyle;
    formatter.dateStyle = NSDateFormatterShortStyle;
    
    PFQuery *query1 = [PFQuery queryWithClassName:@"Sleep"];
    PFQuery *query2 = [PFQuery queryWithClassName:@"Exercise"];
    PFUser *user = [PFUser currentUser];
    [query1 whereKey:@"userId" equalTo:user.objectId];
    [query1 findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        NSLog(@"Retrieving sleep data...");
        if (!error) {
            // search successful.
            NSLog(@"Successfully retrieved %lu data entries.", (unsigned long)objects.count);
            
            for (PFObject* object in objects) {
                NSDate* start = object[@"beginSleep"];
                NSString* time = [formatter stringFromDate: start];
                NSString* duration = object[@"durationSleep"];
                
                [_sleepTimeData addObject: time];
                [_sleepDurData addObject: duration];
            }
            // refresh section 1 once done querying
            NSRange range = NSMakeRange(0, 1);
            NSIndexSet *section = [NSIndexSet indexSetWithIndexesInRange:range];
            [self.tableView reloadSections:section withRowAnimation:UITableViewRowAnimationNone];
            NSLog(@"end sleep retrieval");
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
    [query2 whereKey:@"userId" equalTo:user.objectId];
    [query2 findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        NSLog(@"Retrieving exerc data...");
        if (!error) {
            // search successful.
            NSLog(@"Successfully retrieved %lu data entries.", (unsigned long)objects.count);
            
            for (PFObject* object in objects) {
                NSDate* start = object[@"BeginTime"];
                NSString* time = [formatter stringFromDate: start];
                NSString* duration = object[@"runtime"];
                NSString* speed = object[@"speed"];
                NSString* dist = object[@"distance"];
                
                NSLog(time);
                
                [_exercStartTimeData addObject: time];
                [_exercTimeData addObject: duration];
                [_exercSpeedData addObject: speed];
                [_exercDistData addObject: dist];
            }
            // refresh section 2 once done querying
            NSRange range = NSMakeRange(1, 1);
            NSIndexSet *section = [NSIndexSet indexSetWithIndexesInRange:range];
            [self.tableView reloadSections:section withRowAnimation:UITableViewRowAnimationNone];
            NSLog(@"end exerc retrieval");
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
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
        return _sleepTimeData.count;
    }
    else {
        return _exercStartTimeData.count;
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
        cell.TitleLabel.text = _sleepTimeData[row];
        cell.DescriptionLabel.text = _sleepDurData[row];
        cell.SpeedLabel.hidden = cell.DistanceLabel.hidden =
        cell.SpeedTag.hidden = cell.DistanceTag.hidden = YES;
    }
    else {
        NSLog(@"Populating exercise row %d", row);
        cell.TitleLabel.text = _exercStartTimeData[row];
        cell.DescriptionLabel.text = _exercTimeData[row];
        cell.SpeedLabel.hidden = cell.DistanceLabel.hidden =
        cell.SpeedTag.hidden = cell.DistanceTag.hidden = NO;
        cell.SpeedLabel.text = _exercSpeedData[row];
        cell.DistanceLabel.text = _exercDistData[row];
    }
    
    return cell;
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
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
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

- (IBAction)EditCells:(id)sender {
}
@end
