//
//  UserInformationModel.m
//  GitHubIOSClient
//
//  Created by Jack Novikov on 3/15/17.
//  Copyright © 2017 Jack Novikov. All rights reserved.
//

#import "UserInformationModel.h"

@implementation UserInformationModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"avatarURL": @"avatar_url",
             @"company": @"company",
             @"followers": @"followers",
             @"location": @"location",
             @"login": @"login",
             @"repositoriesURL": @"repos_url",
             @"name": @"name",
             @"publicRepos": @"public_repos",
             @"privateGists":@"private_gists",
             @"totalPrivateRepositories": @"total_private_repos",
             @"ownedPrivateRepositories": @"owned_private_repos"
             };
}

@end
