//
//  MyProfileViewController.h
//  GitHubIOSClient
//
//  Created by Jack Novikov on 3/20/17.
//  Copyright © 2017 Jack Novikov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserInformationModel.h"

@interface MyProfileViewController : UIViewController

@property (strong, nonatomic) UserInformationModel *myProfileModel;

@end
