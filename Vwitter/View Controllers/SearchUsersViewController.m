//
//  SearchUsersViewController.m
//  Vwitter
//
//  Created by Christina Li on 7/8/22.
//

#import <Parse/Parse.h>

#import "SearchUsersViewController.h"
#import "UserCell.h"
#import "VWUser.h"
#import "UserCellViewModel.h"

@interface SearchUsersViewController () <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSMutableArray<VWUser *> *arrayOfUsers;
@property (strong, nonatomic) NSArray<VWUser *> *filteredSearchResults;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) NSMutableArray<UserCellViewModel *> *arrayOfUserCellViewModels;

@end

@implementation SearchUsersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.arrayOfUserCellViewModels = [[NSMutableArray alloc] init];
    [self loadData];
    
    self.searchBar.delegate = self;
    self.filteredSearchResults = self.arrayOfUsers;
    
}

- (void)loadData {
    PFQuery *userQuery = [PFUser query];
    userQuery.limit = 20;
    __weak typeof(self) weakSelf = self;
    [userQuery findObjectsInBackgroundWithBlock:^(NSArray<PFUser *> * _Nullable users, NSError * _Nullable error) {
        typeof(self) strongSelf = weakSelf;
        if (!strongSelf) {
            NSLog(@"I got killed!");
            return;
        }
        if (users) {
            NSLog(@"😎😎😎 Successfully loaded search users timeline");
            strongSelf.arrayOfUsers = users.mutableCopy;
            strongSelf.filteredSearchResults = strongSelf.arrayOfUsers;
            [strongSelf.tableView reloadData];
            
        }
        else {
            NSLog(@"😫😫😫 Error getting home timeline: %@", error.localizedDescription);
        }
    }];
//    call PFCloud function with paramters limit, currentUser
    [PFCloud callFunctionInBackground:@"fetchUserCellData"
                       withParameters:@{@"limit":@20, @"currentUserID":[VWUser currentUser].objectId}
                                block:^(id results, NSError *error) {
      if (!error) {
          NSLog(@"%@", results);
          for (NSDictionary *object in results) {
              VWUser *currentUser = object[@"user"];
              UserCellViewModel *newUCVW = [[UserCellViewModel alloc] initWithUser:currentUser withUserId:currentUser.objectId withUsername:currentUser.username withIsFollowing:object[@"isFollowing"]];
              [self.arrayOfUserCellViewModels addObject:newUCVW];
          }
          
          
          
          [self.tableView reloadData];
          
      }
      else {
          NSLog(@"there was an error, u suck");
      }
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.arrayOfUserCellViewModels.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UserCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UserCell" forIndexPath:indexPath];

//    cell.user = self.filteredSearchResults[indexPath.row];
    cell.userCellViewModel = self.arrayOfUserCellViewModels[indexPath.row];

    return cell;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    
    if (searchText.length != 0) {
        
        NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(PFUser *evaluatedObject, NSDictionary *bindings) {
            return [evaluatedObject.username containsString:searchText];
        }];
        self.filteredSearchResults = [self.arrayOfUsers filteredArrayUsingPredicate:predicate];
        
        NSLog(@"%@", self.filteredSearchResults);
        
    }
    else {
        self.filteredSearchResults = self.arrayOfUsers;
    }
    
    [self.tableView reloadData];
 
}

@end
