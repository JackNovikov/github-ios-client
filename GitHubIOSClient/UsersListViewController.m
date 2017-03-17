//
//  UsersListViewController.m
//  GitHubIOSClient
//
//  Created by Jack Novikov on 3/15/17.
//  Copyright © 2017 Jack Novikov. All rights reserved.
//

#import "UsersListViewController.h"
#import "UsersListTableViewCell.h"
#import "RequestsManager.h"
#import "UserCellModel.h"
#import "UserInformationViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <UIScrollView-InfiniteScroll/UIScrollView+InfiniteScroll.h>

@interface UsersListViewController () <UITableViewDataSource, UITableViewDelegate, UISearchControllerDelegate, UISearchBarDelegate, UISearchResultsUpdating>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *users;
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property (strong, nonatomic) UISearchController *searchController;
@property (strong, nonatomic) NSMutableArray *filteredUsers;
@property (strong, nonatomic) NSArray *displayedUsers;

@end

@implementation UsersListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"GitHub users"];
    self.users = [[NSMutableArray alloc] init];
    
    // search controller
    self.filteredUsers = [[NSMutableArray alloc] init];
    self.displayedUsers = self.users;
    
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.searchController.searchResultsUpdater = self;
    self.searchController.searchBar.delegate = self;
    
    [self.searchController.searchBar sizeToFit];
    
    self.tableView.tableHeaderView = self.searchController.searchBar;
    
    //[self.tableView setContentOffset:CGPointMake(0, self.searchController.searchBar.frame.size.height)];
    
    
    // pagination scroll
    [self.tableView addInfiniteScrollWithHandler:^(UITableView *tableView) {
        [self requestUsersList];
        [tableView finishInfiniteScroll];
    }];
    
    // pull to refresh
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.tableView addSubview:self.refreshControl];
    [self.refreshControl addTarget:self action:@selector(refreshTable) forControlEvents:UIControlEventValueChanged];
    
    [self requestUsersList];
}

- (void)updateSearchResultsForSearchController:(UISearchController *)aSearchController {
    NSLog(@"update Search Results For Search Controller");
    
    NSString *searchString = aSearchController.searchBar.text;
    NSLog(@"searchString=%@", searchString);
    
    // Check if the user cancelled or deleted the search term so we can display the full list instead.
    if (![searchString isEqualToString:@""]) {
        [self.filteredUsers removeAllObjects];
        for (UserCellModel *tempUser in self.users) {
            NSString *str = tempUser.login;
            if ([searchString isEqualToString:@""] || [str localizedCaseInsensitiveContainsString:searchString] == YES) {
                //NSLog(@"str=%@", str);
                [self.filteredUsers addObject:tempUser];
            }
        }
        self.displayedUsers = self.filteredUsers;
    }
    else {
        self.displayedUsers = self.users;
    }
    [self.tableView reloadData];
    NSLog(@"data reloaded");
}

// pull to refresh
- (void) refreshTable {
    [self.users removeAllObjects];
    [self.tableView reloadData];
    [self requestUsersList];
}

- (void)requestUsersList {
    RequestsManager *manager = [RequestsManager sharedRequestManager];
    NSInteger lastUser = 0;
    if ([self.users count]) {
        lastUser = [[[self.users lastObject] userID] integerValue];
    }
    [manager getUsersListSinceNumber:lastUser completionBlock:^(NSArray *newUsers) {
        [self.users addObjectsFromArray:newUsers];
        [self.tableView reloadData];
        [self.refreshControl endRefreshing];
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.users count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"UsersListCell";
    
    UsersListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    UserCellModel *user = [self.users objectAtIndex:indexPath.row];
    [cell.avatarImage sd_setImageWithURL:[NSURL URLWithString:user.avatarURL]];
    cell.name.text = user.login;
    
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"UsersListToUserInformation"]) {
        
        UserCellModel *user = [self.users objectAtIndex:[[self.tableView indexPathForCell:sender] row]];
        [(UserInformationViewController *)segue.destinationViewController setUserURL:user.userURL];
    }
}

@end
