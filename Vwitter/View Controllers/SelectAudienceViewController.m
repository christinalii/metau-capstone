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

@interface SelectAudienceViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *postVentButton;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *arrayOfAudienceMembers;

@end

@implementation SelectAudienceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
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

- (IBAction)didTapVent:(id)sender {
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
