//
//  GroupMembership.m
//  Vwitter
//
//  Created by Christina Li on 7/12/22.
//

#import "GroupMembership.h"

@implementation GroupMembership

@dynamic groupId;
@dynamic userId;

+ (nonnull NSString *)parseClassName {
    return @"GroupMembership";
}

@end
