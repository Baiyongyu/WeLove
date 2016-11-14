//
//  ANZResponse.m
//  anz
//
//  Created by KevinCao on 16/7/4.
//  Copyright © 2016年 ahqianmo. All rights reserved.
//

#import "ANZResponse.h"
@interface ANZResponse ()
@property (nonatomic, assign, readwrite) NSInteger requestId;
@property (nonatomic, copy, readwrite) id responseObject;
@property (nonatomic, copy, readwrite) id response;
@property (nonatomic, copy, readwrite) NSError *error;
@end

@implementation ANZResponse

- (instancetype)initWithResponse:(id)response requestId:(NSNumber *)requestId responseObject:(id)responseObject
{
    self = [super init];
    if (self) {
        self.response = response;
        self.requestId = [requestId integerValue];
        self.responseObject = responseObject;
    }
    return self;
}

- (instancetype)initWithResponse:(id)response requestId:(NSNumber *)requestId error:(NSError *)error
{
    self = [super init];
    if (self) {
        self.response = response;
        self.requestId = [requestId integerValue];
        self.error = error;
    }
    return self;
}

@end
