//
//  MMPresentationDelegate.h
//  Multimedia
//
//  Created by Thomas Sherwood on 30/12/2013.
//  Copyright (c) 2013 Thomas Sherwood. All rights reserved.
//

#import <Foundation/Foundation.h>

/// Represents an object that responds to the status of a presentation.
@protocol MMPresentationDelegate <NSObject>
@optional

/// Notifies this MMPresentationDelegate the presentation has concluded.
- (void)didConcludePresentation;

@end
