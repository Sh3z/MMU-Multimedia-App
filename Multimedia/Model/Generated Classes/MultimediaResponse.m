//
//  MultimediaResponse.m
//  Multimedia
//
//  Created by Thomas Sherwood on 24/12/2013.
//  Copyright (c) 2013 Thomas Sherwood. All rights reserved.
//

#import "MultimediaResponse.h"
#import "MediaResponse.h"
#import "MultimediaApp.h"


@implementation MultimediaResponse

@dynamic timeBegan;
@dynamic timeFinished;
@dynamic location;
@dynamic recordingFileIdentifier;
@dynamic mediaType;
@dynamic media;
@dynamic app;

- (CLLocationCoordinate2D)coordinate
{
	return [(CLLocation*)self.location coordinate];
}

- (NSString*)title
{
	NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
	[formatter setDateStyle:NSDateFormatterMediumStyle];
	return [formatter stringFromDate:self.timeBegan];
}

/**
 * Works around an auto-code generation bug where items cannot be added to
 * ordered sets.
 * @param value the NSmanagedObject instance to add to the media set.
 */
- (void)addMediaObject:(NSManagedObject *)value
{
	NSMutableOrderedSet* tmp = [NSMutableOrderedSet orderedSetWithOrderedSet:self.media];
	[tmp addObject:value];
	self.media = tmp;
}

@end
