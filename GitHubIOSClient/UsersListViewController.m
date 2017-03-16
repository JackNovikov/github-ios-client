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

@interface UsersListViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *users;
@property (copy, nonatomic) NSString *tappedUserURL;
@property (strong, nonatomic) UIRefreshControl *refreshControl;


@end

@implementation UsersListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // pagination scroll
    [self.tableView addInfiniteScrollWithHandler:^(UITableView * _Nonnull tableView) {
        [self requestUsersList];
        [tableView finishInfiniteScroll];
    }];
    
    // pull to refresh
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.tableView addSubview:self.refreshControl];
    [self.refreshControl addTarget:self action:@selector(refreshTable) forControlEvents:UIControlEventValueChanged];
    
    self.users = [[NSMutableArray alloc] init];
    [self requestUsersList];
}

// pull to refresh
- (void) refreshTable {
    [self.users removeAllObjects];
    [self requestUsersList];
    [self.refreshControl endRefreshing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)requestUsersList {
    NSLog(@"start: %lu", (unsigned long)self.users.count);
    RequestsManager *manager = [RequestsManager sharedRequestManager];
    NSInteger lastUser = 0;
    if ([self.users count]) {
        lastUser = [[[self.users lastObject] userID] integerValue];
    }
    [manager getUsersListSinceNumber:lastUser completionBlock:^(NSMutableArray *newUsers) {
        [self.users addObjectsFromArray:newUsers];
        [self.tableView reloadData];
        NSLog(@"end: %lu", (unsigned long)self.users.count);
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
    
    UserCellModel *user = [[UserCellModel alloc] init];
    user = [self.users objectAtIndex:[indexPath row]];
    [cell.avatarImage sd_setImageWithURL:[NSURL URLWithString:user.avatarURL]];
    cell.name.text = user.login;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    // fetch user
    UserCellModel *user = [self.users objectAtIndex:[indexPath row]];
    self.tappedUserURL = user.userURL;
    
    // perform segue
    [self performSegueWithIdentifier:@"UsersListToUserInformation" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.destinationViewController isKindOfClass:[UserInformationViewController class]]) {
        
        // configure UserInformationController
        [(UserInformationViewController *)segue.destinationViewController setUserURL:self.tappedUserURL];
        
        [self setTappedUserURL:nil];
    }
}

@end
