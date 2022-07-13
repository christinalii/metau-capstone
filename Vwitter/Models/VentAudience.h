//
//  VentAudience.h
//  Vwitter
//
//  Created by Christina Li on 7/12/22.
//

#import <Parse/Parse.h>
#import "Vent.h"
#import "GroupDetails.h"

@interface VentAudience : PFObject<PFSubclassing>

@property (strong, nonatomic) Vent * _Nonnull ventId;
@property (strong, nonatomic) PFUser * _Nullable userId;
@property (strong, nonatomic) GroupDetails * _Nullable groupId;

+ (void)createAudience: (Vent * _Nonnull)ventId withAudience: (NSMutableArray *_Nullable)audienceArray withCompletion: (PFBooleanResultBlock  _Nullable)completion;


@end

