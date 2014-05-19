//
//  MMMultimediaResponseBuilder.h
//  Multimedia
//
//  Created by Thomas Sherwood on 24/12/2013.
//  Copyright (c) 2013 Thomas Sherwood. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MMMediaPresenter.h"

@class CLLocation;

/// Represents a pending response to some media.
@interface MMMultimediaResponse : NSObject

/**
 * Initializes and returns a new MMMultimediaResponse using the given information
 * @param rating the rating given by the user for the media
 * @param path the path to the media file
 * @param began an NSDate representing when the user began viewing the media
 * @param stopped an NSDate representing when the user provided the rating
 * @return an instance of the MMMultimediaResponse class containing the provided
 * information.
 */
- (id)initWithRating:(NSNumber*)rating forMediaAtPath:(NSString*)path beganViewingAt:(NSDate*)began stoppedViewingAt:(NSDate*)stopped;

/// Contains an NSDate representing when the user began viewing the media (read-only).
@property (strong, nonatomic, readonly) NSDate* viewTimeStart;

/// Contains an NSDate representing hen the user finished viewing the media (read-only).
@property (strong, nonatomic, readonly) NSDate* viewTimeFinished;

/// Contains the rating for the media given by the user.
@property (nonatomic, readonly) NSNumber* rating;

/// Contains the path to the media file.
@property (strong, nonatomic, readonly) NSString* path;

@end

/// Represents a builder object used to construct and persist a new response.
@interface MMMultimediaResponseBuilder : NSObject

/// Contains the time the MMMultimediaResponseBuilder was constructed (read-only).
@property (strong, nonatomic, readonly) NSDate* startTime;

/**
 * Adds a new media rating to the builder.
 * @param rating the rating of the media given by the user
 * @param path the path to the media file
 * @param began the time in which the user began viewing the media
 */
- (void)addRating:(NSNumber*)rating forMediaAtPath:(NSString*)path beganViewingAt:(NSDate*)began;

/**
 * Executes the build procedure and persists the information within core data
 * @param type the type of presented media
 * @param identifier the name of the file containing the recording
 */
- (void)buildForType:(enum MMMediaType)type withRecordingIdentifier:(NSString*)identifier;

/**
 * Executes the build procedure and persists the information within core data
 * @param type the type of presented media
 * @param identifier the name of the file containing the recording
 * @param location the current location
 */
- (void)buildForType:(enum MMMediaType)type withRecordingIdentifier:(NSString*)identifier andLocation:(CLLocation*)location;

@end
