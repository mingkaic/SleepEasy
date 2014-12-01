//
//  Weather.h
//  SleepEzLogin
//
//  Created by JungHwan Bae on 2014-11-08.
//  Copyright (c) 2014 JungHwan Bae. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AFJSONRequestOperation.h>

@interface Weather : NSObject

// Place and time
@property (nonatomic, copy) NSString *city;
@property (nonatomic, copy, readonly) NSString *country;
@property (nonatomic, readonly) CGFloat latitude;
@property (nonatomic, readonly) CGFloat longitude;
@property (nonatomic, copy, readonly) NSDate *reportTime;
@property (nonatomic, copy, readonly) NSDate *sunrise;
@property (nonatomic, copy, readonly) NSDate *sunset;

// Qualitative
@property (nonatomic, copy, readonly) NSArray *conditions;

// Quantitative
@property (nonatomic, readonly) NSInteger cloudCover;
@property (nonatomic, readonly) NSInteger humidity;
@property (nonatomic, readonly) NSInteger pressure;
@property (nonatomic, readonly) NSInteger rain3hours;
@property (nonatomic, readonly) NSInteger snow3hours;
@property (nonatomic, readonly) CGFloat tempCurrent;
@property (nonatomic, readonly) CGFloat tempMin;
@property (nonatomic, readonly) CGFloat tempMax;
@property (nonatomic, readonly) NSInteger windDirection;
@property (nonatomic, readonly) CGFloat windSpeed;


- (void)getCurrent:(NSString *)query;
@end
