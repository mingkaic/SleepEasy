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
    [self retrieveData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// retrieve from Parse
- (void)retrieveData
{
    PFQuery *query1 = [PFQuery queryWithClassName:@"Sleep"];
    //PFQuery *query2 = [PFQuery queryWithClassName:@"Exercise"];
    PFUser *user = [PFUser currentUser];
    [query1 whereKey:@"userId" equalTo:user.objectId];
    [query1 findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        NSLog(@"Retrieving sleep data...");
        if (!error) {
            // search successful.
            NSLog(@"Successfully retrieved %lu data entries.", (unsigned long)objects.count);
            
            for (PFObject* object in objects) {
                NSDate* start = object[@"beginSleep"];
                NSDate* duration = object[@"durationSleep"];
                
                NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
                formatter.timeZone = [NSTimeZone defaultTimeZone];
                formatter.timeStyle = NSDateFormatterShortStyle;
                formatter.dateStyle = NSDateFormatterShortStyle;
                
                NSString* time = [formatter stringFromDate: start];
                
                NSLog(time);
                NSLog(duration);
                
                [_sleepTimeData addObject: time];
                [_sleepDurData addObject: duration];
                NSLog(@"end sleep retrieval");
            }
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
    /*[query2 whereKey:@"username" equalTo:user.username];
    [query2 findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        NSLog(@"Retrieving exercise data...");
        if (!error) {
            // search successful.
            NSLog(@"Successfully retrieved %lu data entries.", (unsigned long)objects.count);
            
            _exercData = objects;
            NSLog(@"end exercise retrieval");
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];*/
    NSLog(@"end retrieval");
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return _sleepTimeData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TableCell" forIndexPath:indexPath];
    
    int row = [indexPath row];
    
    NSLog(@"Populating row %d", row);
    
    cell.TitleLabel.text = _sleepTimeData[row];
    cell.DescriptionLabel.text = _sleepDurData[row];
    
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

@end
