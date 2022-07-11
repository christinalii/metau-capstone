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
@property (nonatomic, assign) BOOL approved;

+ (void)makeFollow: (PFUser * _Nonnull)followingUserId withApproved: (BOOL)approved withCompletion: (PFBooleanResultBlock  _Nullable)completion;

@end

NS_ASSUME_NONNULL_END
