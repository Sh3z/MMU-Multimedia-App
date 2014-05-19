//
//  NSDate+DateComparison.m
//  Multimedia
//
//  Created by Thomas Sherwood on 01/01/2014.
//  Copyright (c) 2014 Thomas Sherwood. All rights reserved.
//

#import "NSDate+DateComparison.h"

@implementation NSDate (DateComparison)

- (NSComparisonResult)isOnSameDate:(NSDate*)date
{
	NSUInteger dateFlags = NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit;
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *selfComponents = [gregorianCalendar components:dateFlags fromDate:self];
    NSDate *selfDateOnly = [gregorianCalendar dateFromComponents:selfComponents];
	
    NSDateComponents *otherCompents = [gregorianCalendar components:dateFlags fromDate:date];
    NSDate *otherDateOnly = [gregorianCalendar dateFromComponents:otherCompents];
    return [selfDateOnly compare:otherDateOnly];
}

@end
