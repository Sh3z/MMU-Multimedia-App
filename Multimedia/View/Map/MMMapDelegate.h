//
//  MMMapDelegate.h
//  Multimedia
//
//  Created by Thomas Sherwood on 26/12/2013.
//  Copyright (c) 2013 Thomas Sherwood. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@class MultimediaResponse, MMMapDelegate;

/// Represents the delegate notified by the MMMapDelegate as interactions occur
@protocol MMMultimediaMapDelegate <NSObject>
@optional

/**
 * Notifies the delegate object that the user has selected a response on the map.
 * @param map the MMMapDelegate the event is coming from
 * @param response the MultimediaResponse the user has tapped
 */
- (void)mapInteraction:(MMMapDelegate*)map userDidTapResponse:(MultimediaResponse*)response;

@end

/// Represents a pairing of an MKAnnotation and an associated event source.
@interface MMAnnotationPairing : NSObject

/// Contains the annotation drawn on the map.
@property (strong, nonatomic) id<MKAnnotation> annotation;

/// Contains the source of events for the associated annotation.
@property (strong, nonatomic) UIButton* eventSource;

@end

/// Assists in the usage of MKMapViews with the MultimediaApplication.
@interface MMMapDelegate : NSObject<MKMapViewDelegate>

/**
 * Initializes and returns a new MMMapDelegate object with the MKMapView to manage.
 * @param map the MKMapView this MMMapDelegate should manage
 * @return a new instance of the MMMapDelegate class.
 */
- (id)initWithMap:(MKMapView*)map;

/// Contains the MMMultimediaMapDelegate object notified as the user interacts with the map.
@property (strong, nonatomic) id<MMMultimediaMapDelegate> delegate;

/// Contains a reference to the MKMapView managed by this MMMapDelegate (read-only).
@property (strong, nonatomic, readonly) MKMapView* map;

/// Contains the set of MultimediaResponse objects to be displayed on the map.
@property (strong, nonatomic) NSArray* responses;

/// Executes a zoom onto the user's current location.
- (void)zoomOnUserLocation;

/**
 * Execute a zoom onto the location where the associated response was captured.
 * @param response the MultimediaResponse to zoom onto.
 */
- (void)zoomToResponse:(MultimediaResponse*)response;

/**
 * Displays the callout for a particular response on the map, optionally hiding any
 * other callouts.
 * @param response the MultimediaResponse within the MKMapView to show the callout
 * for
 * @param hide if YES, all other callouts will be hidden.
 */
- (void)showCalloutForResponse:(MultimediaResponse*)response hideOthers:(BOOL)hide;

@end
