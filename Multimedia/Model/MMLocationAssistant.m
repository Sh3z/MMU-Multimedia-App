//
//  MMLocationAssistant.m
//  Multimedia
//
//  Created by Thomas Sherwood on 25/12/2013.
//  Copyright (c) 2013 Thomas Sherwood. All rights reserved.
//

#import "MMLocationAssistant.h"

@implementation MMLocationAssistant

@synthesize lastLocation;

- (void)beginTrackingLocationWithAccuracy:(CLLocationAccuracy)accuracy
{
	if(!_manager)
	{
		_manager = [[CLLocationManager alloc] init];
		[_manager setDesiredAccuracy:accuracy];
		[_manager setDelegate:self];
		[_manager startUpdatingLocation];
	}
}

- (void)stopTrackingLocation
{
	if(_manager)
	{
		[_manager stopUpdatingLocation];
		_manager = nil;
	}
}

#pragma mark CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
	lastLocation = newLocation;
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
	
}

@end
