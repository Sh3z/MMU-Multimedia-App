//
//  MMLocationAssistant.h
//  Multimedia
//
//  Created by Thomas Sherwood on 25/12/2013.
//  Copyright (c) 2013 Thomas Sherwood. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MMLocator.h"

/// Represents an object providing location updates.
@interface MMLocationAssistant : NSObject<MMLocator, CLLocationManagerDelegate>
{
	/// The CLLocationManager used to fetch the location.
	CLLocationManager* _manager;
}

/**
 * Begins tracking the location of the device to the specified degree of accuracy
 * @param accuracy the accuracy to use when resolving the location.
 */
- (void)beginTrackingLocationWithAccuracy:(CLLocationAccuracy)accuracy;

@end
