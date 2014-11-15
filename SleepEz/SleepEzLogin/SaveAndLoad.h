//
//  SaveAndLoad.h
//  SleepEzLogin
//
//  Created by JungHwan Bae on 2014-11-10.
//  Copyright (c) 2014 JungHwan Bae. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SaveAndLoad : NSObject

-(void)saveID:(NSString *)userID;
-(NSString *)loadID;
-(void)savePassWord:(NSString *)password;
-(void)loadPassword;
@end
