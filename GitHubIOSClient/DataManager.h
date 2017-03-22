//
//  DataManager.h
//  GitHubIOSClient
//
//  Created by Jack Novikov on 3/21/17.
//  Copyright © 2017 Jack Novikov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserCellModel.h"
#import <CoreData/CoreData.h>

@interface DataManager : UIViewController

+ (DataManager *)sharedDataManager;

- (void)addUserToDataBase:(UserCellModel *)user;
- (NSArray *)getUsersFromDataBase;
- (void)clearUsersDataBase;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@end
