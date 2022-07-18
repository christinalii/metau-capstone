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

@property (strong, nonatomic) Vent * _Nonnull vent;
@property (strong, nonatomic) PFUser * _Nullable user;
@property (strong, nonatomic) GroupDetails * _Nullable group;

- (instancetype)initWithUserAudience:(PFUser *)user withVent:(Vent *)vent;

- (instancetype)initWithGroupAudience:(GroupDetails *)group withVent:(Vent *)vent;


@end

