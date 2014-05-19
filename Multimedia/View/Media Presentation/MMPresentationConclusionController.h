//
//  MMPresentationConclusionController.h
//  Multimedia
//
//  Created by Thomas Sherwood on 01/01/2014.
//  Copyright (c) 2014 Thomas Sherwood. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MMPresentationDelegate.h"

/// Provides the controller logic for the post-survey view
@interface MMPresentationConclusionController : UIViewController

/// Contains an object conforming to the MMPresentationDelegate information protocol
@property (strong, nonatomic) id<MMPresentationDelegate> presentationDelegate;

/// Occurs when the user taps 'continue'.
- (IBAction)didTapContinue:(id)sender;

@end
