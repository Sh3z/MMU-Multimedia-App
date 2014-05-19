//
//  MMRootDetailController.h
//  Multimedia
//
//  Created by Thomas Sherwood on 26/12/2013.
//  Copyright (c) 2013 Thomas Sherwood. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "MMResponsesSource.h"

/// Provides the controller logic for the root detail view, displaying the map view.
@interface MMRootDetailController : UIViewController<MMResponsesDelegate>

/// Contains a reference to the map view used to display the response locations.
@property (weak, nonatomic) IBOutlet MKMapView *map;

/// Occurs when the user taps a button requesting a zoom on their current location.
- (IBAction)didTapZoomToUserLocationButton:(id)sender;

@end
