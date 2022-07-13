//
//  SelectAudienceViewController.m
//  Vwitter
//
//  Created by Christina Li on 7/8/22.
//

#import "SelectAudienceViewController.h"
#import <Parse/Parse.h>
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
    
    // Do any additional setup after loading the view.
    self.postVentButton.layer.cornerRadius = 20;
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
}

- (void)loadData {
    PFQuery *audienceQuery = [Follow query];
    [audienceQuery whereKey:@"followingUserId" equalTo:[PFUser currentUser]];
    [audienceQuery whereKey:@"approved" equalTo:@YES];
    [audienceQuery includeKey:@"currentUserId"];
    audienceQuery.limit = 20;
    
//    [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    [audienceQuery findObjectsInBackgroundWithBlock:^(NSArray<Follow *> * _Nullable follows, NSError * _Nullable error) {
        if (follows) {
            NSLog(@"😎😎😎 Successfully loaded search users timeline");
            // do something with the data fetched
            NSArray *arrayOfFollowers = [follows valueForKey:@"currentUserId"];
            self.arrayOfAudienceMembers = arrayOfFollowers.mutableCopy;
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
    [Vent postVent:self.ventContent withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded) {
            NSLog(@"vent post succeeded!");
            
            
        }
        else {
            NSLog(@"vent post failed");
            NSLog(@"😫😫😫 Error posting: %@", error.localizedDescription);
        }
    }];
    
    
    
    
    
    
    [self dismissViewControllerAnimated:true completion:nil];
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
