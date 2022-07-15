//
//  Follow.h
//  Vwitter
//
//  Created by Christina Li on 7/11/22.
//

#import <Parse/Parse.h>

NS_ASSUME_NONNULL_BEGIN

@interface Follow : PFObject<PFSubclassing>

@property (strong, nonatomic) PFUser *followingUserId;
@property (strong, nonatomic) PFUser *currentUserId;
@property (strong, nonatomic) NSString *followingUserObjectId;
@property (strong, nonatomic) NSString *currentUserObjectId;
@property (nonatomic, assign) BOOL approved;

- (instancetype)initWithFollowing:(PFUser *)followingUserId withApproved:(BOOL)approved;

@end

NS_ASSUME_NONNULL_END
