//
//  MMCoreDataAssistant.m
//  Multimedia
//
//  Created by Thomas Sherwood on 22/12/2013.
//  Copyright (c) 2013 Thomas Sherwood. All rights reserved.
//

#import "MMCoreDataAssistant.h"
#import "MultimediaApp.h"

@interface MMCoreDataAssistant ()

/// Returns the managed object context for the application.
@property (strong, nonatomic) NSManagedObjectContext *context;

/// Returns the managed object model for the application.
@property (strong, nonatomic) NSManagedObjectModel *model;

/// Returns the persistent store coordinator for the application.
@property (strong, nonatomic) NSPersistentStoreCoordinator *coordinator;

@end

@implementation MMCoreDataAssistant

static MMCoreDataAssistant* _instance;

+ (void)initialize
{
	_instance = [[MMCoreDataAssistant alloc] init];
}

+ (NSManagedObjectContext*) managedObjectContext
{
	if ([_instance context] == nil)
	{
        NSPersistentStoreCoordinator *coordinator = [MMCoreDataAssistant persistentStoreCoordinator];
		if (coordinator != nil)
		{
			[_instance setContext:[[NSManagedObjectContext alloc] init]];
			[[_instance context] setPersistentStoreCoordinator:coordinator];
		}
    }
	
    return [_instance context];
}

+ (NSManagedObjectModel*) managedObjectModel;
{
	if ([_instance model] == nil)
	{
        NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Multimedia" withExtension:@"momd"];
		[_instance setModel:[[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL]];
    }
	
    return [_instance model];
}

+ (NSPersistentStoreCoordinator*) persistentStoreCoordinator
{
	if([_instance coordinator] == nil)
	{
        NSURL *storeURL = [[MMCoreDataAssistant applicationDocumentsDirectory] URLByAppendingPathComponent:@"Multimedia.xcdatamodeld"];
		
		NSError *error = nil;
		[_instance setCoordinator: [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[MMCoreDataAssistant managedObjectModel]]];
		if (![[_instance coordinator] addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error])
		{
			NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
			abort();
		}
    }
    
    return [_instance coordinator];
}

+ (NSURL*) applicationDocumentsDirectory
{
	return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

+ (void)saveContext
{
	NSError *error = nil;
    if([MMCoreDataAssistant managedObjectContext])
	{
        if([[MMCoreDataAssistant managedObjectContext] hasChanges] && ![[MMCoreDataAssistant managedObjectContext] save:&error])
		{
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

+ (NSManagedObject*)createEntityWithIdentifier:(NSString*)entityName
{
	return [NSEntityDescription insertNewObjectForEntityForName:entityName inManagedObjectContext:[MMCoreDataAssistant managedObjectContext]];
}

+ (MultimediaApp*)applicationStore;
{
	NSArray* objects = [MMCoreDataAssistant fetchEntityWithName:@"MultimediaApp"];
	if(!objects)
	{
		return nil;
	}
	
	MultimediaApp* app;
	if([objects count] == 0)
	{
		// This is the first time the app has been run. We should create and store a new instance.
		app = (MultimediaApp*)[MMCoreDataAssistant createEntityWithIdentifier:@"MultimediaApp"];
		id settings = (AppSettings*)[MMCoreDataAssistant createEntityWithIdentifier:@"AppSettings"];
		[app setSettings:settings];
		[MMCoreDataAssistant saveContext];
	}
	else
	{
		app = [objects firstObject];
	}
	
	return app;
}

+ (AppSettings*)settings
{
	return [[MMCoreDataAssistant applicationStore] settings];
}

+ (void)deleteResponse:(MultimediaResponse *)response
{
	[[MMCoreDataAssistant applicationStore] removeResponsesObject:response];
	[[MMCoreDataAssistant managedObjectContext] deleteObject:response];
	[MMCoreDataAssistant saveContext];
}

/**
 * Performs a fetch request for an entity with the given name. This traps and
 * logs any errors
 * @param entityName the name of the entity to perform a fetch request for
 * @return an NSArray of objects returned from the fetch request, or nil if an
 * error occurs.
 */
+ (NSArray*)fetchEntityWithName:(NSString*)entityName
{
	NSError* error;
	NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:entityName];
	NSArray *objects = [[self managedObjectContext] executeFetchRequest:request error:&error];
    if(objects == nil)
	{
        NSLog(@"Error loading Settings instance: %@", error.description);
        return nil;
    }
	else
	{
		return objects;
	}
}

@end
