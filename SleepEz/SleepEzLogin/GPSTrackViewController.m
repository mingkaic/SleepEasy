//
//  GPSTrackViewController.m
//  GPSTrack
//
//  Created by Nick Barrowclough on 4/21/14.
//  Copyright (c) 2014 iSoftware Developers. All rights reserved.
//

#import "GPSTrackViewController.h"
#import "Weather.h"
#import "AppDelegate.h"
#import "SaveAndLoad.h"

@interface GPSTrackViewController ()
{
    NSManagedObjectContext *context;
}
@end

@implementation GPSTrackViewController {
    Weather *theWeather;
}

double totalDistance;
float averageSpeed;
CLLocationSpeed speed;
bool onClickStartTrackingButton;
bool showOnlyWeahter;

@synthesize mapview;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    AppDelegate *appdelegate = [[UIApplication sharedApplication]delegate];
    context = [appdelegate managedObjectContext];
    
    // Do any additional setup after loading the view, typically from a nib.
    mapview.mapType = MKMapTypeSatellite;
    mapview.hidden = TRUE;
    _backButton.hidden = TRUE;
    onClickStartTrackingButton = FALSE;
    totalDistance = 0;
    averageSpeed = 0;
    speed = 0;
    
    showOnlyWeahter = true;
    theWeather = [[Weather alloc] init];
    weatherCM = [[CLLocationManager alloc] init];
    weatherCM.delegate = self;
    
    // check if a user want to use "current location"
#ifdef __IPHONE_8_0
    if(IS_OS_8_OR_LATER) {
        // Use one or the other, not both. Depending on what you put in info.plist
        [weatherCM requestAlwaysAuthorization];
    }
#endif
    
    [weatherCM startUpdatingLocation];
}

