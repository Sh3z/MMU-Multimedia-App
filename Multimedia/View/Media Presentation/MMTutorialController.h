//
//  MMTutorialController.h
//  Multimedia
//
//  Created by Thomas Sherwood on 30/12/2013.
//  Copyright (c) 2013 Thomas Sherwood. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MMPresentationDelegate.h"

/// Represents the controller used to provide the tutorial page.
@interface MMTutorialController : UIViewController

/// Contains the MMPresentationDelegate provided by the root view.
@property (strong, nonatomic) id<MMPresentationDelegate> presentationDelegate;

@property (weak, nonatomic) IBOutlet UIButton *continueButton;

@property (weak, nonatomic) IBOutlet UIButton *repeatButton;

@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;

@end
