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
@property (assign, nonatomic) NSInteger page;

@end

@implementation UserRepositoriesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.page = 1;
    
    // pagination scroll
    [self.tableView addInfiniteScrollWithHandler:^(UITableView *tableView) {
        [self requestRepositoriesList];
    }];
    
    self.repositories = [[NSMutableArray alloc] init];
    [self requestRepositoriesList];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)requestRepositoriesList {
    RequestsManager *manager = [RequestsManager sharedRequestManager];
    
    [manager getUserRepositoriesList:self.repositoriesURL forPage:self.page completionBlock:^(NSArray *newRepositories) {
        [self.repositories addObjectsFromArray:newRepositories];
        [self.tableView reloadData];
        [self.tableView finishInfiniteScroll];
    }];
    self.page++;
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
    
    RepositoryModel *model = [self.repositories objectAtIndex:indexPath.row];
    cell.repositoryName.text = model.name;
    cell.repositoryDescription.text = [NSString stringWithFormat:@"language: %@\n%@", model.language, model.repositoryDescription ? model.repositoryDescription : @"- no description -"];
    
    return cell;
}

@end
