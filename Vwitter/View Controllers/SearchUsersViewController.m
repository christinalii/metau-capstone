//
//  SearchUsersViewController.m
//  Vwitter
//
//  Created by Christina Li on 7/8/22.
//

#import "SearchUsersViewController.h"
#import "UserCell.h"
#import <Parse/Parse.h>

@interface SearchUsersViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSMutableArray *arrayOfUsers;

@end

@implementation SearchUsersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self loadData];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
}

- (void)loadData {
    PFQuery *userQuery = [PFUser query];
    userQuery.limit = 20;
    
//    [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    [userQuery findObjectsInBackgroundWithBlock:^(NSArray<PFUser *> * _Nullable users, NSError * _Nullable error) {
        if (users) {
            NSLog(@"😎😎😎 Successfully loaded search users timeline");
            self.arrayOfUsers = users.mutableCopy;
//            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [self.tableView reloadData];
            
        }
        else {
            // handle error
            NSLog(@"😫😫😫 Error getting home timeline: %@", error.localizedDescription);
        }
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.arrayOfUsers.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UserCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UserCell" forIndexPath:indexPath];

    cell.user = self.arrayOfUsers[indexPath.row];

    return cell;
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
