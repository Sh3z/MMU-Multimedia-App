//
//  MMMultimediaResponseBuilder.m
//  Multimedia
//
//  Created by Thomas Sherwood on 24/12/2013.
//  Copyright (c) 2013 Thomas Sherwood. All rights reserved.
//

#import "MMMultimediaResponseBuilder.h"
#import "MMCoreDataAssistant.h"
#import "MediaResponse.h"
#import "MultimediaResponse.h"
#import "MultimediaApp.h"

@implementation MMMultimediaResponse

- (id)initWithRating:(NSNumber*)rating forMediaAtPath:(NSString *)path beganViewingAt:(NSDate *)began stoppedViewingAt:(NSDate *)stopped
{
	if(self = [super init])
	{
		_rating = rating;
		_path = path;
		_viewTimeStart = began;
		_viewTimeFinished = stopped;
	}
	
	return self;
}

@end

@interface MMMultimediaResponseBuilder ()
{
	NSMutableArray* _responses;
}

@end

@implementation MMMultimediaResponseBuilder

- (id)init
{
	if(self = [super init])
	{
		_startTime = [NSDate date];
		_responses = [[NSMutableArray alloc] init];
	}
	
	return self;
}

- (void)addRating:(NSNumber*)rating forMediaAtPath:(NSString*)path beganViewingAt:(NSDate*)began
{
	MMMultimediaResponse* response = [[MMMultimediaResponse alloc] initWithRating:rating forMediaAtPath:path beganViewingAt:began stoppedViewingAt:[NSDate date]];
	[_responses addObject:response];
}

- (void)buildForType:(enum MMMediaType)type withRecordingIdentifier:(NSString*)identifier
{
	[self buildForType:type withRecordingIdentifier:identifier andLocation:nil];
}

- (void)buildForType:(enum MMMediaType)type withRecordingIdentifier:(NSString*)identifier andLocation:(CLLocation*)location
{
	MultimediaApp* app = [MMCoreDataAssistant applicationStore];
	MultimediaResponse* response = (MultimediaResponse*)[MMCoreDataAssistant createEntityWithIdentifier:@"MultimediaResponse"];
	[response setValue:_startTime forKey:@"timeBegan"];
	[response setValue:[NSDate date] forKey:@"timeFinished"];
	[response setValue:[NSNumber numberWithInt:type] forKey:@"mediaType"];
	[response setValue:identifier forKey:@"recordingFileIdentifier"];
	[response setValue:location forKey:@"location"];
	
	for(MMMultimediaResponse* currentResponse in _responses)
	{
		MediaResponse* mediaResponse = (MediaResponse*)[MMCoreDataAssistant createEntityWithIdentifier:@"MediaResponse"];
		[mediaResponse setValue:currentResponse.rating forKey:@"rating"];
		[mediaResponse setValue:currentResponse.path forKey:@"pathToMediaFile"];
		[mediaResponse setValue:currentResponse.viewTimeStart forKey:@"timeBegan"];
		[mediaResponse setValue:currentResponse.viewTimeFinished forKey:@"timeFinished"];
		
		[response addMediaObject:mediaResponse];
	}
	
	[app addResponsesObject:response];
	[MMCoreDataAssistant saveContext];
}

@end
