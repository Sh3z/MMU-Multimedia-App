//
//  MMRatingCell.h
//  Multimedia
//
//  Created by Thomas Sherwood on 27/12/2013.
//  Copyright (c) 2013 Thomas Sherwood. All rights reserved.
//

#import <UIKit/UIKit.h>

/// Represents the cell of a UITableView used to display the rating of a Media
@interface MMRatingCell : UITableViewCell

/// Contains the UIImageView to present the SAM rating within
@property (weak, nonatomic) IBOutlet UIImageView *ratingImageView;

/// Contains the UILabel used to provide additional text when no rating has been provided.
@property (weak, nonatomic) IBOutlet UILabel *customDetailTextLabel;

/// Contains the rating provided by the MediaResponse.
@property (nonatomic) NSNumber* rating;

@end
