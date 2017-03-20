//
//  MyProfileViewController.m
//  GitHubIOSClient
//
//  Created by Jack Novikov on 3/20/17.
//  Copyright © 2017 Jack Novikov. All rights reserved.
//

#import "MyProfileViewController.h"
#import "RequestsManager.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "UserRepositoriesViewController.h"

@interface MyProfileViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *myAvatarImageView;
@property (weak, nonatomic) IBOutlet UITextView *myInformationTextView;
@property (weak, nonatomic) IBOutlet UIButton *myRepositoriesButton;

@end

@implementation MyProfileViewController

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        // set tab bar item
        self.tabBarItem = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemFavorites tag:1];
        //self.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Authors" image:[UIImage imageNamed:@"icon-authors"] tag:0];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveMyProfileModel:) name:@"SignInCompleted" object:nil];

    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveMyProfileModel:) name:@"SignInCompleted" object:nil];
    [self displayUserInformation];
}

- (void)receiveMyProfileModel:(NSNotification *)notification {
    NSDictionary *userInfo = notification.userInfo;
    self.myProfileModel = [[UserInformationModel alloc] init];
    self.myProfileModel = userInfo[@"myProfileModel"];
}

- (void)displayUserInformation {
    [self.navigationItem setTitle:[NSString stringWithFormat:@"%@", self.myProfileModel.login]];
    [self.myAvatarImageView sd_setImageWithURL:[NSURL URLWithString:self.myProfileModel.avatarURL]];
    self.myInformationTextView.text = [NSString stringWithFormat:@"login: %@\nname: %@\ncompany: %@\nlocation: %@\npublic repositories: %@\nfollowers: %@\nprivate gists: %@\ntotal private repositories: %@\nowned private repositories: %@", self.myProfileModel.login, self.myProfileModel.name, self.myProfileModel.company ? self.myProfileModel.company : @"no information", self.myProfileModel.location, self.myProfileModel.publicRepos, self.myProfileModel.followers, self.myProfileModel.privateGists, self.myProfileModel.totalPrivateRepositories, self.myProfileModel.ownedPrivateRepositories];
    [self.myInformationTextView setContentOffset:CGPointZero animated:YES];
    [self.myRepositoriesButton setTitle:[NSString stringWithFormat:@" %@'s repositories ", self.myProfileModel.login] forState:UIControlStateNormal];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"ToMyRepositories"]) {
        [(UserRepositoriesViewController *)segue.destinationViewController setRepositoriesURL:self.myProfileModel.repositoriesURL];
    }
}

@end
