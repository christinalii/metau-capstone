//
//  GroupMembership.h
//  Vwitter
//
//  Created by Christina Li on 7/12/22.
//

#import <Parse/Parse.h>

#import "GroupDetails.h"

NS_ASSUME_NONNULL_BEGIN

@interface GroupMembership : PFObject<PFSubclassing>

@property (strong, nonatomic) GroupDetails *groupId;
@property (strong, nonatomic) PFUser *userId;

@end

NS_ASSUME_NONNULL_END
