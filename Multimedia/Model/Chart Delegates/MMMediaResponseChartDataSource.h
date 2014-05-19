//
//  MMMediaResponseChartDataSource.h
//  Multimedia
//
//  Created by Thomas Sherwood on 04/01/2014.
//  Copyright (c) 2014 Thomas Sherwood. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XYPieChart.h"

@class MediaResponse;

/// Provides an XYPieChart with the information to visualise the response ratings for a media given by a MediaSource.
@interface MMMediaResponseChartDataSource : NSObject<XYPieChartDataSource>

/// Contains the MediaResponse the chart is providing data for.
@property (strong, nonatomic, readonly) MediaResponse* response;

/**
 * Constructs and returns a new MMMediaResponseChartDataSource providing the data for the MediaResponse
 * @param response the MediaResponse to present within an XYPieChart
 * @return a new instance of the MMMediaResponseChartDataSource configured to present the response.
 */
+ (instancetype)createWithResponse:(MediaResponse*)response;

/**
 * Constructs and returns a new MMMediaResponseChartDataSource providing the data for the MediaResponse
 * @param response the MediaResponse to present within an XYPieChart
 * @return a new instance of the MMMediaResponseChartDataSource configured to present the response.
 */
- (id)initWithResponse:(MediaResponse*)response;

/// Executes the processing procedure for displaying the information.
- (void)calculateInformation;

@end
