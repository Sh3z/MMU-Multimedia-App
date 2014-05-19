//
//  MMResponseDateGroup.h
//  Multimedia
//
//  Created by Thomas Sherwood on 05/01/2014.
//  Copyright (c) 2014 Thomas Sherwood. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MultimediaResponse;

/// Represents a collection of MultimediaResponse objects, grouped by date.
@interface MMResponseDateGroup : NSObject

/**
 * Initializes and returns a new MMResponseDateGroup, which groups MultimediaResponse objects under a date.
 * @param date the NSDate to group responses under
 * @return a initialized MMResponseDateGroup instance.
 */
- (id)initWithDateOfAcquisition:(NSDate*)date;

/// Contains the NSDate used to group the responses under.
@property (strong, nonatomic, readonly) NSDate* groupAcquisitionDate;

/// Contains the set of responses within this MMResponseDateGroup.
@property (strong, nonatomic, readonly) NSArray* responses;

/**
 * Checks to see whether a MultimediaResponse can be added to this MMResponseDateGroup.
 * @param response the MultimediaResponse to check belongs within this group
 * @return YES if the MultimediaResponse can be added to this group, NO otherwise.
 */
- (BOOL)doesResponseBelongInGroup:(MultimediaResponse*)response;

/**
 * Adds a MultimediaResponse to this group.
 * @param response the MultimediaResponse to add to this group
 * @return YES if the response was added; NO otherwise
 */
- (BOOL)addResponseToGroup:(MultimediaResponse*)response;

/**
 * Removes a MultimediaResponse from this group
 * @param response the MultimediaResponse to remove from this group
 * @return YES if the response was removed, NO otherwise
 */
- (BOOL)removeResponse:(MultimediaResponse*)response;

@end
