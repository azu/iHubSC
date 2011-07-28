//
//  iGithubAppDelegate.h
//  iGithub
//
//  Created by Oliver Letterer on 29.03.11.
//  Copyright 2011 Home. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

#warning better organization support
#warning search background does not match new style
#warning manage multiple user accounts
#warning take a look at "started following"

@interface iGithubAppDelegate : NSObject <UIApplicationDelegate> {
    NSManagedObjectContext *_managedObjectContext;
    NSManagedObjectModel *_managedObjectModel;
    NSPersistentStoreCoordinator *_persistentStoreCoordinator;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (nonatomic, readonly) NSMutableDictionary *serializedStateDictionary;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

- (void)setupAppearences;

- (void)nowSerializeState;
- (BOOL)serializeStateInDictionary:(NSMutableDictionary *)dictionary;
- (NSMutableDictionary *)deserializeState;

@end
