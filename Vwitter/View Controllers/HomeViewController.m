//
//  HomeViewController.m
//  Vwitter
//
//  Created by Christina Li on 7/8/22.
//

#import <Parse/Parse.h>

#import "HomeViewController.h"
#import "SceneDelegate.h"
#import "LoginViewController.h"
#import "Vent.h"
#import "VentCell.h"
#import "VentAudience.h"
#import "UIViewController+ErrorAlertPresenter.h"
#import "VWUser.h"

@interface HomeViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray<Vent *> *arrayOfVents;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (nonatomic) BOOL isRefreshing;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(beginRefresh) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refreshControl atIndex:0];
    
    [self loadData];
}

- (void)beginRefresh {
    self.isRefreshing = YES;
    [self loadData];
}

- (void)loadData {
    PFQuery *vaQuery = [VentAudience query];
    [vaQuery orderByDescending:@"createdAt"];
    [vaQuery whereKey:@"user" equalTo:[VWUser currentUser]];
    [vaQuery includeKey:@"vent"];
    
    vaQuery.limit = 20;
    

    __weak typeof(self) weakSelf = self;
    [vaQuery findObjectsInBackgroundWithBlock:^(NSArray<VentAudience *> * _Nullable ventAudiences, NSError * _Nullable error) {
        typeof(self) strongSelf = weakSelf;
        if (!strongSelf) {
            NSLog(@"I got killed!");
            return;
        }
        if (ventAudiences) {
            NSLog(@"😎😎😎 Successfully loaded home timeline");
            // do something with the tdata fetched
            strongSelf.arrayOfVents = [ventAudiences valueForKey:@"vent"];
            
            [strongSelf.tableView reloadData];
            
            if (strongSelf.isRefreshing) {
                [strongSelf.refreshControl endRefreshing];
                strongSelf.isRefreshing = NO;
            }
            
        }
        else {
            // handle error
            NSLog(@"😫😫😫 Error getting home timeline: %@", error.localizedDescription);
            
            if (strongSelf.isRefreshing) {
                [strongSelf.refreshControl endRefreshing];
                strongSelf.isRefreshing = NO;
                [strongSelf presentErrorMessageWithTitle:@"Error" message:@"There was an error refreshing."];
                
            }
        }

    }];
}
- (IBAction)didTapLogout:(id)sender {
    [VWUser logOutInBackgroundWithBlock:^(NSError * _Nullable error) {
        if (error) {
            NSLog (@"Error logging user out");
        }
        else {
            SceneDelegate *sceneDelegate = (SceneDelegate *)self.view.window.windowScene.delegate;

            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
            sceneDelegate.window.rootViewController = loginViewController;
            NSLog(@"User logged out successfully");
            
        }
        
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [self loadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.arrayOfVents.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    VentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"VentCell" forIndexPath:indexPath];

    cell.vent = self.arrayOfVents[indexPath.row];

    return cell;
}

@end
