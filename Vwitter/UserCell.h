//
//  UserCell.h
//  Vwitter
//
//  Created by Christina Li on 7/11/22.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

#import "UserCellViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface UserCell : UITableViewCell

@property (strong, nonatomic) PFUser *user;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UIButton *followStatusButton;
@property (strong, nonatomic) UserCellViewModel *userCellViewModel;

@end

NS_ASSUME_NONNULL_END
