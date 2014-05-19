//
//  MMResponseTableDataModel.h
//  Multimedia
//
//  Created by Thomas Sherwood on 27/12/2013.
//  Copyright (c) 2013 Thomas Sherwood. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MultimediaResponse, MediaResponse;

/// Represents the model for a table view used to display the information of a response.
@interface MMResponseTableDataModel : NSObject<UITableViewDataSource, UITableViewDelegate>

/// Contains the parent MultimediaResponse for resolving additional information
@property (strong, nonatomic) MultimediaResponse* parentResponse;

/// Contains the MediaResponse used to populat the data
@property (strong, nonatomic) MediaResponse* mediaResponse;

@end
