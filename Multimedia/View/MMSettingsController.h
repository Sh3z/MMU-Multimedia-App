//
//  MMSettingsController.h
//  Multimedia
//
//  Created by Thomas Sherwood on 04/01/2014.
//  Copyright (c) 2014 Thomas Sherwood. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MMSettingsController;

/// Represents a delegate of the MMSettingsController.
@protocol MMSettingsDelegate <NSObject>
@optional

/**
 * Notifies this MMSettingsDelegate that the user finished using the control and
 * tapped either 'Done' or 'Cancel'.
 * @param controller the MMSettingsController that fired this call.
 * @param done if YES, the user tapped 'Done'. If NO, the user tapped 'Cancel'.
 */
- (void)settingsController:(MMSettingsController*)controller didFinishWithCompletion:(BOOL)done;

@end

/// Provides the UITableViewController logic for the application's settings view.
@interface MMSettingsController : UITableViewController

/// Contains the delegate object notified by this MMSettingsController of events.
@property (strong, nonatomic) id<MMSettingsDelegate> settingsDelegate;

/// Signals the view that the user wants to cancel any changes.
- (IBAction)didTapCancel:(id)sender;

/// Signals the view that the user wants to commit their changes.
- (IBAction)didTapDone:(id)sender;

@end
