//
//  VWUser.h
//  Vwitter
//
//  Created by Christina Li on 7/8/22.
//

#import <Parse/Parse.h>

NS_ASSUME_NONNULL_BEGIN

@interface VWUser : PFUser

@property (strong, nonatomic) NSString *screenName;

- (instancetype)initWithScreenName:(NSString *)screenName;

@end

NS_ASSUME_NONNULL_END
