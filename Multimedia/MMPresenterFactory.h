//
//  MMPresenterFactory.h
//  Multimedia
//
//  Created by Thomas Sherwood on 24/12/2013.
//  Copyright (c) 2013 Thomas Sherwood. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MMMediaPresenter.h"

/// Provides factoy logic for constructing an appropriate MMMediaPresenter
@interface MMPresenterFactory : NSObject

/**
 * Constructs and returns an MMMediaPresenter for a given MMMediaType.
 * @param type the desired type of MMMediaPresenter.
 * @param an instance of MMMediaPresenter suited for playing the provided type
 * of media.
 */
+ (MMMediaPresenter*)createPresenterForType:(MMMediaType)type;

@end
