//
//  AppDelegate.h
//  WeLove
//
//  Created by 宇玄丶 on 2016/11/14.
//  Copyright © 2016年 anqianmo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "ANTTabBarController.h"
#import "ANTNavigationController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) ANTNavigationController *nav;
@property (strong, nonatomic) ANTTabBarController *tabBarController;
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSManagedObjectContext *rootObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (void)saveContextWithWait:(BOOL)needWait;
- (NSURL *)applicationDocumentsDirectory;

@end

