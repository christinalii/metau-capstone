//
//  Follow.m
//  Vwitter
//
//  Created by Christina Li on 7/11/22.
//

#import "Follow.h"

@implementation Follow

@dynamic followingUserId;
@dynamic currentUserId;
@dynamic approved;

+ (nonnull NSString *)parseClassName {
    return @"Follow";
}

- (instancetype)initWithFollowing:(PFUser *)followingUserId withApproved:(BOOL)approved {
    if (self = [super init]) {
        // Initialize self
        self.currentUserId = [PFUser currentUser];
        self.followingUserId = followingUserId;
        self.approved = approved;
    }
    return self;
}

@end

