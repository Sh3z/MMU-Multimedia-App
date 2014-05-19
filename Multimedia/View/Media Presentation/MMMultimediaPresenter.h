//
//  MMMultimediaPresenter.h
//  Multimedia
//
//  Created by Thomas Sherwood on 23/12/2013.
//  Copyright (c) 2013 Thomas Sherwood. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MMMediaPresenter.h"

/// Represents the controller providing the presentation of the media.
@interface MMMultimediaPresenter : UIViewController

/// Contains an inner UIView for displaying the media.
@property (weak, nonatomic) IBOutlet UIView *innerView;

/// Contains an MMMediaPresenter implementation for providing the presentation logic.
@property (strong, nonatomic) MMMediaPresenter* presenter;

@end
