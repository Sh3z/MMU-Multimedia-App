//
//  MMResponseTableDataModel.m
//  Multimedia
//
//  Created by Thomas Sherwood on 27/12/2013.
//  Copyright (c) 2013 Thomas Sherwood. All rights reserved.
//

#import "MMResponseTableDataModel.h"
#import "MultimediaResponse.h"
#import "MediaResponse.h"
#import "MMMediaPresenter.h"
#import "MMRatingCell.h"

@implementation MMResponseTableDataModel

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return 4;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell* cell;
	if(indexPath.row != 3)
	{
		cell = [tableView dequeueReusableCellWithIdentifier:@"mediaDetailCell"];
	}
	else
	{
		cell = [tableView dequeueReusableCellWithIdentifier:@"mediaRatingCell"];
	}
	
	
	NSDateFormatter* timeFormatter = [[NSDateFormatter alloc] init];
	[timeFormatter setTimeStyle:NSDateFormatterLongStyle];
	
	switch(indexPath.row)
	{
		case 0:
			[cell.textLabel setText:@"File Name"];
			[cell.detailTextLabel setText:[_mediaResponse pathToMediaFile]];
			break;
			
		case 1:
			[cell.textLabel setText:@"Media Type"];
			[cell.detailTextLabel setText:[MMMediaTypeFormatter enumToString:[[_parentResponse mediaType] intValue]]];
			break;
			
		case 2:
			[cell.textLabel setText:@"View Duration"];
			int seconds = (int)[[_mediaResponse timeFinished] timeIntervalSinceDate:[_mediaResponse timeBegan]];
			
			if(seconds < 1)
			{
				[cell.detailTextLabel setText:@"Less than 1 second"];
			}
			else if(seconds == 1)
			{
				[cell.detailTextLabel setText:[NSString stringWithFormat:@"About %i second",(int)[[_mediaResponse timeFinished] timeIntervalSinceDate:[_mediaResponse timeBegan]]]];
			}
			else
			{
				[cell.detailTextLabel setText:[NSString stringWithFormat:@"About %i seconds",(int)[[_mediaResponse timeFinished] timeIntervalSinceDate:[_mediaResponse timeBegan]]]];
			}
			
			break;
			
		case 3:
			[(MMRatingCell*)cell setRating:[_mediaResponse rating]];
			break;
	}
	
	return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if(indexPath.row != 3)
	{
		return 44;
	}
	else
	{
		return 100;
	}
}

@end
