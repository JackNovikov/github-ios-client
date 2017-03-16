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
             @"company": @"company"/*,
             @"followers": @"followers",
             @"location": @"location",
             @"login": @"login",
             @"name": @"name",
             @"publicRepos": @"public_repos"*/
             };
}

@end
