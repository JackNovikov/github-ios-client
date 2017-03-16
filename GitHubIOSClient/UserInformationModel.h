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
@property (copy, nonatomic) NSString *publicRepos;
@property (copy, nonatomic) NSString *followers;

@end
