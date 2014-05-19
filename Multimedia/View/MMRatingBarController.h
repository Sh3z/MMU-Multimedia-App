//
//  MMRatingBarController.h
//  Multimedia
//
//  Created by Thomas Sherwood on 23/12/2013.
//  Copyright (c) 2013 Thomas Sherwood. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MMRatingBarController;

/// Represents the delegate object notified by an MMRatingBarController as ratings
/// are provided.
@protocol MMRatingBarDelegate <NSObject>
@optional

/**
 * Notifies this delegate that the MMRatingBarController has specified a rating.
 * @param controller the MMRatingBarController providing the rating
 * @param rating an NSNumber containing the rating provided, between 0 and 100
 * inclusive.
 */
- (void)didSpecifyRating:(MMRatingBarController*)controller withRating:(NSNumber*)rating;

@end

/// Represents the UIViewController providing the controller logic for the rating bat.
@interface MMRatingBarController : UIViewController

/// Contains the MMRatingbarDelegate object notified as ratings are provided.
@property id<MMRatingBarDelegate> delegate;

/// Contains the collection of UIButtons used to give ratings.
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *ratingButtons;

@end
