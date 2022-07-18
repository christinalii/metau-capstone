//
//  Follow.h
//  Vwitter
//
//  Created by Christina Li on 7/11/22.
//

#import <Parse/Parse.h>

NS_ASSUME_NONNULL_BEGIN

@interface Follow : PFObject<PFSubclassing>

@property (strong, nonatomic) PFUser *followingUser;
@property (strong, nonatomic) PFUser *currentUser;
@property (strong, nonatomic) NSString *followingUserId;
@property (strong, nonatomic) NSString *currentUserId;
@property (nonatomic, assign) BOOL approved;

- (instancetype)initWithFollowing:(PFUser *)followingUser withApproved:(BOOL)approved;

@end

NS_ASSUME_NONNULL_END
