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

@interface SelectAudienceViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *postVentButton;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *arrayOfAudienceMembers;
@property (strong, nonatomic) NSMutableArray *arrayOfSelectedAudience;

@end

@implementation SelectAudienceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.arrayOfSelectedAudience = [[NSMutableArray alloc] init];
    self.tableView.allowsMultipleSelection = YES;
    [self loadData];

    self.postVentButton.layer.cornerRadius = 20;
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
}

- (void)loadData {
    PFQuery *audienceQuery = [Follow query];
    [audienceQuery whereKey:@"followingUser" equalTo:[PFUser currentUser]];
    [audienceQuery whereKey:@"approved" equalTo:@YES];
    [audienceQuery includeKey:@"currentUser"];
    audienceQuery.limit = 20;
    
    __weak typeof(self) weakSelf = self;
    [audienceQuery findObjectsInBackgroundWithBlock:^(NSArray<Follow *> * _Nullable follows, NSError * _Nullable error) {
        typeof(self) strongSelf = weakSelf;
        if (!strongSelf) {
                NSLog(@"I got killed!");
                return;
        }
        if (follows) {
            NSLog(@"😎😎😎 Successfully loaded search users timeline");
            NSArray *arrayOfFollowers = [follows valueForKey:@"currentUser"];
            strongSelf.arrayOfAudienceMembers = arrayOfFollowers.mutableCopy;
            [strongSelf.tableView reloadData];
            
        }
        else {
            NSLog(@"😫😫😫 Error getting home timeline: %@", error.localizedDescription);
        }
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.arrayOfAudienceMembers.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AudienceMemberCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AudienceMemberCell" forIndexPath:indexPath];

    cell.user = self.arrayOfAudienceMembers[indexPath.row];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *tableViewCell = [tableView cellForRowAtIndexPath:indexPath];
    tableViewCell.accessoryView.hidden = NO;
    tableViewCell.accessoryType = UITableViewCellAccessoryCheckmark;
    [self.arrayOfSelectedAudience addObject:self.arrayOfAudienceMembers[indexPath.row]];
    
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *tableViewCell = [tableView cellForRowAtIndexPath:indexPath];
    tableViewCell.accessoryView.hidden = YES;
    tableViewCell.accessoryType = UITableViewCellAccessoryNone;
    
    [self.arrayOfSelectedAudience removeObject:self.arrayOfAudienceMembers[indexPath.row]];

}

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
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    [strongSelf dismissViewControllerAnimated:true completion:nil];
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
