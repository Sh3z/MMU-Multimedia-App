//
//  MMPresentationViewController.h
//  Multimedia
//
//  Created by Thomas Sherwood on 23/12/2013.
//  Copyright (c) 2013 Thomas Sherwood. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MMPresentationDelegate.h"
#import "MMRatingBarController.h"
#import "MMMediaPresenter.h"
#import "MMLocator.h"

/// Encapsuates the information required to run a presentation.
@interface MMPresentationRequest : NSObject

/// Contains the type of presentation to be ran.
@property (nonatomic) MMMediaType presentationType;

/// Contains the set of file paths pointing to the media.
@property (strong, nonatomic) NSArray* media;

/// Contains an object used to resolve the current location.
@property (strong, nonatomic) id<MMLocator> locator;

@end

/// Represents the UIViewController used to perform the presentation.
@interface MMPresentationViewController : UIViewController<MMRatingBarDelegate, MMMediaPresenterDelegate>

/// Contains the MMPresentationDelegate to be notified as the presentation progresses.
@property (strong, nonatomic) id<MMPresentationDelegate> delegate;

/// Contains the MMPresentationRequest to use when running the presentation.
@property (strong, nonatomic) MMPresentationRequest* presentationRequest;

/// Contains a reference to the label used to count the number of media presented.
@property (weak, nonatomic) IBOutlet UILabel *mediaCounterLabel;

@end
