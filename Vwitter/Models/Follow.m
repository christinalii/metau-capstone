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

+ (void)makeFollow: (PFUser * _Nonnull)followingUserId withApproved: (BOOL)approved withCompletion: (PFBooleanResultBlock  _Nullable)completion {
    
    Follow *newFollow = [Follow new];
    newFollow.followingUserId = followingUserId;
    newFollow.currentUserId = [PFUser currentUser];
    newFollow.approved = approved;
    
    [newFollow saveInBackgroundWithBlock: completion];
    
}



@end

