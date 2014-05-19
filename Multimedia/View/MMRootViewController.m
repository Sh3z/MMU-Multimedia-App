//
//  MMRootViewController.m
//  Multimedia
//
//  Created by Thomas Sherwood on 30/12/2013.
//  Copyright (c) 2013 Thomas Sherwood. All rights reserved.
//

#import "MMRootViewController.h"
#import "MMTutorialController.h"
#import "MMSettingsController.h"

@implementation MMRootViewController

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	if([[segue identifier] isEqualToString:@"presentationSegue"])
	{
		UINavigationController* target = [segue destinationViewController];
		MMTutorialController* root = [[target viewControllers] firstObject];
		[root setPresentationDelegate:self];
	}
	else if([[segue identifier] isEqualToString:@"presentSettingsSegue"])
	{
		MMSettingsController* settings = [[[segue destinationViewController] viewControllers] firstObject];
		[settings setSettingsDelegate:(id<MMSettingsDelegate>)sender];
	}
}

- (void)didConcludePresentation
{
	[[self.viewControllers firstObject] popToRootViewControllerAnimated:NO];
	[self dismissViewControllerAnimated:YES completion:nil];
}

@end
