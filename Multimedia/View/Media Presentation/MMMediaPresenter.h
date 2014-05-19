//
//  MMMediaPresenter.h
//  Multimedia
//
//  Created by Thomas Sherwood on 23/12/2013.
//  Copyright (c) 2013 Thomas Sherwood. All rights reserved.
//

#import <UIKit/UIKit.h>

/// Represents a possible supported mode of image file to be displayed.
typedef NS_ENUM(NSInteger, MMMediaType)
{
    Image = 0,
    Audio = 1
};

@class MMMediaPresenter;

/// Represents the delegate of an MMMediaPresenter, which is notified as media is
/// presented within the control.
@protocol MMMediaPresenterDelegate <NSObject>
@optional

/**
 * Occurs when the MMMediaPresenter begins presenting new media.
 * @param presenter the MMMediaPresenter presenting the media
 * @param mediaPath the path to the media file.
 */
- (void)didBeginPresentingMedia:(MMMediaPresenter*)presenter atPath:(NSString*)mediaPath;

/**
 * Occurs when the MMMediaPresenter is transition between two items of media.
 * @param presenter the MMMediaPresenter presenting the media
 * @param previous the path to the file containing the previously displayed media.
 * @param to the path to the file containing the new media, or nil if the previous
 * media is the last media in the set.
 */
- (void)isPreparingToTransition:(MMMediaPresenter*)presenter from:(NSString*)previous to:(NSString*)current;

/**
 * Occurs when the MMMediaPresenter stops presenting a specific media.
 * @param presenter the MMMediaPresenter presenting the media
 * @param mediaPath the path to the file containing the media
 */
- (void)didStopPresentingMedia:(MMMediaPresenter*)presenter atPath:(NSString*)mediaPath;

/**
 * Occurs when the MMMediaPresenter has completed presenting the media.
 * @param presenter the MMMediaPresenter that has completed its presentation.
 */
- (void)didReachEndOfMedia:(MMMediaPresenter*)presenter;

@end

/// Represents the base class for a UIViewController used to present a collection
/// of media. This class is abstract.
@interface MMMediaPresenter : UIViewController
{
	/// Contains the path to the current media file.
	NSString* _currentMediaPath;
	
	/// Contains the type of presenter this MMMediaPresenter represents.
	MMMediaType _presenterType;
}

/// Contains the MMMediaPresenterDelegate that is notified as the presentation progresses.
@property (strong, nonatomic) id<MMMediaPresenterDelegate> delegate;

/// Contains the set of media this MMMediaPresenter will present.
@property (strong, nonatomic) NSArray* media;

/// Contains the path to the current media file (read-only).
@property (strong, nonatomic, readonly) NSString* currentMediaPath;

/// Contains the MMMediaType describing this MMMediaPresenter (read-only).
@property (nonatomic, readonly) MMMediaType presenterType;

/// Begins the presentation of media, from the first media in the set. This is abstract.
- (void)beginPresentingMedia;

/// Skips the current media and begins presenting the next. This is abstract.
- (void)skipToNextMedia;

/// Stops the media presentation. This is abstract.
- (void)stopPresentingMedia;

/// Performs re-initialization of this MMMediaPresenter with a new collection of
/// media files. This is protected.
- (void)reinitializeFromMedia:(NSArray*)media;

@end

/// Provides formatting capabilities for the MMMediaType enumeration.
@interface MMMediaTypeFormatter : NSObject

/**
 * Converts an MMMediaType to a String literal.
 * @param type the MMMediaType to convert
 * @return the human-readable form of the enumeration.
 */
+ (NSString*)enumToString:(MMMediaType)type;

@end
