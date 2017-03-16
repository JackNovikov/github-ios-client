//
//  UserInformationViewController.m
//  GitHubIOSClient
//
//  Created by Jack Novikov on 3/14/17.
//  Copyright © 2017 Jack Novikov. All rights reserved.
//

#import "UserInformationViewController.h"
#import "RequestsManager.h"
#import "UserInformationModel.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "UserRepositoriesViewController.h"

@interface UserInformationViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *userAvatar;
@property (weak, nonatomic) IBOutlet UITextView *userInformation;
@property (weak, nonatomic) IBOutlet UIButton *userRepositories;
@property (strong, nonatomic) UserInformationModel *userModel;

@end

@implementation UserInformationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.userModel = [[UserInformationModel alloc] init];
    [self requestUserInformation];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)requestUserInformation {
    RequestsManager *manager = [RequestsManager sharedRequestManager];
    [manager getUserInformation:self.userURL completionBlock:^(UserInformationModel *model) {
        self.userModel = model;
        [self displayUserInformation];
    }];
}

- (void)displayUserInformation {
    [self.userAvatar sd_setImageWithURL:[NSURL URLWithString:self.userModel.avatarURL]];
    self.userInformation.text = [NSString stringWithFormat:@"login: %@\nname: %@\ncompany: %@\nlocation: %@\npublic repositories: %@\nfollowers: %@", self.userModel.login, self.userModel.name, self.userModel.company, self.userModel.location, self.userModel.publicRepos, self.userModel.followers];
    [self.userRepositories setTitle:[NSString stringWithFormat:@" %@ repositories ", self.userModel.login] forState:UIControlStateNormal];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"ToUserRepositories"]) {
        [(UserRepositoriesViewController *)segue.destinationViewController setRepositoriesURL:self.userModel.repositoriesURL];
    }
}

@end
