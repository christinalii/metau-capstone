//
//  Vent.m
//  Vwitter
//
//  Created by Christina Li on 7/12/22.
//

#import "Vent.h"

@implementation Vent

@dynamic author;
@dynamic ventContent;

+ (nonnull NSString *)parseClassName {
    return @"Vent";
}

+ (void)postVent:( NSString * _Nonnull)ventContent withCompletion: (PFBooleanResultBlock  _Nullable)completion {
    Vent *newVent = [Vent new];
    newVent.author = [PFUser currentUser];
    newVent.ventContent = ventContent;
    
    [newVent saveInBackgroundWithBlock: completion];
    
}

@end
