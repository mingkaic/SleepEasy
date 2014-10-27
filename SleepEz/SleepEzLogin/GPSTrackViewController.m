//
//  GPSTrackViewController.m
//  GPSTrack
//
//  Created by Nick Barrowclough on 4/21/14.
//  Copyright (c) 2014 iSoftware Developers. All rights reserved.
//

#import "GPSTrackViewController.h"

@interface GPSTrackViewController ()

@end

@implementation GPSTrackViewController

double totalDistance;
CLLocationSpeed speed;
bool onClickStartTrackingButton;

@synthesize mapview;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    mapview.mapType = MKMapTypeSatellite;
    mapview.hidden = TRUE;
    _backButton.hidden = TRUE;
    onClickStartTrackingButton = FALSE;
    totalDistance = 0;
    speed = 0;
}

- (void)viewWillAppear:(BOOL)animated {
    trackPointArray = [[NSMutableArray alloc] init];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)startTracking:(id)sender {
  //  [mapview removeOverlays: mapview.overlays];
    
    // if onClick "Start Tracking" button, then start location manager and change the text of the button to "Stop Tracking"
    if( onClickStartTrackingButton == FALSE) {
        [self clearTrack];
        // reset and start Timer
        [self resetTimer];
        [self startTimer];
        
        lm = [[CLLocationManager alloc] init];
        lm.delegate = self;
    
        #ifdef __IPHONE_8_0
        if(IS_OS_8_OR_LATER) {
            // Use one or the other, not both. Depending on what you put in info.plist
            [lm requestAlwaysAuthorization];
        }
        #endif
    
    /* Pinpoint our location with the following accuracy:
     *
     *     kCLLocationAccuracyBestForNavigation  highest + sensor data
     *     kCLLocationAccuracyBest               highest
     *     kCLLocationAccuracyNearestTenMeters   10 meters
     *     kCLLocationAccuracyHundredMeters      100 meters
     *     kCLLocationAccuracyKilometer          1000 meters
     *     kCLLocationAccuracyThreeKilometers    3000 meters
     */
        lm.desiredAccuracy = kCLLocationAccuracyBest;
    /* Notify changes when device has moved x meters.
     * Default value is kCLDistanceFilterNone: all movements are reported.
     */
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
        [self stopTracking];
        [self sendData];
        // stop timer
        [_myTimer invalidate];
        onClickStartTrackingButton = FALSE;
        [sender setTitle:@"Start Tracking" forState:UIControlStateNormal];
    }
}


- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    
    //get the latest location
    CLLocation *currentLocation = [locations lastObject];
    
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
  
    // display speed
    speed = lm.location.speed;
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

- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id <MKOverlay>)overlay
{
    MKPolylineView *polylineView = [[MKPolylineView alloc] initWithPolyline:overlay];
    polylineView.strokeColor = [UIColor redColor];
    polylineView.lineWidth = 4.0;
    
    return polylineView;
}

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
- (void)clearTrack{
    //remove overlay on mapview
    [mapview removeOverlays: mapview.overlays];
    speed = 0;
    totalDistance = 0;
    
}

- (IBAction)DisplayGPS:(id)sender {
    _backButton.hidden = FALSE;
    mapview.hidden = FALSE;
    _gps.hidden = TRUE;
    _caloriesName.hidden = TRUE;
    _caloriesNumber.hidden = TRUE;
    _caloriesKcal.hidden = TRUE;
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
}

- (IBAction)backToMenu:(id)sender {
    _backButton.hidden = TRUE;
    mapview.hidden = TRUE;
    _gps.hidden = FALSE;
    _caloriesName.hidden = FALSE;
    _caloriesNumber.hidden = FALSE;
    _caloriesKcal.hidden = FALSE;
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
}

- (NSTimer *)createTimer {
    return [NSTimer scheduledTimerWithTimeInterval:1.0
                                            target:self
                                          selector:@selector(timerTicked:)
                                          userInfo:nil
                                           repeats:YES];
}

- (void)timerTicked:(NSTimer *)timer {
    _currentTimeInSeconds++;
    self.timeNumber.text = [self formattedTime:_currentTimeInSeconds];
}

- (NSString *)formattedTime:(int)totalSeconds{
    int seconds = totalSeconds % 60;
    int minutes = (totalSeconds / 60) % 60;
    int hours = totalSeconds / 3600;
    return [NSString stringWithFormat:@"%02d:%02d:%02d",hours, minutes, seconds];
}

-(void)startTimer{
    if (!_currentTimeInSeconds) {
        _currentTimeInSeconds = 0 ;
    }
    if (!_myTimer) {
        _myTimer = [self createTimer];
    }
}

- (void)resetTimer{
    if (_myTimer) {
        [_myTimer invalidate];
        _myTimer = [self createTimer];
    }
    _currentTimeInSeconds = 0;
    self.timeNumber.text = [self formattedTime:_currentTimeInSeconds];
}

// attach this function to an action
- (void)sendData{
    // enter datas
    NSString* totaltime = [NSString stringWithFormat:@"%02li:%02li:%02li",
                           lround(floor(_currentTimeInSeconds / 3600.)) % 100,
                           lround(floor(_currentTimeInSeconds / 60.)) % 60,
                           lround(floor(_currentTimeInSeconds)) % 60];
    NSString* speedData = [NSString stringWithFormat:@"%f", speed];
    NSString* distance = [NSString stringWithFormat:@"%f", totalDistance];
    
    // leave as it is
    PFUser *usr = [PFUser currentUser];
    PFObject *object = [PFObject objectWithClassName:@"Exercise"];
    object[@"userId"] = usr.objectId;
    object[@"BeginTime"] = _MyStartTime;
    object[@"runtime"] = totaltime;
    object[@"speed"] = speedData;
    object[@"distance"] = distance;
    [object saveInBackground];
}


@end
