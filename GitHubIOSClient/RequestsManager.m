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
- (void)getUsersListSinceNumber:(NSUInteger)number completionBlock:(void (^)(NSArray *))completionBlock {
    NSString *requestURL = [NSString stringWithFormat:@"https://api.github.com/users?since=%tu", number];
    NSURL *url = [NSURL URLWithString:requestURL];
    NSMutableArray *usersList = [[NSMutableArray alloc] init];
    
    [self GET:url.absoluteString parameters:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSArray *users = responseObject;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            for (NSDictionary *tempUser in users) {
                UserCellModel *user = [MTLJSONAdapter modelOfClass:[UserCellModel class] fromJSONDictionary:tempUser error:nil];
                [usersList addObject:user];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock(usersList);
            });
        });
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@", error);
    }];
}

// returns in compeletion block UserInformationModel by the user id
- (void)getUserInformation:(NSString *)userURL completionBlock:(void (^)(UserInformationModel *))completionBlock {
    NSURL *url = [NSURL URLWithString:userURL];
    
    [self GET:url.absoluteString parameters:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            UserInformationModel *user = [MTLJSONAdapter modelOfClass:[UserInformationModel class] fromJSONDictionary:responseObject error:nil];
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock(user);
            });
        });
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@", error);
    }];
}

// returns in compeletion block NSMutableArray with RepositoryModel
- (void)getUserRepositoriesList:(NSString *)reposURL forPage:(NSInteger)page completionBlock:(void (^)(NSArray *))completionBlock {
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@?page=%ld&per_page=10", reposURL, page]];

    NSMutableArray *repositoriesList = [[NSMutableArray alloc] init];
    
    [self GET:url.absoluteString parameters:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSArray *repositories = responseObject;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            for (NSDictionary *tempRepository in repositories) {
                RepositoryModel *repository = [MTLJSONAdapter modelOfClass:[RepositoryModel class] fromJSONDictionary:tempRepository error:nil];
                [repositoriesList addObject:repository];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock(repositoriesList);
            });
        });
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@", error);
    }];
}

// basic auth
- (void)authUserWithLogin:(NSString *)login andPassword:(NSString *)password {
    NSLog(@"login: %@, password: %@", login, password);
    [self setRequestSerializer:[AFHTTPRequestSerializer serializer]];
    [self.requestSerializer setAuthorizationHeaderFieldWithUsername:login password:password];
    self.requestSerializer.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
    NSURL *url = [NSURL URLWithString:@"https://api.github.com/user"];
    [self GET:url.absoluteString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"AUTHED");
        NSLog(@"response: %@", responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"NOT AUTHED");
    }];
}

@end
