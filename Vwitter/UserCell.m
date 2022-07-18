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
    
    if ([self.user.objectId isEqualToString:[PFUser currentUser].objectId]) {
        self.followStatusButton.hidden = YES;
    }
    
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

    PFQuery *thisFollow = [Follow query];
    [thisFollow whereKey:@"followingUserId" equalTo:self.user.objectId];
    [thisFollow whereKey:@"currentUserId" equalTo:[PFUser currentUser].objectId];
    
    __weak typeof(self) weakSelf = self;
    [thisFollow findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        typeof(self) strongSelf = weakSelf;
        if (!strongSelf) {
            NSLog(@"I got killed!");
            return;
        }
        if ([objects count] != 0) {
            for (id object in objects) {
                [object deleteInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                    if (succeeded) {
                        NSLog(@"unfollow succeeded");
                        [strongSelf refreshData];
                    }
                    else {
                        NSLog(@"unfollow had an error: %@", error.localizedDescription);
                        [strongSelf refreshData];
                    }
                }];
            }
            
        }
        else {
            Follow *newFollow =  [[Follow alloc] initWithFollowing:strongSelf.user withApproved:YES];
            [newFollow saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                if (succeeded) {
                    NSLog(@"follow worked");
                    [strongSelf refreshData];
                    
                }
                else {
                    NSLog(@"follow had an error: %@", error.localizedDescription);
                    [strongSelf refreshData];
                }
            }];
        }
    }];
        
}


@end
