//
//  MMMasterTableBase.h
//  Multimedia
//
//  Created by Thomas Sherwood on 01/01/2014.
//  Copyright (c) 2014 Thomas Sherwood. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MMResponsesSource.h"

/// Represents the base class for the tables presented in the root master view of the app.
@interface MMMasterTableBase : UIViewController<MMResponsesSource>

/// Contains the UITableView used to present the content in the view.
@property (weak, nonatomic) IBOutlet UITableView* tableView;

/// Contains the UIToolBar providing particular features for this view.
@property (weak, nonatomic) IBOutlet UIToolbar* actionsToolbar;

/// Called when the export button for the view has been tapped.
- (IBAction)didTapExportButton:(id)sender;

/// Called when the acquire response button for the view has been tapped.
- (IBAction)didTapAcquireResponseButton:(id)sender;

/// Called when the settings button for the view has been tapped.
- (IBAction)didTapSettingsButton:(id)sender;

/// Presents the settings form modally.
- (void)presentModalSettingsForm;

/**
 * Provides the UI for sending a batch of responses by email.
 * @param responsesToSend a collection of MultimediaResponse objects to send by email.
 * @param fileName the name to give to the file in the attachment
 * @param subject the subject to provide the email UI with.
 */
- (void)emailResponses:(NSArray*)responsesToSend withFileName:(NSString*)fileName andSubject:(NSString*)subject;

@end
