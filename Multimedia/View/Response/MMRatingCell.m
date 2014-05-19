//
//  MMRatingCell.m
//  Multimedia
//
//  Created by Thomas Sherwood on 27/12/2013.
//  Copyright (c) 2013 Thomas Sherwood. All rights reserved.
//

#import "MMRatingCell.h"

@implementation MMRatingCell

- (void)setRating:(NSNumber*)rating
{
	_rating = rating;
	
	NSString* imageName;
	if(_rating)
	{
		self.ratingImageView.hidden = NO;
		self.customDetailTextLabel.hidden = YES;
		int ratingAsInt = [_rating intValue];
		int imgID = ceil(ratingAsInt / 20);
		imageName = [NSString stringWithFormat:@"valenceUnselected%i", imgID];
		[_ratingImageView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@.png", imageName]]];
	}
	else
	{
		self.ratingImageView.hidden = YES;
		self.customDetailTextLabel.hidden = NO;
	}
}

@end
