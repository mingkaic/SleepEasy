//
//  User.h
//  SleepEzLogin
//
//  Created by Zhaoyang Chen on 2014-11-29.
//  Copyright (c) 2014 Zhaoyang Chen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *age;

@end
