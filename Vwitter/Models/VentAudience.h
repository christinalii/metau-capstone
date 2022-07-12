//
//  VentAudience.h
//  Vwitter
//
//  Created by Christina Li on 7/12/22.
//

#import <Parse/Parse.h>
#import "Vent.h"
#import "GroupDetails.h"

NS_ASSUME_NONNULL_BEGIN

@interface VentAudience : PFObject<PFSubclassing>

@property (strong, nonatomic) Vent *ventId;
@property (strong, nonatomic) PFUser *userId;
@property (strong, nonatomic) GroupDetails *groupId;


@end

NS_ASSUME_NONNULL_END
