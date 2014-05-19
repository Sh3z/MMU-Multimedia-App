//
//  MMSlideShowPresenter.h
//  Multimedia
//
//  Created by Thomas Sherwood on 23/12/2013.
//  Copyright (c) 2013 Thomas Sherwood. All rights reserved.
//

#import "MMMediaPresenter.h"
#import "SlideShowEngine.h"

/// Represents the MMMediaPresenter used to present a collection of images.
@interface MMSlideShowPresenter : MMMediaPresenter<SlideShowEngineDelegate>

/// Contains the SlideShowEngine used to provide the actual presentation.
@property (strong, nonatomic) IBOutlet SlideShowEngine *slideShowEngine;

@end
