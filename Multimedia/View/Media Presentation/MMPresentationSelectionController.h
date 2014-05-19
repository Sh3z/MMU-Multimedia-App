//
//  MMPresentationSelectionController.h
//  Multimedia
//
//  Created by Thomas Sherwood on 25/12/2013.
//  Copyright (c) 2013 Thomas Sherwood. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MMPresentationViewController.h"

/// Represents the controller providing the choice between presentation modes.
@interface MMPresentationSelectionController : UIViewController

/// Contains the presentation delegate.
@property (strong, nonatomic) id<MMPresentationDelegate> presentationDelegate;

/**
 * Occurs when the user taps the button beginning the images presentation.
 * @param sender the source of the event firing
 */
- (IBAction)didTapImagesButton:(id)sender;

/**
 * Occurs when the user taps the button beginning the audio presentation.
 * @param sender the source of the event firing
 */
- (IBAction)didTapAudioButton:(id)sender;

@end
