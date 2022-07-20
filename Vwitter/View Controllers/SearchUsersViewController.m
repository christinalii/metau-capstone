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
#import "Follow.h"

@interface SearchUsersViewController () <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UserCellDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSMutableArray<VWUser *> *arrayOfUsers;
@property (strong, nonatomic) NSArray<VWUser *> *filteredSearchResults;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) NSMutableArray<UserCellViewModel *> *arrayOfUserCellViewModels;
@property (nonatomic, readwrite) int requestCount;

@end

@implementation SearchUsersViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.arrayOfUserCellViewModels = [[NSMutableArray alloc] init];
    [self loadData];
    
    self.searchBar.delegate = self;
    self.filteredSearchResults = self.arrayOfUsers;
    
}

- (void)loadData {
    __weak typeof(self) weakSelf = self;
    [PFCloud callFunctionInBackground:@"fetchUserCellData"
                       withParameters:@{@"limit":@20, @"currentUserID":[VWUser currentUser].objectId, @"searchString":@""}
                                block:^(id results, NSError *error) {
        typeof(self) strongSelf = weakSelf;
        if (!strongSelf) {
            NSLog(@"I got killed!");
            return;
        }
        if (!error) {
          NSLog(@"%@", results);
          for (NSDictionary *object in results) {
              VWUser *currentUser = object[@"user"];
              UserCellViewModel *newUCVW = [[UserCellViewModel alloc] initWithUser:currentUser withUserId:currentUser.objectId withUsername:currentUser.username withIsFollowing:object[@"isFollowing"]];
              [strongSelf.arrayOfUserCellViewModels addObject:newUCVW];
          }
        
          [strongSelf.tableView reloadData];
          
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
    cell.userCellViewModel = self.arrayOfUserCellViewModels[indexPath.row];
    cell.delegate = self;

    return cell;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    const int currentRequestCount = self.requestCount++;
    
    __weak typeof(self) weakSelf = self;
    [PFCloud callFunctionInBackground:@"fetchUserCellData"
                       withParameters:@{@"limit":@20, @"currentUserID":[VWUser currentUser].objectId, @"searchString":searchText}
                                block:^(id results, NSError *error) {
        typeof(self) strongSelf = weakSelf;
        if (!strongSelf) {
            NSLog(@"I got killed!");
            return;
        }
        if (strongSelf.requestCount > currentRequestCount + 1) {
            NSLog(@"Cancelled search because a new search is already in progress");
            return;
        }
        if (!error) {
          NSLog(@"%@", results);
            [strongSelf.arrayOfUserCellViewModels removeAllObjects];
          for (NSDictionary *object in results) {
              VWUser *currentUser = object[@"user"];
              UserCellViewModel *newUCVW = [[UserCellViewModel alloc] initWithUser:currentUser withUserId:currentUser.objectId withUsername:currentUser.username withIsFollowing:object[@"isFollowing"]];
              [strongSelf.arrayOfUserCellViewModels addObject:newUCVW];
          }
        
          [strongSelf.tableView reloadData];
          
        }
      else {
          NSLog(@"there was an error, u suck");
      }
    }];

}

- (void)didFollowUserWithViewModel:(UserCellViewModel *)viewModel {
    
    //refactor all of this into cloud
    PFQuery *thisFollow = [Follow query];
    [thisFollow whereKey:@"followingUserId" equalTo:viewModel.user.objectId];
    [thisFollow whereKey:@"currentUserId" equalTo:[PFUser currentUser].objectId];
    
    __weak typeof(self) weakSelf = self;
    [thisFollow findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        typeof(self) strongSelf = weakSelf;
        if (!strongSelf) {
            NSLog(@"I got killed!");
            return;
        }
        
        if ([objects count] != 0) {
            // refactor this to be deleteAll
            for (id object in objects) {
                [object deleteInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                    viewModel.isFollowing = !succeeded;
                    [self.tableView reloadData];
                }];
            }
            
        }
        else {
            Follow *newFollow =  [[Follow alloc] initWithFollowing:viewModel.user withApproved:YES];
            [newFollow saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                viewModel.isFollowing = succeeded;
                [self.tableView reloadData];
            }];
        }
    }];
}

@end
