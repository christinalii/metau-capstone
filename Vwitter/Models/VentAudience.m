//
//  VentAudience.m
//  Vwitter
//
//  Created by Christina Li on 7/12/22.
//

#import "VentAudience.h"

@implementation VentAudience

@dynamic ventId;
@dynamic userId;
@dynamic groupId;

+ (nonnull NSString *)parseClassName {
    return @"VentAudience";
}

- (instancetype)initWithVentId:(Vent *)ventId withAudience:(NSObject *)audience {
    VentAudience *newVA = [VentAudience new];
    newVA.ventId = ventId;
    if ([audience isKindOfClass:[PFUser class]]) {
        newVA.groupId = nil;
        newVA.userId = audience;
    }
    else if ([audience isKindOfClass:[GroupDetails class]]) {
        newVA.groupId = audience;
        newVA.userId = nil;
    }
    return newVA;
}

@end
