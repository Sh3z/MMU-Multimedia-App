//
//  MMResponsesSource.h
//  Multimedia
//
//  Created by Thomas Sherwood on 01/01/2014.
//  Copyright (c) 2014 Thomas Sherwood. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MultimediaResponse;
@protocol MMResponsesSource;

/// Represents an object which uses the current set of MultimediaResponse objects for use in a view.
@protocol MMResponsesDelegate <NSObject>
@optional

/// Contains a reference to the currently displayed MultimediaResponse.
@property (strong, nonatomic) MultimediaResponse* currentResponse;

/**
 * Notifies this delegate that the associated source of responses has a new aggregation of sources
 * available for display
 * @param source the MMResponsesSource object the event is occuring from
 * @param responses an NSArray of the available MultimediaResponses.
 */
- (void)responseSource:(id<MMResponsesSource>)source newAvailableResponses:(NSArray*)responses;

/**
 * Notifies this delegate that the associated source of responses has chosen
 * a specific response to display information for.
 * @param source the MMResponsesSource object the event is occuring from
 * @param response the MultimediaResponse selected by the user.
 */
- (void)responseSource:(id<MMResponsesSource>)source didSelectResponse:(MultimediaResponse*)response;

@end

/// Represents the source of a collection of MultimediaResponse objects that are being currently displayed.
@protocol MMResponsesSource <NSObject>

/// Contains the delegate object using the current set of displayed responses.
@property (strong, nonatomic) id<MMResponsesDelegate> responsesDelegate;

/// Contains an NSArray of each MultimediaResponse to be displayed.
@property (strong, nonatomic) NSArray* responses;

@end
