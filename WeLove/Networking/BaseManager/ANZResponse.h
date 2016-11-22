//
//  ANZResponse.h
//  anz
//
//  Created by KevinCao on 16/7/4.
//  Copyright © 2016年 ahqianmo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ANZResponse : NSObject

@property (nonatomic, assign, readonly) NSInteger requestId;
@property (nonatomic, copy, readonly) id responseObject;
@property (nonatomic, copy, readonly) id response;
@property (nonatomic, copy, readonly) NSError *error;

- (instancetype)initWithResponse:(id)response requestId:(NSNumber *)requestId responseObject:(id)responseObject;

- (instancetype)initWithResponse:(id)response requestId:(NSNumber *)requestId error:(NSError *)error;

@end
