//
//  UserRepositoriesTableViewCell.h
//  GitHubIOSClient
//
//  Created by Jack Novikov on 3/16/17.
//  Copyright © 2017 Jack Novikov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserRepositoriesTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *repositoryName;
@property (weak, nonatomic) IBOutlet UITextView *repositoryInformation;

@end
