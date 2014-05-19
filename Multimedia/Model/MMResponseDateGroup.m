//
//  MMResponseDateGroup.m
//  Multimedia
//
//  Created by Thomas Sherwood on 05/01/2014.
//  Copyright (c) 2014 Thomas Sherwood. All rights reserved.
//

#import "MMResponseDateGroup.h"
#import "MultimediaResponse.h"
#import "NSDate+DateComparison.h"

@implementation MMResponseDateGroup : NSObject

@synthesize responses = _responses;

- (id)initWithDateOfAcquisition:(NSDate *)date
{
	if(self = [super init])
	{
		_responses = [[NSMutableArray alloc] init];
		_groupAcquisitionDate = date;
	}
	
	return self;
}

- (BOOL)doesResponseBelongInGroup:(MultimediaResponse *)response
{
	return [_groupAcquisitionDate isOnSameDate:response.timeBegan] == NSOrderedSame;
}

- (BOOL)addResponseToGroup:(MultimediaResponse *)response
{
	if([self doesResponseBelongInGroup:response])
	{
		[(NSMutableArray*)_responses addObject:response];
		NSSortDescriptor* sorter = [NSSortDescriptor sortDescriptorWithKey:@"timeBegan" ascending:NO];
		_responses = [[_responses sortedArrayUsingDescriptors:[NSArray arrayWithObject:sorter]] mutableCopy];
		return YES;
	}
	else
	{
		return NO;
	}
}

- (BOOL)removeResponse:(MultimediaResponse *)response
{
	BOOL wasPresent = [_responses containsObject:response];
	[(NSMutableArray*)_responses removeObject:response];
	return wasPresent;
}

@end
