//
//  LocationController.m
//  MicroSpeaker
//
//  Created by wy on 13-12-24.
//  Copyright (c) 2013年 yang. All rights reserved.
//

#import "LocationHelper.h"

@implementation LocationHelper

static LocationHelper* sharedInstance;

+(LocationHelper*)sharedInstance
{
    @synchronized(self){
        if (!sharedInstance) {
            sharedInstance = [[LocationHelper alloc] init];
        }
    }
    return sharedInstance;
}
+(id)alloc{
    @synchronized(self){
        NSAssert(sharedInstance == nil, @"Attemped to allocate a second instance of a singleton LocationController.");
        sharedInstance = [super alloc];
    }
    return sharedInstance;
}
-(id)init{
    if (self = [super init]) {
        self.currentLocation = [[CLLocation alloc] init];
        locationManager = [[CLLocationManager alloc] init];
        geocoder  = [[CLGeocoder alloc] init];
        locationManager.delegate = self;
    }
    return self;
}

-(void)start{
    [locationManager startUpdatingLocation];
}
-(void)stop{
    [locationManager stopUpdatingLocation];
}
-(BOOL)locationKnown{
    if (round(_currentLocation.speed) == -1) {
        return NO;
    }else{
        return YES;
    }
}
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    CLLocation* newLocation = [locations lastObject];
    if (abs([newLocation.timestamp timeIntervalSinceDate:[NSDate date]]) < 120) {
        NSLog(@"new Location:%@", [newLocation description]);
        self.currentLocation = newLocation;
    }
}
-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    NSLog(@"%@ error: %@", NSStringFromSelector(_cmd), [error description]);
}
-(NSArray*)convertToAddress{
    NSMutableArray* result = [NSMutableArray array];
    [geocoder reverseGeocodeLocation:self.currentLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        NSLog(@"error:%@", [error description]);
        [result addObject:placemarks];
    }];
    return result;
}
@end

