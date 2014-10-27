//
//  TableCell.h
//  SleepEz
//
//  Created by Ming Kai Chen on 2014-10-26.
//  Copyright (c) 2014 Ming Kai Chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TableCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *TitleLabel;

@property (strong, nonatomic) IBOutlet UILabel *DescriptionLabel;

@property (weak, nonatomic) IBOutlet UILabel *SpeedLabel;

@property (weak, nonatomic) IBOutlet UILabel *DistanceLabel;

@property (weak, nonatomic) IBOutlet UILabel *DistanceTag;

@property (weak, nonatomic) IBOutlet UILabel *SpeedTag;

@end
