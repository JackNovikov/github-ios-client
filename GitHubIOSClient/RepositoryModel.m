//
//  RepositoryModel.m
//  GitHubIOSClient
//
//  Created by Jack Novikov on 3/15/17.
//  Copyright © 2017 Jack Novikov. All rights reserved.
//

#import "RepositoryModel.h"

@implementation RepositoryModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"name": @"name",
             @"fullName": @"full_name"
             };
}

@end
