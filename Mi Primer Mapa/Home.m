//
//  ViewController.m
//  Mi Primer Mapa
//
//  Created by Walter Gonzalez Domenzain on 27/09/17.
//  Copyright © 2017 wgdomenzain. All rights reserved.
//

#import "Home.h"
#import <GoogleMaps/GoogleMaps.h>

#define         nLocalizing     0
#define         nLocalized      1

//Localization
float                   mlatitude;
float                   mlongitude;
static int              iLocalizeState = nLocalizing;

NSMutableArray          *maPlacesTitle;
NSMutableArray          *maPlacesSnippet;
NSMutableArray          *maPlacesLat;
NSMutableArray          *maPlacesLng;

@interface Home (){
    GMSMapView          *mapView;
    GMSMarker           *markerLocation;
    GMSCameraPosition   *camera;
}

@end

@implementation Home

- (void)viewDidLoad {
    [super viewDidLoad];
    ///Location
    [self initLocation];
    [self initPlaces];
}
//------------------------------------------------------------
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//------------------------------------------------------------
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
//------------------------------------------------------------
- (void)initLocation{
    self.locationManager                    = [[CLLocationManager alloc] init];
    self.locationManager.delegate           = self;
    self.location                           = [[CLLocation alloc] init];
    self.locationManager.desiredAccuracy    = kCLLocationAccuracyBest;
    [self.locationManager  requestWhenInUseAuthorization];
    [self.locationManager startUpdatingLocation];
}
//------------------------------------------------------------
- (void)initPlaces {
    maPlacesLat     = [[NSMutableArray alloc] initWithObjects: @"20.674815", @"20.710549",@"20.677541",@"20.682093", nil];
    maPlacesLng     = [[NSMutableArray alloc] initWithObjects: @"-103.387295", @"-103.412525",@"-103.432751",@"-103.462570", nil];
    maPlacesTitle   = [[NSMutableArray alloc] initWithObjects: @"Minerva", @"Andares", @"Galerías", @"Omnilife", nil];
    maPlacesSnippet = [[NSMutableArray alloc] initWithObjects: @"Av Vallarta", @"Zapopan",@"Fashion Mall", @"Chivas", nil];
}
/**********************************************************************************************/
#pragma mark - Maps methods
/**********************************************************************************************/
- (void) paintMap {
    [mapView removeFromSuperview];
    camera                      = [GMSCameraPosition cameraWithLatitude:mlatitude longitude:mlongitude zoom:14.0];
    mapView                     = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    mapView.frame               = CGRectMake(0, 200, self.view.frame.size.width, self.view.frame.size.height-200);
    mapView.myLocationEnabled   = YES;
    
    [self.view addSubview:mapView];
//    [self.view bringSubviewToFront:self.lblName];
//    [self.view bringSubviewToFront:self.lblCountry];
}
//------------------------------------------------------------
- (void) paintMarker {
    GMSMarker *marker       = [[GMSMarker alloc] init];
    markerLocation.icon             = [GMSMarker markerImageWithColor:[UIColor blueColor]];
    marker.position         = camera.target;
    marker.title            = @"UAG";
    marker.snippet          = @"Clase de Maestría";
    marker.appearAnimation  = kGMSMarkerAnimationPop;
    marker.map = mapView;
    
    CLLocationCoordinate2D position;
    NSLog(@"maPlacesTitle.count %d", (int)maPlacesTitle.count);
    for (int i = 0; i<maPlacesTitle.count; i++)
    {
        CGFloat lat                     = (CGFloat)[maPlacesLat[i] floatValue];
        CGFloat lng                     = (CGFloat)[maPlacesLng[i] floatValue];
        NSLog(@"Marker lat %f, long %f", lat, lng);
        position                        = CLLocationCoordinate2DMake(lat, lng);
        markerLocation                  = [GMSMarker markerWithPosition:position];
        markerLocation.icon             = [GMSMarker markerImageWithColor:[UIColor blueColor]];
        markerLocation.title            = maPlacesTitle[i];
        markerLocation.snippet          = maPlacesSnippet[i];
        markerLocation.appearAnimation  = kGMSMarkerAnimationPop;
        markerLocation.map              = mapView;
    }
}
/**********************************************************************************************/
#pragma mark - Localization
/**********************************************************************************************/
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    self.location = locations.lastObject;
    NSLog(@"didUpdateLocation!");
    CLGeocoder * geoCoder = [[CLGeocoder alloc] init];
    [geoCoder reverseGeocodeLocation:self.locationManager.location completionHandler:^(NSArray *placemarks, NSError *error) {
        for (CLPlacemark *placemark in placemarks) {
            NSString *addressName = [placemark name];
            NSString *city = [placemark locality];
            NSString *administrativeArea = [placemark administrativeArea];
            NSString *country  = [placemark country];
            NSString *countryCode = [placemark ISOcountryCode];
            NSLog(@"name is %@ and locality is %@ and administrative area is %@ and country is %@ and country code %@", addressName, city, administrativeArea, country, countryCode);
            self.lblCountry.text = country;
            self.lblName.text = addressName;
            self.lblName.adjustsFontSizeToFitWidth = YES;
        }
        
        mlatitude = self.locationManager.location.coordinate.latitude;
        mlongitude = self.locationManager.location.coordinate.longitude;
        NSLog(@"mlatitude = %f", mlatitude);
        NSLog(@"mlongitude = %f", mlongitude);
        if (iLocalizeState == nLocalizing) {
            [self paintMap];
            [self paintMarker];
            iLocalizeState = nLocalized;
        }
    }];
    
}
@end
