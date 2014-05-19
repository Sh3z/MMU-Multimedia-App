//
//  MultimediaApp.h
//  Multimedia
//
//  Created by Thomas Sherwood on 04/01/2014.
//  Copyright (c) 2014 Thomas Sherwood. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class AppSettings, MultimediaResponse;

@interface MultimediaApp : NSManagedObject

@property (nonatomic, retain) NSSet *responses;
@property (nonatomic, retain) AppSettings *settings;
@end

@interface MultimediaApp (CoreDataGeneratedAccessors)

- (void)addResponsesObject:(MultimediaResponse *)value;
- (void)removeResponsesObject:(MultimediaResponse *)value;
- (void)addResponses:(NSSet *)values;
- (void)removeResponses:(NSSet *)values;

@end
