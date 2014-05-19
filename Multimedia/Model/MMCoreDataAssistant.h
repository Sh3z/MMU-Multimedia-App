//
//  MMCoreDataAssistant.h
//  Multimedia
//
//  Created by Thomas Sherwood on 22/12/2013.
//  Copyright (c) 2013 Thomas Sherwood. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class MultimediaApp, MultimediaResponse, AppSettings;

/// Represents an assistant used to simplify the usage of Core Data within the app.
@interface MMCoreDataAssistant : NSObject

/// Returns the managed object context for the application.
+ (NSManagedObjectContext*) managedObjectContext;

/// Returns the managed object model for the application.
+ (NSManagedObjectModel*) managedObjectModel;

/// Returns the persistent store coordinator for the application.
+ (NSPersistentStoreCoordinator*) persistentStoreCoordinator;

/// Returns the URL to the application's Documents directory.
+ (NSURL*) applicationDocumentsDirectory;

/// Saves any changes to the Core Data context.
+ (void)saveContext;

/**
 * Creates, inserts into the store and returns an NSManagedObject representing
 * the entity with the provided identifier.
 * @param entityName the name of the entity within the schema.
 * @return the NSManagedObject subclass represented by the identifier of the
 * entity.
 */
+ (NSManagedObject*)createEntityWithIdentifier:(NSString*)entityName;

/// Gets the root of the object graph for the application.
+ (MultimediaApp*)applicationStore;

/// Gets the application settings object.
+ (AppSettings*)settings;

/**
 * Deletes a MultimediaResponse from the application
 * @param response the MultimediaResponse to delete
 */
+ (void)deleteResponse:(MultimediaResponse*)response;

@end
