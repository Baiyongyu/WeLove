//
//  NSManagedObjectContext+GenerateContext.m
//  WeShare2.0
//
//  Created by koki on 15/11/16.
//  Copyright © 2015年 WeShare. All rights reserved.
//

#import "NSManagedObjectContext+GenerateContext.h"

@implementation NSManagedObjectContext (GenerateContext)

+(NSManagedObjectContext *)generatePrivateContextWithParent:(NSManagedObjectContext *)parentContext
{
       NSManagedObjectContext *privateContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
       privateContext.parentContext = parentContext;
       return privateContext;
}

+(NSManagedObjectContext *)generateStraightPrivateContextWithParent:(NSManagedObjectContext *)mainContext {
      NSManagedObjectContext *privateContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
      privateContext.persistentStoreCoordinator = mainContext.persistentStoreCoordinator;
      return privateContext;
}

@end
