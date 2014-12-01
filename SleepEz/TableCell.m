//
//  TableCell.m
//  SleepEz
//
//  Created by Ming Kai Chen on 2014-10-26.
//  Copyright (c) 2014 Ming Kai Chen. All rights reserved.
//

#import "TableCell.h"

@implementation TableCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)Select:(id)sender {
    
    float averageSpeed= 5;
    
    //input done here by adding object to mutablearray
    //GlobalVars *globals = [GlobalVars sharedInstance];
    
    //[globals.exerciseAverages addObject:[NSString stringWithFormat:@"%0.4f", averageSpeed]];
    
    //if (averageSpeed)
        //exerciseCount++;
}

@end
