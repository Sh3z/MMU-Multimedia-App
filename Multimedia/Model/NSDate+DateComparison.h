//
//  NSDate+DateComparison.h
//  Multimedia
//
//  Created by Thomas Sherwood on 01/01/2014.
//  Copyright (c) 2014 Thomas Sherwood. All rights reserved.
//

#import <Foundation/Foundation.h>

/// Provides additional methods against an NSDate object for use in comparisons.
@interface NSDate (DateComparison)

/**
 * Compares this NSDate within the parameter, returning a comparison value based on date only.
 * @param date the NSDate object to compare
 * @return an NSComparisonResult detailing the comparison.
 */
- (NSComparisonResult)isOnSameDate:(NSDate*)date;

@end
