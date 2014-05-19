//
//  MMResponsesTableModel.m
//  Multimedia
//
//  Created by Thomas Sherwood on 01/01/2014.
//  Copyright (c) 2014 Thomas Sherwood. All rights reserved.
//

#import "MMResponsesTableModel.h"
#import "MultimediaResponse.h"
#import "NSDate+DateComparison.h"
#import "MMCoreDataAssistant.h"
#import "MMResponseDateGroup.h"
#import "MMMediaPresenter.h"

@interface MMResponsesTableModel ()
{
	NSMutableArray* _uniqueDates;
}

@end

@implementation MMResponsesTableModel

- (void)setResponses:(NSArray *)responses
{
	_responses = responses;
	
	_uniqueDates = [[NSMutableArray alloc] init];
	for(MultimediaResponse* response in _responses)
	{
		[self groupResponseByDate:response];
	}
	
	[_uniqueDates sortUsingDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"groupAcquisitionDate" ascending:NO]]];
}

- (MultimediaResponse *)responseAtIndexPath:(NSIndexPath *)path
{
	return [self responseInSection:path.section atRow:path.row];
}

- (MultimediaResponse*)responseInSection:(NSInteger)section atRow:(NSInteger)row
{
	return [[[_uniqueDates objectAtIndex:section] responses] objectAtIndex:row];
}

- (NSIndexPath*)pathForResponse:(MultimediaResponse*)response
{
	int section = 0;
	MMResponseDateGroup* theGroup;
	for(MMResponseDateGroup* group in _uniqueDates)
	{
		if([[response timeBegan] isOnSameDate:group.groupAcquisitionDate] == NSOrderedSame)
		{
			theGroup = group;
			break;
		}
		else
		{
			section++;
		}
	}
	
	if(theGroup)
	{
		NSUInteger row = [[theGroup responses] indexOfObject:response];
		return [NSIndexPath indexPathForRow:row inSection:section];
	}
	else
	{
		return nil;
	}
}

- (void)groupResponseByDate:(MultimediaResponse *)response
{
	BOOL added = NO;
	for(MMResponseDateGroup* group in _uniqueDates)
	{
		if([group doesResponseBelongInGroup:response])
		{
			[group addResponseToGroup:response];
			added = YES;
			break;
		}
	}
	
	if(!added)
	{
		MMResponseDateGroup* group = [[MMResponseDateGroup alloc] initWithDateOfAcquisition:response.timeBegan];
		[group addResponseToGroup:response];
		[_uniqueDates addObject:group];
	}
}

#pragma mark - Table View Data and Delegation

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return [_uniqueDates count];
}

- (int)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [[[_uniqueDates objectAtIndex:section] responses] count];
}

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
	[formatter setDateStyle:NSDateFormatterMediumStyle];
	return [formatter stringFromDate:[[_uniqueDates objectAtIndex:section] groupAcquisitionDate]];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString* CellIdentifier = @"responseCell";
	UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
	MultimediaResponse* response = [self responseInSection:indexPath.section atRow:indexPath.row];
	
	NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
	[formatter setTimeStyle:NSDateFormatterMediumStyle];
	[cell.textLabel setText:[formatter stringFromDate:[response timeBegan]]];
	
	UIImage* cellImg;
	MMMediaType type = [[response mediaType] intValue];
	switch(type)
	{
		case Image:
			cellImg = [UIImage imageNamed:@"singleimageicon"];
			break;
			
		case Audio:
			cellImg = [UIImage imageNamed:@"audioicon"];
			break;
	}
	
	cell.imageView.image = cellImg;
	
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	id response = [self responseInSection:indexPath.section atRow:indexPath.row];
	if([self.tableView isEditing])
	{
		if([self.responsesDelegate respondsToSelector:@selector(tableModel:isMultiselectingAndSelected:)])
		{
			[self.responsesDelegate tableModel:self isMultiselectingAndSelected:response];
		}
	}
	else
	{
		if([self.responsesDelegate respondsToSelector:@selector(tableModel:didSelectResponse:)])
		{
			[self.responsesDelegate tableModel:self didSelectResponse:response];
		}
	}
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
	if([self.tableView isEditing])
	{
		if([self.responsesDelegate respondsToSelector:@selector(tableModel:isMultiselectingAndDeselected:)])
		{
			[self.responsesDelegate tableModel:self isMultiselectingAndDeselected:[self responseInSection:indexPath.section atRow:indexPath.row]];
		}
	}
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
	return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
	// Undocumented style that provides multiselection the Apple way.
	return 3;
}

@end
