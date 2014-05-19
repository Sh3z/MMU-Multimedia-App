//
//  MMTutorialAnimationController.h
//  Multimedia
//
//  Created by Thomas Sherwood on 02/01/2014.
//  Copyright (c) 2014 Thomas Sherwood. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MMTutorialAnimationController;

/// Represents an information protocol implemented by objects wishing to recieve notifications from the survey tutorial controller.
@protocol MMTutorialAnimationDelegate <NSObject>
@optional

/**
 * Occurs when the tutorial is presenting information for a particular stage
 * @param controller the MMTutorialAnimationController that fired this event
 * @param description a description of the tutorial stage
 */
- (void)animationController:(MMTutorialAnimationController*)controller didPresentStageWithDescription:(NSString*)description;

/**
 * Occurs when the tutorial is complete
 * @param controller the MMTutorialAnimationController that fired this event
 */
- (void)animationControllerDidReachEndOfTutorial:(MMTutorialAnimationController *)controller;

@end

/// Represents the animation controller for the tutorial.
@interface MMTutorialAnimationController : UIViewController

/// Contains an object conforming to the MMTutorialAnimationDelegate information protocol.
@property (strong, nonatomic) id<MMTutorialAnimationDelegate> animationDelegate;

/// Contains the UIView used to present the animations within.
@property (weak, nonatomic) IBOutlet UIView *animationView;

/// Contains the set of image views for the SAM rating.
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *imageViews;

/// Begins the tutorial animations.
- (void)startTutorialAnimation;

@end