- (void)viewWillAppear:(BOOL)animated {
    trackPointArray = [[NSMutableArray alloc] init];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


// show weather
- (void)showWeather
{
    // if the current city is unknown then display "--", otherwise display the current weather infomation.
    if( theWeather.city == Nil)
        _weatherCity.text = @"--";
    else
        _weatherCity.text = [NSString stringWithFormat: @"%@", theWeather.city];
    
    _weatherTemperature.text = [NSString stringWithFormat: @"%0.0f", theWeather.tempCurrent];
    
    if( theWeather.conditions[0] == Nil)
        _weatherDescription.text = @"--";
    else
        _weatherDescription.text = [NSString stringWithFormat: @"%@", theWeather.conditions[0][@"description"]];
}

// the actions when "Start Tracking" button pressed
- (IBAction)startTracking:(id)sender {
    //  [mapview removeOverlays: mapview.overlays];
    
    // if onClick "Start Tracking" button, then start location manager and change the text of the button to "Stop Tracking"
    if( onClickStartTrackingButton == FALSE) {
        showOnlyWeahter = false;
        
        // clearTack before starting tracking
        [self clearTrack];
        // reset and start Timer before starting tracking
        [self resetTimer];
        [self startTimer];
        
        lm = [[CLLocationManager alloc] init];
        lm.delegate = self;
        
        // check if a user want to use "current location"
#ifdef __IPHONE_8_0
        if(IS_OS_8_OR_LATER) {
            [lm requestAlwaysAuthorization];
        }
#endif
        
        lm.distanceFilter = 3.0f;
        [lm startUpdatingLocation];
        mapview.delegate = self;
        mapview.showsUserLocation = YES;
        onClickStartTrackingButton = TRUE;
        [sender setTitle:@"Stop Tracking" forState:UIControlStateNormal];
        _MyStartTime = [NSDate date];
    }
    // if onClick "Stop Tracking" button, then stop  location manager and change the text of the button to "Start Tracking"
    else {
        showOnlyWeahter = true;
        [self stopTracking];
        [self sendData];
        // stop timer
        [_myTimer invalidate];
        onClickStartTrackingButton = FALSE;
        [sender setTitle:@"Start Tracking" forState:UIControlStateNormal];
    }
}

// get the current location information such as distance , speed, altitude and manage "MapView" such as zooming a map
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    
    //get the latest location
    CLLocation *currentLocation = [locations lastObject];
    
    CLGeocoder *geocoder = [[CLGeocoder alloc] init] ;
    [geocoder reverseGeocodeLocation:currentLocation
                   completionHandler:^(NSArray *placemarks, NSError *error) {
                       if (error){
                           NSLog(@"Geocode failed with error: %@", error);
                           return;
                       }
                       CLPlacemark *placemark = [placemarks objectAtIndex:0];
                       //NSLog(@"placemark.ISOcountryCode %@",placemark.locality);
                       theWeather.city = placemark.locality;
                       [theWeather getCurrent:placemark.locality];
                       //NSLog(@"placemark.locality %@",theWeather.city);
                       
                       
                   }];
    
    [self showWeather];
    
    
    if(!showOnlyWeahter) {
        
        //store latest location in stored track array;
        [trackPointArray addObject:currentLocation];
        
        //get latest location coordinates
        CLLocationDegrees Latitude = currentLocation.coordinate.latitude;
        CLLocationDegrees Longitude = currentLocation.coordinate.longitude;
        CLLocationCoordinate2D locationCoordinates = CLLocationCoordinate2DMake(Latitude, Longitude);
        
        
        // display distance
        NSUInteger previousLocation = [trackPointArray indexOfObject:currentLocation] - 1;
        double totalDistanceInKM;
        if( [trackPointArray count ] > 1 ) {
            CLLocationDistance distance = [currentLocation distanceFromLocation:[trackPointArray objectAtIndex:previousLocation]];
            totalDistance = totalDistance + distance;
            totalDistanceInKM = totalDistance / 1000;
            _distanceNumber.text = [NSString stringWithFormat: @"%.2f", totalDistanceInKM];
        }
        else {
            _distanceNumber.text = [NSString stringWithFormat: @"%.2f", 0.00];
        }
        
        // display speed in km
        speed = lm.location.speed;
        if( speed < 0 )
            speed = 0;
        else
            speed = speed * 3.6;
        
        _speedNumber.text = [NSString stringWithFormat: @"%.1f", speed];
        
        // display altitude
        _altitudeNumber.text = [NSString stringWithFormat: @"%.2f", currentLocation.altitude];
        
        //zoom map to show users location
        MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(locationCoordinates, 1000, 1000);
        MKCoordinateRegion adjustedRegion = [mapview regionThatFits:viewRegion]; [mapview setRegion:adjustedRegion animated:YES];
        
        NSInteger numberOfSteps = trackPointArray.count;
        
        CLLocationCoordinate2D coordinates[numberOfSteps];
        for (NSInteger index = 0; index < numberOfSteps; index++) {
            CLLocation *location = [trackPointArray objectAtIndex:index];
            CLLocationCoordinate2D coordinate2 = location.coordinate;
            
            coordinates[index] = coordinate2;
        }
        
        MKPolyline *polyLine = [MKPolyline polylineWithCoordinates:coordinates count:numberOfSteps];
        [mapview addOverlay:polyLine];
        
        //NSLog(@"%@", trackPointArray);
        
        // distance between the starting point and current point
        //   CLLocationDistance distanceBetween = [[locations firstObject] distanceFromLocation: [locations lastObject]];
        
    }
    
    
    float inHours  = (float) _currentTimeInSeconds / 3600;
    averageSpeed = (float )totalDistance / inHours/ 1000;
}

// show the map for GPS
- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id <MKOverlay>)overlay
{
    MKPolylineView *polylineView = [[MKPolylineView alloc] initWithPolyline:overlay];
    polylineView.strokeColor = [UIColor redColor];
    polylineView.lineWidth = 4.0;
    
    return polylineView;
}

// stop tracking
- (void)stopTracking {
    //reset location manager and turn off GPS
    lm = [[CLLocationManager alloc] init];
    [lm stopUpdatingLocation];
    lm = nil;
    
    //stop showing user location
    mapview.showsUserLocation = NO;
    
    //reset array fo tracks
    trackPointArray = nil;
    trackPointArray = [[NSMutableArray alloc] init];
}

// clear track
- (void)clearTrack{
    //remove overlay on mapview
    [mapview removeOverlays: mapview.overlays];
    speed = 0;
    totalDistance = 0;
    
}


// manage buttons when "GPS" is pressed
- (IBAction)DisplayGPS:(id)sender {
    _backButton.hidden = FALSE;
    mapview.hidden = FALSE;
    _gps.hidden = TRUE;
    _speedName.hidden = TRUE;
    _speedNumber.hidden = TRUE;
    _speedKmH.hidden = TRUE;
    _distanceName.hidden = TRUE;
    _distanceNumber.hidden = TRUE;
    _distanceKM.hidden = TRUE;
    _timeName.hidden = TRUE;
    _timeNumber.hidden = TRUE;
    _altitudeName.hidden = TRUE;
    _altitudeNumber.hidden = TRUE;
    _altitudeM.hidden = TRUE;
    _startTrackingButton.hidden = TRUE;
    
    _weatherCity.hidden = TRUE;
    _weatherDescription.hidden = TRUE;
    _weatherTemperature.hidden = TRUE;
    _weatherO.hidden = TRUE;
}

