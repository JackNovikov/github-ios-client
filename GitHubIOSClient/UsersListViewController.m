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

@interface UsersListViewController () <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *users;
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property (strong, nonatomic) NSArray *displayedUsers;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) NSMutableArray *filteredUsers;
@property BOOL isFiltered;
@property NSInteger searchPage;

@end

@implementation UsersListViewController

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        // set tab bar item
        self.tabBarItem = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemSearch tag:1];
        [self.tabBarItem setTitle:@"ha-ha-ha"];
        //self.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Authors" image:[UIImage imageNamed:@"icon-authors"] tag:0];
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"GitHub users"];
    self.users = [[NSMutableArray alloc] init];
    self.searchBar.delegate = self;
    self.filteredUsers = self.users;
    self.searchPage = 1;

    // pagination scroll
    [self.tableView addInfiniteScrollWithHandler:^(UITableView *tableView) {
        if (self.isFiltered) {
            [self searchBarSearchButtonClicked:self.searchBar];
        } else {
            [self requestUsersList];
        }
    }];
    
    
    // pull to refresh
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.tableView addSubview:self.refreshControl];
    [self.refreshControl addTarget:self action:@selector(refreshTable) forControlEvents:UIControlEventValueChanged];
    
    if (self.isFiltered) {
        [self searchBarSearchButtonClicked:self.searchBar];
    } else {
        [self requestUsersList];
    }
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)text {
    searchBar.showsCancelButton = YES;
    if (text.length == 0) {
        self.isFiltered = FALSE;
        searchBar.showsCancelButton = NO;
        [self performSelector:@selector(hideKeyboardWithSearhButton:) withObject:searchBar afterDelay:0];
        [self refreshTable];
    } else {
        self.isFiltered = true;
        self.filteredUsers = [[NSMutableArray alloc] init];
        
        for (UserCellModel *model in self.users) {
            NSRange loginRange = [model.login rangeOfString:text options:NSCaseInsensitiveSearch];
            if (loginRange.location != NSNotFound) {
                [self.filteredUsers addObject:model];
            }
        }
    }
    [self.tableView reloadData];
}

- (void)hideKeyboardWithSearhButton:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
    searchBar.showsCancelButton = NO;
}

// display users according to search term
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    RequestsManager *manager = [RequestsManager sharedRequestManager];
    [manager getUsersListForSearchTerm:searchBar.text forPage:self.searchPage completionBlock:^(NSArray *searchedUsers) {
        if (self.searchPage == 1) {
            [self.filteredUsers removeAllObjects];
        }
        [self.filteredUsers addObjectsFromArray:searchedUsers];
        self.isFiltered = true;
        self.searchPage++;
        [self.tableView reloadData];
        [self.refreshControl endRefreshing];
        [self.tableView finishInfiniteScroll];
    }];
}

// pull to refresh
- (void) refreshTable {
    [self.users removeAllObjects];
    [self.filteredUsers removeAllObjects];
    [self.tableView reloadData];
    if (self.isFiltered) {
        self.searchPage = 1;
        [self searchBarSearchButtonClicked:self.searchBar];
    } else {
        [self requestUsersList];
    }
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
        [self.tableView finishInfiniteScroll];
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSUInteger rowCount;
    if (self.isFiltered) {
        rowCount = self.filteredUsers.count;
    } else {
        rowCount = self.users.count;
    }
    return rowCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"UsersListCell";
    
    UsersListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UsersListTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    UserCellModel *user;
    if (self.isFiltered) {
        user = [self.filteredUsers objectAtIndex:indexPath.row];
    } else {
        user = [self.users objectAtIndex:indexPath.row];
    }
    
    [cell.avatarImage sd_setImageWithURL:[NSURL URLWithString:user.avatarURL]];
    cell.name.text = user.login;
    
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"UsersListToUserInformation"]) {
        
        UserCellModel *user;
        if (self.isFiltered) {
            user = [self.filteredUsers objectAtIndex:[[self.tableView indexPathForCell:sender] row]];
        } else {
            user = [self.users objectAtIndex:[[self.tableView indexPathForCell:sender] row]];
        }
        [(UserInformationViewController *)segue.destinationViewController setUserURL:user.userURL];
    }
}

@end
