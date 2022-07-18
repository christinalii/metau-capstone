//
//  VentAudience.m
//  Vwitter
//
//  Created by Christina Li on 7/12/22.
//

#import "VentAudience.h"

@implementation VentAudience

@dynamic vent;
@dynamic user;
@dynamic group;

+ (nonnull NSString *)parseClassName {
    return @"VentAudience";
}

- (instancetype)initWithUserAudience:(PFUser *)user withVent:(Vent *)vent {
    VentAudience *newVA = [VentAudience new];
    newVA.vent = vent;
    newVA.group = nil;
    newVA.user = user;
    
    return newVA;
}

- (instancetype)initWithGroupAudience:(GroupDetails *)group withVent:(Vent *)vent {
    VentAudience *newVA = [VentAudience new];
    newVA.vent = vent;
    newVA.group = group;
    newVA.user = nil;
    
    return newVA;
}

//VentAudience *newVA = [VentAudience new];
//newVA.vent = vent;
//if ([audience isKindOfClass:[PFUser class]]) {
//    newVA.group = nil;
//    newVA.user = audience;
//}
//else if ([audience isKindOfClass:[GroupDetails class]]) {
//    newVA.group = audience;
//    newVA.user = nil;
//}
//return newVA;

@end
