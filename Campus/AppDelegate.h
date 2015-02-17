//
//  AppDelegate.h
//  Campus
//
//  Created by Tengyu Cai on 2014-06-14.
//  Copyright (c) 2014 Tengyu Cai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

-(void)transitionFromSplash;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
