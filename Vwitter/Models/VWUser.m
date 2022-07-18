//
//  VWUser.m
//  Vwitter
//
//  Created by Christina Li on 7/8/22.
//

#import "VWUser.h"

@implementation VWUser

@dynamic screenName;

- (instancetype)initWithScreenName:(NSString *)screenName {
    if (self = [super init]) {
        // Initialize self
        self.screenName = screenName;
    }
    return self;
}

@end
