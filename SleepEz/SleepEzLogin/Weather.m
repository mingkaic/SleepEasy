//
//  Weather.m
//  SleepEzLogin
//
//  Created by JungHwan Bae on 2014-11-08.
//  Copyright (c) 2014 JungHwan Bae. All rights reserved.
//

#import "Weather.h"

@implementation Weather {
    NSDictionary *weatherServiceResponse;
}

- (id)init
{
    self = [super init];
    
    weatherServiceResponse = @{};
    
    return self;
}

- (void)getCurrent:(NSString *)query
{
    NSString *const BASE_URL_STRING = @"http://api.openweathermap.org/data/2.5/weather";
    
    NSString *weatherURLText = [NSString stringWithFormat:@"%@?q=%@",
                                BASE_URL_STRING, query];
    NSURL *weatherURL = [NSURL URLWithString:weatherURLText];
    NSURLRequest *weatherRequest = [NSURLRequest requestWithURL:weatherURL];
    
    AFJSONRequestOperation *operation =
    [AFJSONRequestOperation JSONRequestOperationWithRequest:weatherRequest
                                                    success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                                                        weatherServiceResponse = (NSDictionary *)JSON;
                                                        [self parseWeatherServiceResponse];
                                                    }
                                                    failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                                                        weatherServiceResponse = @{};
                                                    }
     ];
    
    [operation start];
}

- (void)parseWeatherServiceResponse
{
    // clouds
    _cloudCover = [weatherServiceResponse[@"clouds"][@"all"] integerValue];
    
    // coord
    _latitude = [weatherServiceResponse[@"coord"][@"lat"] doubleValue];
    _longitude = [weatherServiceResponse[@"coord"][@"lon"] doubleValue];
    
    // dt
    _reportTime = [NSDate dateWithTimeIntervalSince1970:[weatherServiceResponse[@"dt"] doubleValue]];
    
    // main
    _humidity = [weatherServiceResponse[@"main"][@"humidity"] integerValue];
    _pressure = [weatherServiceResponse[@"main"][@"pressure"] integerValue];
    _tempCurrent = [Weather kelvinToCelsius:[weatherServiceResponse[@"main"][@"temp"] doubleValue]];
    _tempMin = [Weather kelvinToCelsius:[weatherServiceResponse[@"main"][@"temp_min"] doubleValue]];
    _tempMax = [Weather kelvinToCelsius:[weatherServiceResponse[@"main"][@"temp_max"] doubleValue]];
    
    // name
    _city = weatherServiceResponse[@"name"];
    
    // rain
    _rain3hours = [weatherServiceResponse[@"rain"][@"3h"] integerValue];
    
    // snow
    _snow3hours = [weatherServiceResponse[@"snow"][@"3h"] integerValue];
    
    // sys
    _country = weatherServiceResponse[@"sys"][@"country"];
    _sunrise = [NSDate dateWithTimeIntervalSince1970:[weatherServiceResponse[@"sys"][@"sunrise"] doubleValue]];
    _sunset = [NSDate dateWithTimeIntervalSince1970:[weatherServiceResponse[@"sys"][@"sunset"] doubleValue]];
    
    // weather
    _conditions = weatherServiceResponse[@"weather"];
    
    // wind
    _windDirection = [weatherServiceResponse[@"wind"][@"dir"] integerValue];
    _windSpeed = [weatherServiceResponse[@"wind"][@"speed"] doubleValue];
}

+ (double)kelvinToCelsius:(double)degreesKelvin
{
    const double ZERO_CELSIUS_IN_KELVIN = 273.15;
    return degreesKelvin - ZERO_CELSIUS_IN_KELVIN;
}

@end
