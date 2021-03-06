//
//  UserInformationModel.h
//  GitHubIOSClient
//
//  Created by Jack Novikov on 3/15/17.
//  Copyright © 2017 Jack Novikov. All rights reserved.
//

#import <Mantle/Mantle.h>

// model for the user information
@interface UserInformationModel : MTLModel <MTLJSONSerializing>

@property (copy, nonatomic) NSString *login;
@property (copy, nonatomic) NSString *avatarURL;
@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *company;
@property (copy, nonatomic) NSString *location;
@property (copy, nonatomic) NSNumber *publicRepos;
@property (copy, nonatomic) NSNumber *followers;
@property (copy, nonatomic) NSString *repositoriesURL;

// in myProfile only
@property (copy, nonatomic) NSNumber *privateGists;
@property (copy, nonatomic) NSNumber *totalPrivateRepositories;
@property (copy, nonatomic) NSNumber *ownedPrivateRepositories;

@end
