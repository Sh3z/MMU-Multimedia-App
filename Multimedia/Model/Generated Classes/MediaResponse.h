//
//  MediaResponse.h
//  Multimedia
//
//  Created by Thomas Sherwood on 24/12/2013.
//  Copyright (c) 2013 Thomas Sherwood. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class MultimediaResponse;

@interface MediaResponse : NSManagedObject

@property (nonatomic, retain) NSString * pathToMediaFile;
@property (nonatomic, retain) NSNumber * rating;
@property (nonatomic, retain) NSDate * timeBegan;
@property (nonatomic, retain) NSDate * timeFinished;
@property (nonatomic, retain) MultimediaResponse *parent;

@end
