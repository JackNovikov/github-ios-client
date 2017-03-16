//
//  UserRepositoriesViewController.m
//  GitHubIOSClient
//
//  Created by Jack Novikov on 3/15/17.
//  Copyright © 2017 Jack Novikov. All rights reserved.
//

#import "UserRepositoriesViewController.h"
#import "RequestsManager.h"
#import "UserRepositoriesTableViewCell.h"
#import "RepositoryModel.h"
#import <UIScrollView-InfiniteScroll/UIScrollView+InfiniteScroll.h>

@interface UserRepositoriesViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *repositories;

@end

@implementation UserRepositoriesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // pagination scroll
    [self.tableView addInfiniteScrollWithHandler:^(UITableView *tableView) {
        [self requestRepositoriesList];
        [tableView finishInfiniteScroll];
    }];
    
    self.repositories = [[NSMutableArray alloc] init];
    [self requestRepositoriesList];
    NSLog(@"%@", self.repositoriesURL);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)requestRepositoriesList {
    RequestsManager *manager = [RequestsManager sharedRequestManager];
    [manager getUserRepositoriesList:self.repositoriesURL completionBlock:^(NSMutableArray *newRepositories) {
        [self.repositories addObjectsFromArray:newRepositories];
        NSLog(@"NEW REPOS\n%@", newRepositories);
        NSLog(@"REPOS %@", self.repositories);
        [self.tableView reloadData];
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.repositories count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"RepositoriesListCell";
    
    UserRepositoriesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    RepositoryModel *model = [[RepositoryModel alloc] init];
    model = [self.repositories objectAtIndex:[indexPath row]];
    cell.repositoryName.text = model.name;
    cell.repositoryDescription.text = [NSString stringWithFormat:@"language: %@\n%@", model.language, model.repositoryDescription];
    
    return cell;
}

@end
