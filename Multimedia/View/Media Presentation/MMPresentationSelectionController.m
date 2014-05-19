//
//  MMPresentationSelectionController.m
//  Multimedia
//
//  Created by Thomas Sherwood on 25/12/2013.
//  Copyright (c) 2013 Thomas Sherwood. All rights reserved.
//

#import "MMPresentationSelectionController.h"
#import "MMMediaPresenter.h"
#import "MMLocationAssistant.h"

@interface MMPresentationSelectionController ()
{
	/// Contains the selected type of presentation
	MMMediaType _selectedType;
	
	/// Contains the locator object.
	MMLocationAssistant* _locator;
}

@end

@implementation MMPresentationSelectionController

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	_locator = [[MMLocationAssistant alloc] init];
	[_locator beginTrackingLocationWithAccuracy:kCLLocationAccuracyBest];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	if([[segue identifier] isEqualToString:@"pushModalPresentation"])
	{
		MMPresentationViewController* presenter = [segue destinationViewController];
		MMPresentationRequest* req = [[MMPresentationRequest alloc] init];
		req.presentationType = _selectedType;
		
		switch(_selectedType)
		{
			case Image:
				req.media = [NSArray arrayWithObjects:@"test_1.jpg", @"test_2.jpg", @"test_3.jpg", nil];
				break;
				
			case Audio:
				req.media = [NSArray arrayWithObjects:@"Rondo_Alla_Turka_Short.aiff", @"Rondo_Alla_Turka_Short.aiff", @"Rondo_Alla_Turka_Short.aiff", nil];
				break;
		}
		
		[req setLocator:_locator];
		
		[presenter setDelegate:self.presentationDelegate];
		[presenter setPresentationRequest:req];
	}
}

- (IBAction)didTapImagesButton:(id)sender
{
	_selectedType = Image;
	[self performSegueWithIdentifier:@"pushModalPresentation" sender:self];
}

- (IBAction)didTapAudioButton:(id)sender
{
	_selectedType = Audio;
	[self performSegueWithIdentifier:@"pushModalPresentation" sender:self];
}

@end
