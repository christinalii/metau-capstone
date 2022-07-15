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

//- (NSArray<PFUser *> *)listFollowing {
//
//    PFQuery *thisFollow = [Follow query];
////    [thisFollow whereKey:@"followingUserId" equalTo:self.user];
//    [thisFollow whereKey:@"currentUserId" equalTo:[PFUser currentUser]];
//    [thisFollow whereKey:@"approved" equalTo:@YES];
//
//    [thisFollow findObjectsInBackgroundWithBlock:^(NSArray<PFUser *> *results, NSError *error) {
//        if (error) {
//            NSLog(@"there was an error");
//            return [NSArray<PFUser *> new];
//        }
//        else {
//            return results;
//        }
//    }];
//}

- (void)refreshData {

    NSString *at = @"@";
    self.username.text = [NSString stringWithFormat:@"%@%@", at, self.user.username];
    
    [PFCloud callFunctionInBackground:@"existsFollow"
                       withParameters:@{@"currentUserId":[PFUser currentUser].objectId, @"followingUserId":self.user.objectId}
                                block:^(id exists, NSError *error) {
      if (!error) {
          NSLog (@"%d", ((NSNumber *)exists).boolValue);
          if (((NSNumber *)exists).boolValue) {
              [self.followStatusButton setTitle:@"Following" forState:UIControlStateNormal];
          }
          else {
              [self.followStatusButton setTitle:@"Follow" forState:UIControlStateNormal];
          }
      }
    }];
}

- (IBAction)didFollow:(id)sender {
    Follow *newFollow =  [[Follow alloc] initWithFollowing:self.user withApproved:YES];
    [newFollow saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded) {
            NSLog(@"follow worked");
            
        }
        else {NSLog(@"follow had an error: %@", error.localizedDescription);
        }
    }];
    
    [self refreshData];
}


@end
