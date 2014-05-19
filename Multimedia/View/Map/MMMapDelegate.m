//
//  MMMapDelegate.m
//  Multimedia
//
//  Created by Thomas Sherwood on 26/12/2013.
//  Copyright (c) 2013 Thomas Sherwood. All rights reserved.
//

#import "MMMapDelegate.h"
#import "MultimediaResponse.h"

@implementation MMAnnotationPairing
@synthesize annotation, eventSource;
@end

@interface MMMapDelegate ()
{
	/// Contains the collection of pairings used for event tracking.
	NSMutableArray* _pairings;
}

@end

@implementation MMMapDelegate

@synthesize map = _map, responses = _responses;

- (id)initWithMap:(MKMapView *)map
{
	if(self = [super init])
	{
		_map = map;
		_map.delegate = self;
		_pairings = [[NSMutableArray alloc] init];
	}
	
	return self;
}

- (void)setResponses:(NSArray *)responses
{
	_pairings = [[NSMutableArray alloc] initWithCapacity:[responses count]];
	_responses = responses;
	NSMutableArray* toRemove = [[_map annotations] mutableCopy];
	[toRemove removeObject:_map.userLocation];
	[_map removeAnnotations:toRemove];
	[_map addAnnotations:_responses];
}

- (void)zoomToResponse:(MultimediaResponse*)response
{
	[self zoomToCoordinate:[[response location] coordinate]];
}

- (void)showCalloutForResponse:(MultimediaResponse*)response hideOthers:(BOOL)hide
{
	for(id<MKAnnotation> annotation in [_map annotations])
	{
		if(annotation == response)
		{
			[_map selectAnnotation:annotation animated:YES];
		}
		else
		{
			if(hide)
			{
				[_map deselectAnnotation:annotation animated:YES];
			}
		}
	}
}

- (void)zoomOnUserLocation
{
	[self zoomToCoordinate:[[_map userLocation] coordinate]];
}

/**
 * Zooms to a specified coordinate on the map
 * @param coord the CLLocationCoordinate2D to zoom to.
 */
- (void)zoomToCoordinate:(CLLocationCoordinate2D)coord
{
	MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(coord, 100, 100);
	MKCoordinateRegion adjusted = [self.map regionThatFits:viewRegion];
	[self.map setRegion:adjusted animated:YES];
}

/**
 * Occurs when a button on the map view has been tapped
 * @param source the UIButton that triggered the event firing.
 */
- (void)didTapMapButton:(UIButton*)source
{
	if([_delegate respondsToSelector:@selector(mapInteraction:userDidTapResponse:)])
	{
		MMAnnotationPairing* pairing = [[_pairings filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"eventSource == %@", source]] firstObject];
		[_delegate mapInteraction:self userDidTapResponse:pairing.annotation];
	}
}

#pragma mark - MKMapViewDelegate

- (MKAnnotationView*)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
	if([annotation isKindOfClass:[MultimediaResponse class]])
	{
		static NSString* annotationIdentifier = @"questionnaireAnnotation";
		MKAnnotationView* view = [_map dequeueReusableAnnotationViewWithIdentifier:annotationIdentifier];
		
		UIButton* btn;
		if(!view)
		{
			btn = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
			[btn addTarget:self action:@selector(didTapMapButton:) forControlEvents:UIControlEventTouchUpInside];
			
			view = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:annotationIdentifier];
			view.rightCalloutAccessoryView = btn;
			view.image = [UIImage imageNamed:@"MapNotification.png"];
			view.centerOffset = CGPointMake(0, -1 * (view.image.size.height / 2));
			view.canShowCallout = YES;
		}
		else
		{
			btn = (UIButton*)view.rightCalloutAccessoryView;
			view.annotation = annotation;
		}
		
		MMAnnotationPairing* pairing = [[MMAnnotationPairing alloc] init];
		[pairing setAnnotation:annotation];
		[pairing setEventSource:btn];
		[_pairings addObject:pairing];
		
		return view;
	}
	else
	{
		return nil;
	}
}

@end
