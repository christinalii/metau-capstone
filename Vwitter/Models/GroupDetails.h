//
//  GroupDetails.h
//  Vwitter
//
//  Created by Christina Li on 7/12/22.
//

#import <Parse/Parse.h>

NS_ASSUME_NONNULL_BEGIN

@interface GroupDetails : PFObject<PFSubclassing>

@property (strong, nonatomic) NSString *groupName;

@end

NS_ASSUME_NONNULL_END
