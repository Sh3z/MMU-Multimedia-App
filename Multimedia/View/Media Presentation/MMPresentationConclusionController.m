//
//  MMPresentationConclusionController.m
//  Multimedia
//
//  Created by Thomas Sherwood on 01/01/2014.
//  Copyright (c) 2014 Thomas Sherwood. All rights reserved.
//

#import "MMPresentationConclusionController.h"
#import "MMCoreDataAssistant.h"
#import "AppSettings.h"

@interface MMPresentationConclusionController ()<UIAlertViewDelegate>
@end

@implementation MMPresentationConclusionController

- (IBAction)didTapContinue:(id)sender
{
	if([[[MMCoreDataAssistant settings] passcodeEnabled] boolValue])
	{
		UIAlertView* view = [[UIAlertView alloc] initWithTitle:@"Enter Passcode" message:@"Enter the passcode to continue." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
		[view setAlertViewStyle:UIAlertViewStyleSecureTextInput];
		[view show];
	}
	else
	{
		[self notifyDelegateOfConclusion];
	}
}

- (void)validateEnteredCode:(NSString*)passcode
{
	if([passcode isEqualToString:@"1234"])
	{
		[self notifyDelegateOfConclusion];
	}
	else
	{
		UIAlertView* view = [[UIAlertView alloc] initWithTitle:@"Invalid Passcode" message:@"Incorrect passcode entered, please try again" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
		[view setAlertViewStyle:UIAlertViewStyleSecureTextInput];
		[view show];
	}
}

- (void)notifyDelegateOfConclusion
{
	if([self.presentationDelegate respondsToSelector:@selector(didConcludePresentation)])
	{
		[self.presentationDelegate didConcludePresentation];
	}
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
	if(buttonIndex == 1)
	{
		[self validateEnteredCode:[[alertView textFieldAtIndex:0] text]];
	}
}

@end
