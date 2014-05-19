//
//  MMTutorialController.m
//  Multimedia
//
//  Created by Thomas Sherwood on 30/12/2013.
//  Copyright (c) 2013 Thomas Sherwood. All rights reserved.
//

#import "MMTutorialController.h"
#import "MMTutorialAnimationController.h"

@interface MMTutorialController ()<MMTutorialAnimationDelegate>
{
	MMTutorialAnimationController* _animationController;
}
@end

@implementation MMTutorialController

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	if([[segue identifier] isEqualToString:@"presentChoicesSegue"])
	{
		[[segue destinationViewController] setPresentationDelegate:self.presentationDelegate];
	}
	else if([[segue identifier] isEqualToString:@"embeddedAnimationSegue"])
	{
		_animationController = [segue destinationViewController];
		[_animationController setAnimationDelegate:self];
	}
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	
	[self performSelector:@selector(beginAnimation) withObject:nil afterDelay:3];
}

- (void)beginAnimation
{
	[_animationController startTutorialAnimation];
}

- (IBAction)didTapContinue:(id)sender
{
	[self performSegueWithIdentifier:@"presentChoicesSegue" sender:self];
}

- (IBAction)didTapSkip:(id)sender
{
	[self performSegueWithIdentifier:@"presentChoicesSegue" sender:self];
}

- (IBAction)didTapRepeat:(id)sender
{
	self.repeatButton.enabled = NO;
	[UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^
	    {
			self.repeatButton.alpha = 0;
	    }completion:^(BOOL complete){}];
	
	[_animationController startTutorialAnimation];
}

#pragma mark - MMTutorialAnimationDelegate

- (void)animationController:(MMTutorialAnimationController *)controller didPresentStageWithDescription:(NSString *)description
{
	static NSTimeInterval animationDuration = 0.25;
	[UIView animateWithDuration:animationDuration delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^
	   {
		   self.descriptionLabel.alpha = 0;
	   }completion:^(BOOL finished)
	   {
		 self.descriptionLabel.text = description;
		 [UIView animateWithDuration:animationDuration delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^
			 {
				 self.descriptionLabel.alpha = 1;
			 }completion:^(BOOL finished){}];
	   }];
}

- (void)animationControllerDidReachEndOfTutorial:(MMTutorialAnimationController *)controller
{
	[UIView animateWithDuration:0.25 delay:1 options:UIViewAnimationOptionCurveEaseInOut animations:^
	 {
		 self.continueButton.alpha = 1;
		 self.repeatButton.alpha = 1;
	 }completion:^(BOOL finished)
	 {
		 self.continueButton.enabled = YES;
		 self.repeatButton.enabled = YES;
	 }];
}

@end
