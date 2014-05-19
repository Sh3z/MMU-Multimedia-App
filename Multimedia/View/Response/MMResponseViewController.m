//
//  MMResponseViewController.m
//  Multimedia
//
//  Created by Thomas Sherwood on 27/12/2013.
//  Copyright (c) 2013 Thomas Sherwood. All rights reserved.
//

#import <MessageUI/MessageUI.h>
#import <MediaPlayer/MediaPlayer.h>
#import "MMResponseViewController.h"
#import "MultimediaResponse.h"
#import "MMMediaModelController.h"
#import "MMMediaController.h"
#import "CameraEngine.h"
#import "MMResponseToCSV.h"
#import "MMCoreDataAssistant.h"

@interface MMResponseViewController ()<UIAlertViewDelegate, UIActionSheetDelegate, MFMailComposeViewControllerDelegate>
{
	MPMoviePlayerController* _moviePlayer;
}

/// Contains the model used to manage the page view.
@property (strong, nonatomic) MMMediaModelController* modelController;

/// Contains a reference to the UIActionSheet used for exporting the response.
@property (strong, nonatomic) UIActionSheet* exportSheet;

@end

@implementation MMResponseViewController

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	// Configure the page view controller and add it as a child view controller.
	self.pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
	
	[self addChildViewController:self.pageViewController];
	[self.pageViewController.view setFrame:self.pagesContainerView.frame];
	[self.pagesContainerView addSubview:self.pageViewController.view];
	[self.pageViewController didMoveToParentViewController:self];
	self.view.gestureRecognizers = self.pageViewController.gestureRecognizers;
	
	_modelController = [[MMMediaModelController alloc] init];
	self.pageViewController.dataSource = _modelController;
	self.pageViewController.delegate = _modelController;
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
	NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
	[formatter setDateStyle:NSDateFormatterMediumStyle];
	[self.navigationItem setTitle:[NSString stringWithFormat:@"Response acquired on %@", [formatter stringFromDate:[_response timeBegan]]]];
	
	[_modelController setResponse:_response];
	MMMediaController* startingViewController = [self.modelController viewControllerAtIndex:0 storyboard:self.storyboard];
	[startingViewController.view setFrame:self.view.frame];
	NSArray *viewControllers = @[startingViewController];
	[self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
	
	if([_response recordingFileIdentifier])
	{
		[self setupMediaPlayer];
	}
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
	
	[_moviePlayer stop];
}

- (IBAction)didTapActionButton:(id)sender
{
	if(!_exportSheet)
	{
		_exportSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Export Video",  @"E-mail Response", nil];
		[_exportSheet showFromBarButtonItem:self.exportBarButtonItem animated:YES];
	}
}

- (void)setupMediaPlayer
{
	_moviePlayer = [[MPMoviePlayerController alloc] initWithContentURL:[self urlForVideo]];
	
	[_moviePlayer setMovieSourceType:MPMovieSourceTypeFile];
	[_moviePlayer setControlStyle:MPMovieControlStyleEmbedded];
	[_moviePlayer setScalingMode:MPMovieScalingModeAspectFit];
	
	[self.movieContainerView addSubview:[_moviePlayer view]];
	UIView* movieView = _moviePlayer.view;
	movieView.translatesAutoresizingMaskIntoConstraints = NO;
	
	NSDictionary* views = NSDictionaryOfVariableBindings(movieView);
	
	[self.movieContainerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[movieView]|" options:0 metrics:Nil views:views]];
	[self.movieContainerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[movieView]|" options:0 metrics:nil views:views]];
	
	[self.movieContainerView layoutIfNeeded];
	[_moviePlayer prepareToPlay];
}

/**
 * Sends an email with the CSV response data object
 * @param csv the CSV data in an NSData object
 */
- (void)sendEmailWithCSV:(NSData*)csv
{
	NSString* fileName = [NSString stringWithFormat:@"Response Acquired On %@.csv", [_response timeBegan]];
	MFMailComposeViewController* mf = [[MFMailComposeViewController alloc] init];
	mf.mailComposeDelegate = self;
	[mf setSubject:[fileName stringByDeletingPathExtension]];
	[mf addAttachmentData:csv mimeType:@"csv" fileName:fileName];
	
	[self presentViewController:mf animated:YES completion:nil];
}

/**
 * Gets the URL for the video
 * @return an NSURL representing the URL to the response's video
 */
- (NSURL*)urlForVideo
{
	return [NSURL fileURLWithPath:[NSTemporaryDirectory() stringByAppendingString:[[_response recordingFileIdentifier] stringByAppendingString:@"_0.mp4"]]];
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
	_exportSheet = nil;
	
	if(buttonIndex == 0)
	{
		[[CameraEngine engine] exportVideoToCameraRoll:[_response recordingFileIdentifier]];
		[[[UIAlertView alloc] initWithTitle:nil message:@"Video Exported to Camera Roll" delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil] show];
	}
	else if(buttonIndex == 1)
	{
		[self sendEmailWithCSV:[MMResponseToCSV createCSVDataForAggregation:_response]];
	}
}

#pragma mark - MFMailComposeViewControllerDelegate

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
	[self dismissViewControllerAnimated:YES completion:nil];
}

@end
