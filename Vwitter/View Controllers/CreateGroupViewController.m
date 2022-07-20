//
//  CreateGroupViewController.m
//  Vwitter
//
//  Created by Christina Li on 7/20/22.
//

#import <Parse/Parse.h>
#import <MBProgressHUD/MBProgressHUD.h>

#import "CreateGroupViewController.h"
#import "Follow.h"
#import "AudienceMemberCell.h"
#import "GroupDetails.h"
#import "GroupMembership.h"
#import "VWHelpers.h"

@interface CreateGroupViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray<VWUser *> *arrayOfUserAudienceMembers;
@property (strong, nonatomic) NSMutableArray<GroupDetails *> *arrayOfGroupAudienceMembers;
@property (strong, nonatomic) NSMutableSet *arrayOfSelectedUserAudience;
@property (weak, nonatomic) IBOutlet UITextField *groupNameField;

@end

@implementation CreateGroupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.arrayOfSelectedUserAudience = [[NSMutableSet alloc] init];
    self.tableView.allowsMultipleSelection = YES;
    [self loadData];
}

- (void)loadData {
    __weak typeof(self) weakSelf = self;
    [PFCloud callFunctionInBackground:@"fetchPotentialAudienceUsers"
                       withParameters:@{@"limit":@20, @"currentUserId":[VWUser currentUser].objectId}
                                block:^(id follows, NSError *error) {
        typeof(self) strongSelf = weakSelf;
        if (!strongSelf) {
            NSLog(@"I got killed!");
            return;
        }
        if (!error) {
          NSLog(@"%@", follows);
          NSArray *arrayOfFollows = CAST_TO_CLASS_OR_NIL(follows, NSArray);
            NSArray *arrayOfFollowers = CAST_TO_CLASS_OR_NIL([follows valueForKey:@"currentUser"], NSArray);
          strongSelf.arrayOfUserAudienceMembers = arrayOfFollowers.mutableCopy;
          [strongSelf.tableView reloadData];
          
        }
        else {
          NSLog(@"there was an error, u suck");
        }
    }];

    [PFCloud callFunctionInBackground:@"fetchPotentialAudienceGroups"
                       withParameters:@{@"limit":@20, @"groupAuthorUserId":[VWUser currentUser].objectId}
                                block:^(id groups, NSError *error) {
        typeof(self) strongSelf = weakSelf;
        if (!strongSelf) {
            NSLog(@"I got killed!");
            return;
        }
        if (!error) {
          NSLog(@"%@", groups);
          NSArray *arrayOfGroups = groups;
          strongSelf.arrayOfGroupAudienceMembers = arrayOfGroups.mutableCopy;
          [strongSelf.tableView reloadData];
//            figure out where to move reloadData
          
        }
        else {
          NSLog(@"there was an error, u suck");
        }
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
     return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
     if (section == 0)
     {
            return [self.arrayOfGroupAudienceMembers count];
     }
     else {
            return [self.arrayOfUserAudienceMembers count];
     }
}

//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    return self.arrayOfUserAudienceMembers.count;
//}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
          return @"Groups";
    }
    else {
          return @"Users";
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AudienceMemberCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AudienceMemberCell" forIndexPath:indexPath];

    
    if (indexPath.section == 0) {
//        cell.user = self.arrayOfGroupAudienceMembers[indexPath.row];
    }
    else {
        cell.user = self.arrayOfUserAudienceMembers[indexPath.row];
    }

    return cell;
}

//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    AudienceMemberCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AudienceMemberCell" forIndexPath:indexPath];
//
//    cell.user = self.arrayOfUserAudienceMembers[indexPath.row];
//
//    return cell;
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *tableViewCell = [tableView cellForRowAtIndexPath:indexPath];
    tableViewCell.accessoryView.hidden = NO;
    tableViewCell.accessoryType = UITableViewCellAccessoryCheckmark;
    [self.arrayOfSelectedUserAudience addObject:self.arrayOfUserAudienceMembers[indexPath.row]];
    
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *tableViewCell = [tableView cellForRowAtIndexPath:indexPath];
    tableViewCell.accessoryView.hidden = YES;
    tableViewCell.accessoryType = UITableViewCellAccessoryNone;
    
    [self.arrayOfSelectedUserAudience removeObject:self.arrayOfUserAudienceMembers[indexPath.row]];

}

//refactor to be parse cloud function
- (IBAction)didCreateGroup:(id)sender {
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    GroupDetails *currentGroup = [[GroupDetails alloc] initWithGroupName:self.groupNameField.text withGroupAuthor:[VWUser currentUser]];
    
    NSMutableArray *groupMemberships = [[NSMutableArray alloc] init];
    
    __weak typeof(self) weakSelf = self;
    [currentGroup saveInBackgroundWithBlock: ^(BOOL succeeded, NSError * _Nullable error) {
        typeof(self) strongSelf = weakSelf;
        if (!strongSelf) {
            NSLog(@"I got killed!");
            return;
        }
        if (succeeded) {
            NSLog(@"group details creation succeeded!");
            for (id groupMember in strongSelf.arrayOfSelectedUserAudience) {
                GroupMembership *newGM = [[GroupMembership alloc] initWithUser:groupMember withGroup:currentGroup];
                
                [groupMemberships addObject:newGM];
            }

            [PFObject saveAllInBackground:groupMemberships block:^(BOOL succeeded, NSError * _Nullable error) {
                if (succeeded) {
                    NSLog(@"group memberships succeeded!");
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    [strongSelf dismissViewControllerAnimated:true completion:nil];
                }
                else {
                    NSLog(@"group memberships failed!");
                    [currentGroup deleteInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                        if (succeeded) {
                            NSLog(@"GM error, group deleted!");
                        }
                        else {
                            NSLog(@"GM error, group NOT deleted!");
                        }
                    }];
                    [strongSelf dismissViewControllerAnimated:true completion:nil];
                }
                
            }];
        }
        else {
            NSLog(@"group creation failed");
            NSLog(@"😫😫😫 Error posting: %@", error.localizedDescription);
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [strongSelf dismissViewControllerAnimated:true completion:nil];
        }
    }];
    
}

@end
