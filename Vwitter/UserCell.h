//
//  UserCell.h
//  Vwitter
//
//  Created by Christina Li on 7/11/22.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

NS_ASSUME_NONNULL_BEGIN

@interface UserCell : UITableViewCell
@property (strong, nonatomic) PFUser *user;
@property (weak, nonatomic) IBOutlet UILabel *username;
@property (weak, nonatomic) IBOutlet UIButton *followStatusButton;

@end

NS_ASSUME_NONNULL_END
