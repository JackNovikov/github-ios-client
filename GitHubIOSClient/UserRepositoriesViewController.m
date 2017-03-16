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
        [tableView finishInfiniteScroll];
    }];
    
    self.repositories = [[NSMutableArray alloc] init];
    [self requestRepositoriesList];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)requestRepositoriesList {
    RequestsManager *manager = [RequestsManager sharedRequestManager];
    NSString *url = [NSString stringWithFormat:@"%@?page=%ld&per_page=10", self.repositoriesURL, (long)self.page];
    self.page++;
    NSLog(@"url is --- %@", url);
    [manager getUserRepositoriesList:url completionBlock:^(NSMutableArray *newRepositories) {
        [self.repositories addObjectsFromArray:newRepositories];
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
