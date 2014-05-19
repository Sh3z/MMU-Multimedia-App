//
//  MMRootDetailController.m
//  Multimedia
//
//  Created by Thomas Sherwood on 26/12/2013.
//  Copyright (c) 2013 Thomas Sherwood. All rights reserved.
//

#import "MMRootDetailController.h"
#import "MMCoreDataAssistant.h"
#import "MultimediaApp.h"
#import "MMMapDelegate.h"
#import "MMResponseViewController.h"

@interface MMRootDetailController ()<MMMultimediaMapDelegate>
{
	MMMapDelegate* _mapDelegate;
	MultimediaResponse* _selectedResponse;
}

@end

@implementation MMRootDetailController

@synthesize currentResponse = _selectedResponse;

- (void)viewDidLoad
{
	[super viewDidLoad];

	_mapDelegate = [[MMMapDelegate alloc] initWithMap:_map];
	[_mapDelegate setDelegate:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	if([[segue identifier] isEqualToString:@"presentResponseSegue"])
	{
		[[segue destinationViewController] setResponse:_selectedResponse];
	}
	
	[super prepareForSegue:segue sender:sender];
}

- (void)setCurrentResponse:(MultimediaResponse*)response
{
	_selectedResponse = response;
	if(!self.currentResponse && [self.navigationController visibleViewController] != self)
	{
		[self.navigationController popToRootViewControllerAnimated:YES];
	}
}

#pragma mark - MMResponsesTableDelegate

- (void)responseSource:(id<MMResponsesSource>)source newAvailableResponses:(NSArray*)responses
{
	[_mapDelegate setResponses:responses];
}

- (void)responseSource:(id<MMResponsesSource>)source didSelectResponse:(MultimediaResponse *)response
{
	if(self.navigationController.visibleViewController != self)
	{
		[self.navigationController popToRootViewControllerAnimated:YES];
	}
	
	[_mapDelegate zoomToResponse:response];
	[_mapDelegate showCalloutForResponse:response hideOthers:YES];
}

#pragma mark - MMMultimediaMapDelegate

- (void)mapInteraction:(MMMapDelegate *)map userDidTapResponse:(MultimediaResponse *)response
{
	_selectedResponse = response;
	[self performSegueWithIdentifier:@"presentResponseSegue" sender:self];
}

- (IBAction)didTapZoomToUserLocationButton:(id)sender
{
	[_mapDelegate zoomOnUserLocation];
}

@end
