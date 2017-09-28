//
//  ViewController.h
//  Mi Primer Mapa
//
//  Created by Walter Gonzalez Domenzain on 27/09/17.
//  Copyright © 2017 wgdomenzain. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface Home : UIViewController<CLLocationManagerDelegate>
@property (strong, nonatomic)   CLLocationManager   *locationManager;
@property (strong, nonatomic)   CLLocation          *location;
@property (strong, nonatomic) IBOutlet UILabel *lblCountry;
@property (strong, nonatomic) IBOutlet UILabel *lblName;


@end

