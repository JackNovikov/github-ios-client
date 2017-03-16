//
//  RequestsManager.m
//  GitHubIOSClient
//
//  Created by Jack Novikov on 3/14/17.
//  Copyright © 2017 Jack Novikov. All rights reserved.
//

#import "RequestsManager.h"

@implementation RequestsManager

+ (RequestsManager *)sharedRequestManager {
    static RequestsManager *_sharedRequestManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedRequestManager = [[self alloc] initWithBaseURL:nil];
    });
    
    return _sharedRequestManager;
}

// returns in compeletion block NSMutableArray with UserCellModel
- (void)getUsersListSinceNumber:(NSUInteger)number completionBlock:(void (^)(NSMutableArray *))completionBlock {
    NSString *requestURL = [NSString stringWithFormat:@"https://api.github.com/users?since=%tu", number];
    NSURL *url = [NSURL URLWithString:requestURL];
    NSMutableArray *usersList = [[NSMutableArray alloc] init];
    
    [self GET:url.absoluteString parameters:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSArray *users = responseObject;
        for (NSDictionary *tempUser in users) {
            UserCellModel *user = [MTLJSONAdapter modelOfClass:[UserCellModel class] fromJSONDictionary:tempUser error:nil];
            [usersList addObject:user];
        }
        completionBlock(usersList);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@", error);
    }];
}

// returns in compeletion block UserInformationModel by the user id
- (void)getUserInformation:(NSString *)userURL completionBlock:(void (^)(UserInformationModel *))completionBlock {
    NSURL *url = [NSURL URLWithString:userURL];
    
    [self GET:url.absoluteString parameters:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        UserInformationModel *user = [MTLJSONAdapter modelOfClass:[UserInformationModel class] fromJSONDictionary:responseObject error:nil];
        completionBlock(user);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@", error);
    }];
}

// returns in compeletion block NSMutableArray with RepositoryModel
- (void)getUserRepositoriesList:(NSString *)reposURL completionBlock:(void (^)(NSMutableArray *))completionBlock {
    NSURL *url = [NSURL URLWithString:reposURL];
    NSLog(@"gor url - %@", reposURL);
    NSMutableArray *repositoriesList = [[NSMutableArray alloc] init];
    
    [self GET:url.absoluteString parameters:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSArray *repositories = responseObject;
        for (NSDictionary *tempRepository in repositories) {
            RepositoryModel *repository = [MTLJSONAdapter modelOfClass:[RepositoryModel class] fromJSONDictionary:tempRepository error:nil];
            [repositoriesList addObject:repository];
        }
        completionBlock(repositoriesList);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@", error);
    }];
}

@end