// manage button when "Back" button is pressed
- (IBAction)backToMenu:(id)sender {
    _backButton.hidden = TRUE;
    mapview.hidden = TRUE;
    _gps.hidden = FALSE;
    _speedName.hidden = FALSE;
    _speedNumber.hidden = FALSE;
    _speedKmH.hidden = FALSE;
    _distanceName.hidden = FALSE;
    _distanceNumber.hidden = FALSE;
    _distanceKM.hidden = FALSE;
    _timeName.hidden = FALSE;
    _timeNumber.hidden = FALSE;
    _altitudeName.hidden = FALSE;
    _altitudeNumber.hidden = FALSE;
    _altitudeM.hidden = FALSE;
    _startTrackingButton.hidden = FALSE;
    
    _weatherCity.hidden = FALSE;
    _weatherDescription.hidden = FALSE;
    _weatherTemperature.hidden = FALSE;
    _weatherO.hidden = FALSE;
}

// clear NSTimer
- (NSTimer *)createTimer {
    return [NSTimer scheduledTimerWithTimeInterval:1.0
                                            target:self
                                          selector:@selector(timerTicked:)
                                          userInfo:nil
                                           repeats:YES];
}

// show time in timer
- (void)timerTicked:(NSTimer *)timer {
    _currentTimeInSeconds++;
    self.timeNumber.text = [self formattedTime:_currentTimeInSeconds];
}

// manage the format for timer ( hours : minutes : seconds )
- (NSString *)formattedTime:(int)totalSeconds{
    int seconds = totalSeconds % 60;
    int minutes = (totalSeconds / 60) % 60;
    int hours = totalSeconds / 3600;
    return [NSString stringWithFormat:@"%02d:%02d:%02d",hours, minutes, seconds];
}

// start timer
-(void)startTimer{
    if (!_currentTimeInSeconds) {
        _currentTimeInSeconds = 0 ;
    }
    if (!_myTimer) {
        _myTimer = [self createTimer];
    }
}

// reset timer
- (void)resetTimer{
    if (_myTimer) {
        [_myTimer invalidate];
        _myTimer = [self createTimer];
    }
    _currentTimeInSeconds = 0;
    self.timeNumber.text = [self formattedTime:_currentTimeInSeconds];
}

// send data to database if total distance > 0
// reset average speed, total distance and total time in seconds to 0;
- (void)sendData{
    float totalDistanceKM =0;
    int totalTimeInSeconds = _currentTimeInSeconds;
    if( totalDistance > 0 ) {
        totalDistanceKM= totalDistance /1000;
        
        NSString* totaltime = [NSString stringWithFormat:@"%d", totalTimeInSeconds];
        
        totaltime = [self formattedTime: totalTimeInSeconds];
        
        NSString* speedData = [NSString stringWithFormat:@"%f km/h", averageSpeed];
        NSString* distance = [NSString stringWithFormat:@"%f km", totalDistanceKM];
        
        SaveAndLoad *load = [[SaveAndLoad alloc] init];
        
        NSEntityDescription *entitydesc = [NSEntityDescription entityForName: @"SleepEzExerc" inManagedObjectContext:context];
        NSManagedObject *newExerc = [[NSManagedObject alloc] initWithEntity:entitydesc insertIntoManagedObjectContext:context];
        
        [newExerc setValue: [load loadID] forKey:@"username"];
        [newExerc setValue: _MyStartTime forKey:@"starttime"];
        [newExerc setValue: totaltime forKey:@"duration"];
        [newExerc setValue: speedData forKey:@"speed"];
        [newExerc setValue: distance forKey:@"distance"];
        NSError *error;
        [context save:&error];
        
        PFUser *usr = [PFUser currentUser];
        if (usr) {
            PFObject *object = [PFObject objectWithClassName:@"Exercise"];
            object[@"userId"] = usr.objectId;
            object[@"BeginTime"] = _MyStartTime;
            object[@"runtime"] = totaltime;
            object[@"speed"] = speedData;
            object[@"distance"] = distance;
        
            [object saveInBackground];
        }
    }
    averageSpeed = 0;
    totalDistance = 0;
    totalTimeInSeconds = 0;
}


@end
