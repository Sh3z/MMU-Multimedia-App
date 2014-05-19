//
//  MMMasterTableBase.m
//  Multimedia
//
//  Created by Thomas Sherwood on 01/01/2014.
//  Copyright (c) 2014 Thomas Sherwood. All rights reserved.
//

#import <MessageUI/MessageUI.h>
#import "MMMasterTableBase.h"
#import "MMResponseToCSV.h"
#import "MMSettingsController.h"

@class AppSettings;

@interface MMMasterTableBase ()<MFMailComposeViewControllerDelegate, MMSettingsDelegate>
@end

@implementation MMMasterTableBase

@synthesize responses, responsesDelegate = _responsesDelegate;

- (IBAction)didTapAcquireResponseButton:(id)sender
{
	[self.splitViewController performSegueWithIdentifier:@"presentationSegue" sender:self];
}

- (IBAction)didTapExportButton:(id)sender
{
	[self emailResponses:self.responses withFileName:@"All Responses" andSubject:@"Responses"];
}

- (IBAction)didTapSettingsButton:(id)sender
{
	[self presentModalSettingsForm];
}

- (void)presentModalSettingsForm
{
	[self.splitViewController performSegueWithIdentifier:@"presentSettingsSegue" sender:self];
}

- (void)emailResponses:(NSArray*)responsesToSend withFileName:(NSString*)fileName andSubject:(NSString*)subject
{
	MFMailComposeViewController* mf = [[MFMailComposeViewController alloc] init];
	mf.mailComposeDelegate = self;
	[mf setSubject:subject];
	[mf addAttachmentData:[MMResponseToCSV createCSVDataForComplexAggregation:responsesToSend] mimeType:@"csv" fileName:[NSString stringWithFormat:@"%@.csv", fileName]];
	[self presentViewController:mf animated:YES completion:nil];
}

- (void)setResponsesDelegate:(id<MMResponsesDelegate>)responsesDelegate
{
	_responsesDelegate = responsesDelegate;
}

#pragma mark - MFMailComposeViewControllerDelegate

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
	[self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - MMSettingsDelegate

- (void)settingsController:(MMSettingsController *)controller didFinishWithCompletion:(BOOL)done
{
	[self dismissViewControllerAnimated:YES completion:nil];
}

@end
