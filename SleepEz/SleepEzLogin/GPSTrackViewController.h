//
//  GPSTrackViewController.h
//  GPSTrack
//
//  Created by Nick Barrowclough on 4/21/14.
//  Copyright (c) 2014 iSoftware Developers. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h> //import the mapkit framework
#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
#import <Parse/Parse.h>

@interface GPSTrackViewController : UIViewController <CLLocationManagerDelegate, MKMapViewDelegate, MKOverlay> {
    
    CLLocationManager *lm; //core lcoation manager instance
    CLLocationManager *weatherCM;
    
    NSMutableArray *trackPointArray; //Array to store location points
    
    //instaces from mapkit to draw trail on map
    MKMapRect routeRect;
    MKPolylineView* routeLineView;
    MKPolyline* routeLine;
}
- (IBAction)startTracking:(id)sender;
- (IBAction)DisplayGPS:(id)sender;
- (IBAction)backToMenu:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *weatherCity;
@property (weak, nonatomic) IBOutlet UILabel *weatherTemperature;
@property (weak, nonatomic) IBOutlet UILabel *weatherDescription;
@property (weak, nonatomic) IBOutlet UILabel *weatherO;


@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet MKMapView *mapview;
@property (weak, nonatomic) IBOutlet UIButton *gps;
@property (weak, nonatomic) IBOutlet UILabel *speedName;
@property (weak, nonatomic) IBOutlet UILabel *speedNumber;
@property (weak, nonatomic) IBOutlet UILabel *speedKmH;
@property (weak, nonatomic) IBOutlet UILabel *distanceName;
@property (weak, nonatomic) IBOutlet UILabel *distanceNumber;
@property (weak, nonatomic) IBOutlet UILabel *distanceKM;
@property (weak, nonatomic) IBOutlet UILabel *timeName;
@property (weak, nonatomic) IBOutlet UILabel *timeNumber;
@property (weak, nonatomic) IBOutlet UILabel *altitudeName;
@property (weak, nonatomic) IBOutlet UILabel *altitudeNumber;
@property (weak, nonatomic) IBOutlet UILabel *altitudeM;
@property (weak, nonatomic) IBOutlet UIButton *startTrackingButton;
@property (weak, nonatomic) NSTimer *myTimer;
@property int currentTimeInSeconds;

@property (strong, nonatomic) NSDate* MyStartTime;
@end
