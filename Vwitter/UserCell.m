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

- (void)refreshData {

    NSString *at = @"@";
    self.username.text = [NSString stringWithFormat:@"%@%@", at, self.user.username];
    
    [PFCloud callFunctionInBackground:@"existsFollow"
                       withParameters:@{@"currentUserObjectId":[PFUser currentUser].objectId, @"followingUserObjectId":self.user.objectId}
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
