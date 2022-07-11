//
//  SignupViewController.m
//  Vwitter
//
//  Created by Christina Li on 7/8/22.
//

#import "SignupViewController.h"
#import "VWUser.h"
#import "UIViewController+ErrorAlertPresenter.h"

@interface SignupViewController ()
@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *screennameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;

@end

@implementation SignupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)registerUser {

    VWUser *newUser = [VWUser user];

    newUser.username = self.usernameField.text;
    newUser.password = self.passwordField.text;
    newUser.screenName = self.screennameField.text;

    [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError * error) {
        if (error != nil) {
            NSLog(@"Error: %@", error.localizedDescription);
            [self presentErrorMessageWithTitle:@"Error" message:error.localizedDescription];
            
        } else {
            NSLog(@"User registered successfully");
            [self performSegueWithIdentifier:@"signupSegue" sender:nil];
        }
    }];
}

- (IBAction)didTapSignup:(id)sender {
    [self registerUser];
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
