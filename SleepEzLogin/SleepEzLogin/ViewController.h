//
//  ViewController.h
//  SleepEzLogin
//
//  Created by Ming Kai Chen on 2014-10-24.
//  Copyright (c) 2014 ___FULLUSERNAME___. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UITextFieldDelegate>
- (void) alertStatus:(NSString *)msg :(NSString *)title :(int) tag;

- (IBAction)BackgroundTap:(id)sender;
@end