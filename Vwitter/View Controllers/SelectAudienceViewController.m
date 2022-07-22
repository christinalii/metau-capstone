//
//  SelectAudienceViewController.m
//  Vwitter
//
//  Created by Christina Li on 7/8/22.
//

#import <Parse/Parse.h>
#import <MBProgressHUD/MBProgressHUD.h>

#import "SelectAudienceViewController.h"
#import "Follow.h"
#import "AudienceMemberCell.h"
#import "Vent.h"
#import "VentAudience.h"
#import "VWHelpers.h"
#import "GroupCell.h"

@interface SelectAudienceViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *postVentButton;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray<VWUser *> *arrayOfUserAudienceMembers;
@property (strong, nonatomic) NSMutableArray<GroupDetails *> *arrayOfGroupAudienceMembers;
@property (strong, nonatomic) NSMutableSet *arrayOfSelectedAudience;

@end

@implementation SelectAudienceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.arrayOfSelectedAudience = [[NSMutableSet alloc] init];
    self.tableView.allowsMultipleSelection = YES;
    [self loadData];

    self.postVentButton.layer.cornerRadius = 20;
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

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
          return @"Groups";
    }
    else {
          return @"Users";
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        GroupCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GroupCell" forIndexPath:indexPath];
        cell.group = self.arrayOfGroupAudienceMembers[indexPath.row];
        return cell;
    }
    else {
        AudienceMemberCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AudienceMemberCell" forIndexPath:indexPath];
        cell.user = self.arrayOfUserAudienceMembers[indexPath.row];
        return cell;
    }

    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *tableViewCell = [tableView cellForRowAtIndexPath:indexPath];
    tableViewCell.accessoryView.hidden = NO;
    tableViewCell.accessoryType = UITableViewCellAccessoryCheckmark;
    if (indexPath.section == 0) {
        [self.arrayOfSelectedAudience addObject:self.arrayOfGroupAudienceMembers[indexPath.row]];
    }
    else {
        [self.arrayOfSelectedAudience addObject:self.arrayOfUserAudienceMembers[indexPath.row]];
    }
    
    
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *tableViewCell = [tableView cellForRowAtIndexPath:indexPath];
    tableViewCell.accessoryView.hidden = YES;
    tableViewCell.accessoryType = UITableViewCellAccessoryNone;
    if (indexPath.section == 0) {
        [self.arrayOfSelectedAudience removeObject:self.arrayOfGroupAudienceMembers[indexPath.row]];
    }
    else {
        [self.arrayOfSelectedAudience removeObject:self.arrayOfUserAudienceMembers[indexPath.row]];
    }

}

//refactor to be PFCloud func
- (IBAction)didTapVent:(id)sender {
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    Vent *currentVent = [[Vent alloc] initWithVentContent:self.ventContent];
    
    NSMutableArray *ventAudiences = [[NSMutableArray alloc] init];
    __weak typeof(self) weakSelf = self;
    [currentVent saveInBackgroundWithBlock: ^(BOOL succeeded, NSError * _Nullable error) {
        typeof(self) strongSelf = weakSelf;
        if (!strongSelf) {
            NSLog(@"I got killed!");
            return;
        }
        if (succeeded) {
            NSLog(@"vent post succeeded!");
            for (id audience in strongSelf.arrayOfSelectedAudience) {
                if ([audience isKindOfClass:[PFUser class]]) {
                    VentAudience *newVA = [[VentAudience alloc] initWithUserAudience:audience withVent:currentVent];
                    
                    [ventAudiences addObject:newVA];
                }
                else if ([audience isKindOfClass:[GroupDetails class]]) {
                    VentAudience *newVA = [[VentAudience alloc] initWithGroupAudience:audience withVent:currentVent];
                    
                    [ventAudiences addObject:newVA];
                }
                else {
                    NSLog(@"not a possible audience type");
                }
            }

            [PFObject saveAllInBackground:ventAudiences block:^(BOOL succeeded, NSError * _Nullable error) {
                if (succeeded) {
                    NSLog(@"vent audiences succeeded!");
                    [MBProgressHUD hideHUDForView:strongSelf.view animated:YES];
                    [strongSelf dismissViewControllerAnimated:YES completion:nil];
                }
                else {
                    NSLog(@"vent audiences failed!");
                    [currentVent deleteInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                        if (succeeded) {
                            NSLog(@"VA error, vent deleted!");
                        }
                        else {
                            NSLog(@"VA error, vent NOT deleted!");
                        }
                    }];
                    [strongSelf dismissViewControllerAnimated:true completion:nil];
                }
                
            }];
        }
        else {
            NSLog(@"vent post failed");
            NSLog(@"😫😫😫 Error posting: %@", error.localizedDescription);
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [strongSelf dismissViewControllerAnimated:true completion:nil];
        }
    }];

    
}

@end
