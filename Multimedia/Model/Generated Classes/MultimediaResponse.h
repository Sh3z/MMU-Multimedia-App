//
//  MultimediaResponse.h
//  Multimedia
//
//  Created by Thomas Sherwood on 24/12/2013.
//  Copyright (c) 2013 Thomas Sherwood. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import <MapKit/MapKit.h>

@class MediaResponse, MultimediaApp;

@interface MultimediaResponse : NSManagedObject<MKAnnotation>

@property (nonatomic, retain) NSDate * timeBegan;
@property (nonatomic, retain) NSDate * timeFinished;
@property (nonatomic, retain) id location;
@property (nonatomic, retain) NSString * recordingFileIdentifier;
@property (nonatomic, retain) NSNumber * mediaType;
@property (nonatomic, retain) NSOrderedSet *media;
@property (nonatomic, retain) MultimediaApp *app;
@end

@interface MultimediaResponse (CoreDataGeneratedAccessors)

- (void)insertObject:(MediaResponse *)value inMediaAtIndex:(NSUInteger)idx;
- (void)removeObjectFromMediaAtIndex:(NSUInteger)idx;
- (void)insertMedia:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeMediaAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInMediaAtIndex:(NSUInteger)idx withObject:(MediaResponse *)value;
- (void)replaceMediaAtIndexes:(NSIndexSet *)indexes withMedia:(NSArray *)values;
- (void)addMediaObject:(MediaResponse *)value;
- (void)removeMediaObject:(MediaResponse *)value;
- (void)addMedia:(NSOrderedSet *)values;
- (void)removeMedia:(NSOrderedSet *)values;
@end
