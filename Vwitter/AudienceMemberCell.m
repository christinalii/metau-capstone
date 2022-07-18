//
//  AudienceMemberCell.m
//  Vwitter
//
//  Created by Christina Li on 7/12/22.
//

#import "AudienceMemberCell.h"
#import "SelectAudienceViewController.h"

@implementation AudienceMemberCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
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
