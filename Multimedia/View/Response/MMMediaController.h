//
//  MMMediaController.h
//  Multimedia
//
//  Created by Thomas Sherwood on 27/12/2013.
//  Copyright (c) 2013 Thomas Sherwood. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MultimediaResponse, MediaResponse, XYPieChart;

/// Provides the controller logic for the UIView displaying a MediaResponse
@interface MMMediaController : UIViewController

/// Contains the parents MultimediaResponse
@property (strong, nonatomic) MultimediaResponse* parentResponse;

/// Contains the MediaResponse being displayed
@property (strong, nonatomic) MediaResponse* mediaResponse;

/// Contains the UITableView displaying the response information.
@property (weak, nonatomic) IBOutlet UITableView *informationTable;

@property (weak, nonatomic) IBOutlet XYPieChart *responsesPieChart;

/// Notifies this MMMediaController it has been set as the current controller within
/// the page view.
- (void)onSetAsCurrentView;

/// Notifies this MMMediaController it has been hidden from display within the
/// page view.
- (void)onHiddenFromView;

@end
