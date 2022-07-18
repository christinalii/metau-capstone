//
//  Vent.m
//  Vwitter
//
//  Created by Christina Li on 7/12/22.
//

#import "Vent.h"

@implementation Vent

@dynamic author;
@dynamic authorUserId;
@dynamic ventContent;

+ (nonnull NSString *)parseClassName {
    return @"Vent";
}

- (instancetype)initWithVentContent:(NSString *)ventContent {
    if (self = [super init]) {
        self.author = [PFUser currentUser];
        self.authorUserId = self.author.objectId;
        self.ventContent = ventContent;
    }
    return self;
}

@end
