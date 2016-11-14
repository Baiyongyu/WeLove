//
//  NSManagedObjectContext+GenerateContext.h
//  WeShare2.0
//
//  Created by koki on 15/11/16.
//  Copyright © 2015年 WeShare. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface NSManagedObjectContext (GenerateContext)
+(NSManagedObjectContext *)generatePrivateContextWithParent:(NSManagedObjectContext *)parentContext;
+(NSManagedObjectContext *)generateStraightPrivateContextWithParent:(NSManagedObjectContext *)mainContext;
@end
