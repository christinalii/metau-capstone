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

@property (strong, nonatomic) GroupDetails *group;
@property (strong, nonatomic) PFUser *user;

@end

NS_ASSUME_NONNULL_END
