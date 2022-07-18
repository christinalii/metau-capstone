//
//  Vent.h
//  Vwitter
//
//  Created by Christina Li on 7/12/22.
//

#import <Parse/Parse.h>

NS_ASSUME_NONNULL_BEGIN

@interface Vent : PFObject<PFSubclassing>

@property (nonatomic, strong) PFUser *author;
@property (nonatomic, strong) NSString *authorUserId;
@property (nonatomic, strong) NSString *ventContent;

- (instancetype)initWithVentContent:(NSString *)ventContent;

@end

NS_ASSUME_NONNULL_END
