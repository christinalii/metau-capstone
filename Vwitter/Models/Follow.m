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
@dynamic followingUserObjectId;
@dynamic currentUserObjectId;

+ (nonnull NSString *)parseClassName {
    return @"Follow";
}

- (instancetype)initWithFollowing:(PFUser *)followingUserId withApproved:(BOOL)approved {
    if (self = [super init]) {
        // Initialize self
        self.currentUserId = [PFUser currentUser];
        self.currentUserObjectId = self.currentUserId.objectId;
        self.followingUserId = followingUserId;
        self.followingUserObjectId = self.followingUserId.objectId;
        self.approved = approved;
        
    }
    return self;
}

@end

