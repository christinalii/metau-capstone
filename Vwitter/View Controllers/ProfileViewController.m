//
//  ProfileViewController.m
//  Vwitter
//
//  Created by Christina Li on 7/8/22.
//

#import "ProfileViewController.h"
#import <Parse/Parse.h>

@interface ProfileViewController ()
@property (weak, nonatomic) IBOutlet UILabel *username;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.username.text = [PFUser currentUser].username;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
