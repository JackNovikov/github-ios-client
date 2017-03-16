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

@interface UsersListViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *users;
@property (copy, nonatomic) NSString *tappedUserURL;

@end

@implementation UsersListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.users = [[NSMutableArray alloc] init];
    [self requestUsersList];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)requestUsersList {
    RequestsManager *manager = [RequestsManager sharedRequestManager];
    [manager getUsersListSinceNumber:[self.users count] completionBlock:^(NSMutableArray *newUsers) {
        [self.users addObjectsFromArray:newUsers];
        //NSLog(@"**********************%@", self.users);
        //NSLog(@"++++++++++++++++++++++%@", newUsers);
        [self.tableView reloadData];
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
