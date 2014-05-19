//
//  MMResponseToCSV.m
//  Multimedia
//
//  Created by Thomas Sherwood on 30/12/2013.
//  Copyright (c) 2013 Thomas Sherwood. All rights reserved.
//

#import "MMResponseToCSV.h"
#import "MultimediaResponse.h"
#import "MediaResponse.h"

@implementation MMResponseToCSV

+ (NSString*)csvHeader
{
	return @"Path To Media File,Rating,View Duration\n";
}

+ (NSData*)createCSVDataForComplexAggregation:(NSArray*)responses
{
	NSString* allInfo = @"";
	for(MultimediaResponse* response in responses)
	{
		allInfo = [allInfo stringByAppendingString:[NSString stringWithFormat:@"%@\n", [MMResponseToCSV responsesAsCSVLines:[[response media] array]]]];
	}
	
	return [MMResponseToCSV dataFromString:[NSString stringWithFormat:@"%@\n%@", [MMResponseToCSV csvHeader], allInfo]];
}

+ (NSData*)createCSVDataForAggregation:(MultimediaResponse*)response;
{
	NSString* responsesAsString = [MMResponseToCSV responsesAsCSVLines:[[response media] array]];
	return [MMResponseToCSV dataFromString:[NSString stringWithFormat:@"%@\n%@", [MMResponseToCSV csvHeader], responsesAsString]];
}

+ (NSData*)createCSVDataForResponse:(MediaResponse*)response
{
	return [MMResponseToCSV dataFromString:[MMResponseToCSV responseAsCSVLine:response]];
}

/**
 * Converts the MediaResponse into CSV as a single line
 * @param the NSString containing the CSV data
 */
+ (NSString*)responseAsCSVLine:(MediaResponse*)response
{
	return [NSString stringWithFormat:@"%@,%@,%d", response.pathToMediaFile, response.rating, (int)[[response timeFinished] timeIntervalSinceDate:[response timeBegan]]];
}

/**
 * Converts multiple responses into CSV as multiple lines
 * @param responses the set of MediaResponses
 * @return the multiline CSV
 */
+ (NSString*)responsesAsCSVLines:(NSArray*)responses
{
	NSString* data = @"";
	for(MediaResponse* media in responses)
	{
		data = [data stringByAppendingString:[NSString stringWithFormat:@"%@\n", [MMResponseToCSV responseAsCSVLine:media]]];
	}

	return data;
}

/**
 * Converts an NSString into NSDate
 * @param string the string to convert
 * @return the NSData used by other methods
 */
+ (NSData*)dataFromString:(NSString*)string
{
	return [string dataUsingEncoding:NSUTF8StringEncoding];
}

@end
