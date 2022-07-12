//
//  AudienceMemberCell.h
//  Vwitter
//
//  Created by Christina Li on 7/12/22.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

NS_ASSUME_NONNULL_BEGIN

@interface AudienceMemberCell : UITableViewCell

@property (strong, nonatomic) PFUser *user;
@property (weak, nonatomic) IBOutlet UILabel *username;

@end

NS_ASSUME_NONNULL_END
