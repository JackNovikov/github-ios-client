//
//  UserCellModel.m
//  GitHubIOSClient
//
//  Created by Jack Novikov on 3/15/17.
//  Copyright © 2017 Jack Novikov. All rights reserved.
//

#import "UserCellModel.h"

@implementation UserCellModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"login": @"login",
             @"avatarURL": @"avatar_url",
             @"userURL": @"url"
             };
}

@end
