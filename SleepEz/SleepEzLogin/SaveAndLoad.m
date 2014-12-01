//
//  SaveAndLoad.m
//  SleepEzLogin
//
//  Created by JungHwan Bae on 2014-11-10.
//  Copyright (c) 2014 JungHwan Bae. All rights reserved.
//

#import "SaveAndLoad.h"

@implementation SaveAndLoad

-(void)saveID:(NSString *)userID{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    // saving an NSString
    [prefs setObject:userID forKey:@"ID"];
    [prefs synchronize];
    [self loadID];
}
-(NSString *)loadID{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    // getting an NSString
    NSString *myString = [prefs stringForKey:@"ID"];
    NSLog(@"id is %@", myString);
    return myString;
    
}

-(void)savePassWord:(NSString *)password{
    NSString *passWordKey = [NSString stringWithFormat:@"%@,password", [self loadID]];
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    // saving an NSString
    [prefs setObject:password forKey:passWordKey];
    [prefs synchronize];
    
    NSLog(@"password is %@", password);
}
@end
