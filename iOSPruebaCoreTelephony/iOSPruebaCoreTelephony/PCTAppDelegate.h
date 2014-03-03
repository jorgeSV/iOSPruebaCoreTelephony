//
//  PCTAppDelegate.h
//  iOSPruebaCoreTelephony
//
//  Created by jorgeSV on 03/03/14.
//  Copyright (c) 2014 menus.es. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PCTAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
