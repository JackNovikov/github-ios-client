//
//  RequestsManager.h
//  GitHubIOSClient
//
//  Created by Jack Novikov on 3/14/17.
//  Copyright © 2017 Jack Novikov. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>
#import "UserCellModel.h"
#import "UserInformationModel.h"
#import "RepositoryModel.h"

@interface RequestsManager : AFHTTPSessionManager

+ (RequestsManager *)sharedRequestManager;
- (void)getUsersListSinceNumber:(NSUInteger)number completionBlock:(void (^)(NSArray *))completionBlock;
- (void)getUsersListForSearchTerm:(NSString *)term forPage:(NSInteger)page completionBlock:(void (^)(NSArray *))completionBlock;
- (void)getUserInformation:(NSString *)userId completionBlock:(void (^)(UserInformationModel *))completionBlock;
- (void)getUserRepositoriesList:(NSString *)reposURL forPage:(NSInteger)page completionBlock:(void (^)(NSArray *))completionBlock;
- (void)authUserWithLogin:(NSString *)login andPassword:(NSString *)password completionBlock:(void (^)(NSDictionary *))completionBlock;

@end
