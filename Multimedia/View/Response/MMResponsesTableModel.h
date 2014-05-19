//
//  MMResponsesTableModel.h
//  Multimedia
//
//  Created by Thomas Sherwood on 01/01/2014.
//  Copyright (c) 2014 Thomas Sherwood. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MultimediaResponse, MMResponsesTableModel;

/// Represents an object which responds to updates within an MMResponsesTableModel.
@protocol MMResponsesTableDelegate <NSObject>
@optional

/**
 * Occurs when a single MultimediaResponse has been selected when the table is not in edit mode.
 * @param model the MMResponsesTableModel that sent this event
 * @param response the MultimediaResponse object that was selected.
 */
- (void)tableModel:(MMResponsesTableModel*)model didSelectResponse:(MultimediaResponse*)response;


/**
 * Occurs when a response has been deleted within the table.
 * @param model the MMResponsesTableModel that sent this event
* @param response the deleted MultimediaResponse object
 */
- (void)tableModel:(MMResponsesTableModel*)model didDeleteResponse:(MultimediaResponse*)response;

/**
 * Occurs when the table is in edit mode, and a response has been selected
 * @param model the MMResponsesTableModel that sent this event
 * @param response the MultimediaResponse that has been selected. Other responses may also be selected in addition to this value.
 */
- (void)tableModel:(MMResponsesTableModel*)model isMultiselectingAndSelected:(MultimediaResponse*)response;

/**
 * Occurs when the table is in edit mode, and a response has been deselected.
 * @param model the MMResponsesTableModel that sent this event
 * @param response the MultimediaResponse that has been deselected.
 */
- (void)tableModel:(MMResponsesTableModel*)model isMultiselectingAndDeselected:(MultimediaResponse*)response;

@end

/// Provides a UITableView with data and delegate behaviour needed ot populate it with a set of responses.
@interface MMResponsesTableModel : NSObject<UITableViewDataSource, UITableViewDelegate>

/// Contains an object conforming to the MMResponsesTableDelegate information protocol that will be notified as the table is interacted with.
@property (strong, nonatomic) id<MMResponsesTableDelegate> responsesDelegate;

/// Contains the set of MultimediaResponse objects to present within the table.
@property (strong, nonatomic) NSArray* responses;

/// Contains the UITableView used to present the data.
@property (strong, nonatomic) UITableView* tableView;

/**
 * Locates and returns the MultimediaResponse object located at a particular path.
 * @param path the NSIndexPath representing the destination of the object to locate.
 * @return the MultimediaResponse object located at the particular index path.
 */
- (MultimediaResponse*)responseAtIndexPath:(NSIndexPath*)path;

/**
 * Resolves the NSIndexPath for a particular MultimediaResponse within the table
 * @param response the MultimediaResponse to resolve the path for
 * @return an NSIndexPath representing the location of the MultimediaResponse within the table.
 */
- (NSIndexPath*)pathForResponse:(MultimediaResponse*)response;

@end
