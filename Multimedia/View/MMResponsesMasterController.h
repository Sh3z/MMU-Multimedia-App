//
//  MMResponsesMasterController.h
//  Multimedia
//
//  Created by Thomas Sherwood on 26/12/2013.
//  Copyright (c) 2013 Thomas Sherwood. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MMMasterTableBase.h"

/// Represents the master-view presenting an aggregation of MultimediaResponses
@interface MMResponsesMasterController : MMMasterTableBase

/// Contains the title of this view
@property (strong, nonatomic) NSString* responsesTitle;

/// Contains a reference to the export button.
@property (weak, nonatomic) IBOutlet UIBarButtonItem *exportButton;

@end
