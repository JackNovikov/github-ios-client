//
//  UsersListTableViewCell.h
//  GitHubIOSClient
//
//  Created by Jack Novikov on 3/15/17.
//  Copyright © 2017 Jack Novikov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UsersListTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *avatarImage;
@property (weak, nonatomic) IBOutlet UILabel *name;

@end
