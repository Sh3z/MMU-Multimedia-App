//
//  MMMediaResponseChartDelegate.m
//  Multimedia
//
//  Created by Thomas Sherwood on 04/01/2014.
//  Copyright (c) 2014 Thomas Sherwood. All rights reserved.
//

#import "MMMediaResponseChartDataSource.h"
#import "MMCoreDataAssistant.h"
#import "MultimediaApp.h"
#import "MultimediaResponse.h"
#import "MediaResponse.h"

@interface MMMediaResponseChartDataSource ()
{
	/// Contains the set of NSNumber -> NSMutableArray pairs of response ratings and their media.
	NSMutableDictionary* _responsesGroupedByValue;
}

@end

@implementation MMMediaResponseChartDataSource

+ (instancetype)createWithResponse:(MediaResponse *)response
{
	return [[MMMediaResponseChartDataSource alloc] initWithResponse:response];
}

- (id)initWithResponse:(MediaResponse *)response
{
	if(self = [super init])
	{
		_response = response;
	}
	
	return self;
}

- (void)calculateInformation
{
	_responsesGroupedByValue = [[NSMutableDictionary alloc] init];
	NSFetchRequest* fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"MediaResponse"];
	[fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"pathToMediaFile LIKE[c] %@", [_response pathToMediaFile]]];
	NSError* error;
	NSArray* results = [[MMCoreDataAssistant managedObjectContext] executeFetchRequest:fetchRequest error:&error];
	if(error)
	{
		NSLog([NSString stringWithFormat:@"Error fetching MultimediaResponses: %@", error]);
	}
	else
	{
		[self recalculateWithResponses:results];
	}
}

- (void)recalculateWithResponses:(NSArray*)responses
{
	// Shove everything into the dictionary to begin with
	for(MediaResponse* response in responses)
	{
		// Response ratings may be nil if no rating was given. Group by NSNull instead
		id ratingKey = response.rating ? response.rating : [NSNull null];
		NSMutableArray* array = [_responsesGroupedByValue objectForKey:ratingKey];
		if(array)
		{
			[array addObject:response];
		}
		else
		{
			array = [NSMutableArray arrayWithObject:response];
			[_responsesGroupedByValue setObject:array forKey:ratingKey];
		}
	}
}

- (NSArray*)responsesForSection:(NSUInteger)section
{
	if(section == 0)
	{
		return [_responsesGroupedByValue objectForKey:[NSNull null]];
	}
	else
	{
		int samRatingAtIndex = 20 * section;
		return [_responsesGroupedByValue objectForKey:[NSNumber numberWithShort:samRatingAtIndex]];
	}
}

- (CGFloat)numberOfEntriesAtIndex:(NSUInteger)index
{
	NSArray* responses = [self responsesForSection:index];
	if(responses)
	{
		return [responses count];
	}
	else
	{
		return 0;
	}
}

#pragma mark - XYPieChartDataSource

- (NSUInteger)numberOfSlicesInPieChart:(XYPieChart *)pieChart
{
	return 6;
}

- (CGFloat)pieChart:(XYPieChart *)pieChart valueForSliceAtIndex:(NSUInteger)index
{
	return [self numberOfEntriesAtIndex:index];
}

- (NSString*)pieChart:(XYPieChart *)pieChart textForSliceAtIndex:(NSUInteger)index
{
	if(index == 0)
	{
		return [NSString stringWithFormat:@"%i gave no rating", (int)([self numberOfEntriesAtIndex:index])];
	}
	else
	{
		return [NSString stringWithFormat:@"%i rated %d", (int)([self numberOfEntriesAtIndex:index]), index];
	}
}

@end
