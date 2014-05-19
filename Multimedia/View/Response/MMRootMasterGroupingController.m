//
//  MMRootMasterGroupingController.m
//  Multimedia
//
//  Created by Thomas Sherwood on 01/01/2014.
//  Copyright (c) 2014 Thomas Sherwood. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "MMRootMasterGroupingController.h"
#import "MMCoreDataAssistant.h"
#import "MultimediaApp.h"
#import "MultimediaResponse.h"
#import "MMResponsesMasterController.h"
#import "MMMediaPresenter.h"

@interface MMRootMasterGroupingController ()<UITableViewDataSource, UITableViewDelegate>
{
	int _tappedRowNumber;
}
@end

@implementation MMRootMasterGroupingController

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	self.responses = [[[MMCoreDataAssistant applicationStore] responses] allObjects];
	self.tableView.dataSource = self;
	self.tableView.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
	self.responses = [[[MMCoreDataAssistant applicationStore] responses] allObjects];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	if([[segue identifier] isEqualToString:@"presentResponsesSegue"])
	{
		MMResponsesMasterController* controller = (MMResponsesMasterController*)[segue destinationViewController];
		NSString* viewTitle;
		NSArray* responses;
		switch (_tappedRowNumber)
		{
			case 0:
				viewTitle = @"All";
				responses = [NSArray arrayWithArray:self.responses];
				break;
				
			case 1:
				responses = [self responsesOfType:Image];
				viewTitle = @"Image";
				break;
				
			case 2:
				responses = [self responsesOfType:Audio];
				viewTitle = @"Audio";
				break;
		}
		
		[controller setResponsesTitle:viewTitle];
		[controller setResponses:responses];
	}
}

- (NSArray*)responsesOfType:(MMMediaType)type
{
	NSMutableArray* theResponses = [[NSMutableArray alloc] init];
	for(MultimediaResponse* response in self.responses)
	{
		if([response.mediaType intValue] == (int)type)
		{
			[theResponses addObject:response];
		}
	}
	
	return theResponses;
}

#pragma mark - Table View Data Source and Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	switch(section)
	{
		case 0:
			return 1;
			
		case 1:
			return 3;
			
		default:
			return 0;
	}
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if(indexPath.section == 0)
	{
		return [tableView dequeueReusableCellWithIdentifier:@"acquireCell"];
	}
	
	static NSString* CellIdentifier = @"responseCell";
	UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
	NSString* cellText;
	switch(indexPath.row)
	{
		case 0:
			cellText = @"All Responses";
			break;
			
		case 1:
			cellText = @"Image Responses";
			break;
			
		case 2:
			cellText = @"Audio Responses";
			break;
	}
	
	[cell.textLabel setText:cellText];
	return cell;
}

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	switch(section)
	{
		case 0:
			return @"";
			
		case 1:
			return @"Groups";
			
		default:
			return @"";
	}
}

- (NSString*)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
	switch(section)
	{
		case 0:
			return @"Begins the Multimedia presentation immediately. This can also be accessed by clicking the plus button.";
			
		case 1:
			return @"Tap a group to present the responses within the category. This refines the set displayed on the map to only those within the group.";
			
		default:
			return @"";
	}
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	if(indexPath.section == 0)
	{
		[super didTapAcquireResponseButton:self];
	}
	else
	{
		_tappedRowNumber = indexPath.row;
		[self performSegueWithIdentifier:@"presentResponsesSegue" sender:self];
	}
}

@end
