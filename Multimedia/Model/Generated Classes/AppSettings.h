//
//  AppSettings.h
//  Multimedia
//
//  Created by Thomas Sherwood on 04/01/2014.
//  Copyright (c) 2014 Thomas Sherwood. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class MultimediaApp;

@interface AppSettings : NSManagedObject

@property (nonatomic, retain) NSNumber * autoSaveToCameraRoll;
@property (nonatomic, retain) NSNumber * passcodeEnabled;
@property (nonatomic, retain) NSString * passcodeAsString;
@property (nonatomic, retain) MultimediaApp *app;

@end
