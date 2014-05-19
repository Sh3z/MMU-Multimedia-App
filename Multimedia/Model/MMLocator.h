//
//  MMLocator.h
//  Multimedia
//
//  Created by Thomas Sherwood on 25/12/2013.
//  Copyright (c) 2013 Thomas Sherwood. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

/// Represents an object that provides the current location.
@protocol MMLocator <NSObject>
@required

/// Contains the last resolved location of the device (read-only).
@property (strong, nonatomic, readonly) CLLocation* lastLocation;

/// Notifies this object to stop tracking the device's location.
- (void)stopTrackingLocation;

@end
