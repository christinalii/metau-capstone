//
//  UserCell.m
//  Vwitter
//
//  Created by Christina Li on 7/11/22.
//

#import "UserCell.h"
#import "Follow.h"

@implementation UserCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setUser:(PFUser *)user{
    _user = user;

    [self refreshData];

}

- (BOOL)isFollowing {

    PFQuery *thisFollow = [Follow query];
    [thisFollow whereKey:@"followingUserId" equalTo:self.user];
    [thisFollow whereKey:@"currentUserId" equalTo:[PFUser currentUser]];
    [thisFollow whereKey:@"approved" equalTo:@YES];
    
    [thisFollow findObjectsInBackgroundWithBlock:^(NSArray *results, NSError *error) {
        if (error) {
            NSLog(@"there was an error");
            return NO;
        }
        else {
            if (results.count > 0){
                return YES;
            }
            else {
                return NO;
            }
        }
    }];
}

- (void)refreshData {
    
    NSString *at = @"@";
    self.username.text = [NSString stringWithFormat:@"%@%@", at, self.user.username];

    if ([self isFollowing]) {
        [self.followStatusButton setTitle:@"Following" forState:UIControlStateNormal];
    }
    else {
        [self.followStatusButton setTitle:@"Follow" forState:UIControlStateNormal];
    }
//
//    if (self.tweet.retweeted == YES) {
//        [self.retweetButton setImage:[UIImage imageNamed:@"retweet-icon-green.png"] forState:UIControlStateNormal];
//    }
//    else {
//        [self.retweetButton setImage:[UIImage imageNamed:@"retweet-icon.png"] forState:UIControlStateNormal];
//    }
}

- (IBAction)didFollow:(id)sender {
    [Follow makeFollow:self.user withApproved:YES withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded) {
            NSLog(@"follow succeeded!");
        }
        else {
            NSLog(@"follow failed");
            NSLog(@"😫😫😫 Error posting: %@", error.localizedDescription);
        }
    }];
    
    [self refreshData];
}


@end
