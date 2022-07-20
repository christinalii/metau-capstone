//
//  GroupDetails.m
//  Vwitter
//
//  Created by Christina Li on 7/12/22.
//

#import "GroupDetails.h"

@implementation GroupDetails

@dynamic groupName;

+ (nonnull NSString *)parseClassName {
    return @"GroupDetails";
}

- (instancetype)initWithGroupName:(NSString *)groupName {
    if (self = [super init]) {
        self.groupName = groupName;
    }
    return self;
}

@end
