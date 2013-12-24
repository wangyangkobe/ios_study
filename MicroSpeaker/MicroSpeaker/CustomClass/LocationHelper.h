//
//  LocationController.h
//  MicroSpeaker
//
//  Created by wy on 13-12-24.
//  Copyright (c) 2013年 yang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface LocationHelper : NSObject<CLLocationManagerDelegate>{
    CLLocationManager* locationManager;
    CLGeocoder* geocoder;
}

@property(nonatomic, retain)CLLocation* currentLocation;

+(LocationHelper*)sharedInstance;
-(void)start;
-(void)stop;
-(BOOL)locationKnown;
-(NSArray*)convertToAddress;
@end
