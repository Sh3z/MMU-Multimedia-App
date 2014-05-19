//
//  MMPresentationViewController.m
//  Multimedia
//
//  Created by Thomas Sherwood on 23/12/2013.
//  Copyright (c) 2013 Thomas Sherwood. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import "MMPresentationViewController.h"
#import "MMMultimediaPresenter.h"
#import "MMPresenterFactory.h"
#import "MMMultimediaResponseBuilder.h"
#import "CameraEngine.h"
#import "MMPresentationConclusionController.h"
#import "MMCoreDataAssistant.h"
#import "AppSettings.h"

@implementation MMPresentationRequest
@synthesize presentationType, media;
@end

@interface MMPresentationViewController ()
{
	/// Contains the view displaying the presentation.
	MMMultimediaPresenter* _presentationView;
	
	/// Contains the view containing the rating bar.
	MMRatingBarController* _ratingView;
	
	/// Contains the builder to use when assembling the response.
	MMMultimediaResponseBuilder* _builder;
	
	/// Contains an NSDate storing the timestamp when the presentation began.
	NSDate* _beganCurrentViewTime;
	
	/// Contains whether the user provided a rating for the last media.
	BOOL _didRatePreviousMedia;
	
	/// Contains the unique identifier for the current responses recording.
	NSString* _recordingID;
	
	/// Contains the index of the current media.
	int _currentMediaIndex;
}

@end

@implementation MMPresentationViewController

@synthesize presentationRequest, delegate;

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	if([[segue identifier] isEqualToString:@"slideShowSegue"])
	{
		_presentationView = (MMMultimediaPresenter*)[segue destinationViewController];
	}
	else if([[segue identifier] isEqualToString:@"ratingBarSegue"])
	{
		_ratingView = (MMRatingBarController*)[segue destinationViewController];
		_ratingView.delegate = self;
	}
	else if([[segue identifier] isEqualToString:@"endOfShowSegue"])
	{
		MMPresentationConclusionController* controller = [segue destinationViewController];
		[controller setPresentationDelegate:self.delegate];
	}
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
	_builder = [[MMMultimediaResponseBuilder alloc] init];
	
	if([CameraEngine canCapture])
	{
		_recordingID = [[[NSUUID UUID] UUIDString] stringByReplacingOccurrencesOfString:@"-" withString:@"_"];
		[[CameraEngine engine] setFileName:_recordingID];
		[[CameraEngine engine] startup];
	}
	else
	{
		_recordingID = nil;
	}
	
	_currentMediaIndex = 1;
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	
	[_presentationView setPresenter:[MMPresenterFactory createPresenterForType:[presentationRequest presentationType]]];
	[[_presentationView presenter] setDelegate:self];
	[[_presentationView presenter] setMedia:[presentationRequest media]];
	[[_presentationView presenter] beginPresentingMedia];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
	
	[[CameraEngine engine] shutdown];
}

/**
 * Notifies the builder if the previous media was not rated to add a nil rating.
 * @param previousPath the path to the media that was displayed previously
 */
- (void)transitioningFromMedia:(NSString*)previousPath
{
	if(!_didRatePreviousMedia)
	{
		[_builder addRating:Nil forMediaAtPath:previousPath beganViewingAt:_beganCurrentViewTime];
	}
	
	_didRatePreviousMedia = NO;
}

/// Executes the builder's build procedure.
- (void)doBuild
{	
	if([presentationRequest locator])
	{
		[_builder buildForType:[[_presentationView presenter] presenterType] withRecordingIdentifier:_recordingID andLocation:[[presentationRequest locator] lastLocation]];
	}
	else
	{
		[_builder buildForType:[[_presentationView presenter] presenterType] withRecordingIdentifier:_recordingID];
	}
}

- (void)updateMediaCountLabelForMediaIndex:(int)index
{
	[self.mediaCounterLabel setText:[NSString stringWithFormat:@"%i of %i", index, [[presentationRequest media] count]]];
}


#pragma mark - MMRatingBarDelegate

- (void)didSpecifyRating:(MMRatingBarController*)controller withRating:(NSNumber*)rating
{
	[_builder addRating:rating forMediaAtPath:[[_presentationView presenter] currentMediaPath]	beganViewingAt:_beganCurrentViewTime];
	_didRatePreviousMedia = YES;
	[[_presentationView presenter] skipToNextMedia];
}

#pragma mark - MMMediaPresenterDelegate

- (void)isPreparingToTransition:(MMMediaPresenter *)presenter from:(NSString *)previous to:(NSString *)current
{
	[self transitioningFromMedia:previous];
}

- (void)didBeginPresentingMedia:(MMMediaPresenter*)presenter atPath:(NSString*)mediaPath
{
	if([CameraEngine canCapture] && [[CameraEngine engine] isCapturing] == NO)
	{
		[[CameraEngine engine] startCapture];
	}
	
	_beganCurrentViewTime = [NSDate date];
	[self updateMediaCountLabelForMediaIndex:_currentMediaIndex];
	_currentMediaIndex++;
}

- (void)didStopPresentingMedia:(MMMediaPresenter*)presenter atPath:(NSString*)mediaPath
{
}

- (void)didReachEndOfMedia:(MMMediaPresenter*)presenter
{
	if([[CameraEngine engine] isCapturing])
	{
		[[CameraEngine engine] stopCapture];
		
		if([[[MMCoreDataAssistant settings] autoSaveToCameraRoll] boolValue])
		{
			[[CameraEngine engine] exportVideoToCameraRoll:_recordingID];
		}
	}
	
	[self doBuild];
	[self performSegueWithIdentifier:@"endOfShowSegue" sender:self];
}

@end
