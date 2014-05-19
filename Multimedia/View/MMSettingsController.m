//
//  MMSettingsController.m
//  Multimedia
//
//  Created by Thomas Sherwood on 04/01/2014.
//  Copyright (c) 2014 Thomas Sherwood. All rights reserved.
//

#import "MMSettingsController.h"
#import "MMCoreDataAssistant.h"
#import "AppSettings.h"

@interface MMSettingsController ()
{
	UISwitch* _exportVideosSwitch;
	UISwitch* _passcodeSwitch;
}

@end

@implementation MMSettingsController

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	AppSettings* settings = [MMCoreDataAssistant settings];
	_exportVideosSwitch = [[UISwitch alloc] initWithFrame:CGRectZero];
	_exportVideosSwitch.on = [settings.autoSaveToCameraRoll boolValue];
	_passcodeSwitch = [[UISwitch alloc] initWithFrame:CGRectZero];
	_passcodeSwitch.on = [settings.passcodeEnabled boolValue];
}

- (IBAction)didTapCancel:(id)sender
{
	[self notifyDelegateOfCompletion:NO];
}

- (IBAction)didTapDone:(id)sender
{
	AppSettings* settings = [MMCoreDataAssistant settings];
	settings.autoSaveToCameraRoll = [NSNumber numberWithBool:_exportVideosSwitch.on];
	settings.passcodeEnabled = [NSNumber numberWithBool:_passcodeSwitch.on];
	[MMCoreDataAssistant saveContext];
	
	[self notifyDelegateOfCompletion:YES];
}

- (void)notifyDelegateOfCompletion:(BOOL)completion
{
	if([_settingsDelegate respondsToSelector:@selector(settingsController:didFinishWithCompletion:)])
	{
		[_settingsDelegate settingsController:self didFinishWithCompletion:completion];
	}
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"settingsCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(indexPath.section == 0)
	{
		cell.textLabel.text = @"Automatically Export Video";
		cell.detailTextLabel.text = @"";
		cell.accessoryView = _exportVideosSwitch;
	}
	else
	{
		cell.textLabel.text = @"Enable Passcode";
		cell.detailTextLabel.text = @"";
		cell.accessoryView = _passcodeSwitch;
	}
    
    return cell;
}

- (NSString*)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
	if(section == 0)
	{
		return @"Recordings of respondants are saved to the application folder, and are exported to the Camera Roll manually. Enable this option to automatically export them to the Camera Roll.";
	}
	else
	{
		return @"Enabling the passcode prevents respondants from viewing other responses after the presentation is complete.";
	}
}

@end
