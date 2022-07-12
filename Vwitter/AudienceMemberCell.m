//
//  AudienceMemberCell.m
//  Vwitter
//
//  Created by Christina Li on 7/12/22.
//

#import "AudienceMemberCell.h"

@implementation AudienceMemberCell

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
    NSLog(@"%@", self.user);
    self.username.text = [NSString stringWithFormat:@"%@%@", at, self.user.username];

}

@end
