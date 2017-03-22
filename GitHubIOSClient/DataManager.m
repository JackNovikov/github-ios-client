//
//  DataManager.m
//  GitHubIOSClient
//
//  Created by Jack Novikov on 3/21/17.
//  Copyright © 2017 Jack Novikov. All rights reserved.
//

#import "DataManager.h"
#import "AppDelegate.h"

@implementation DataManager

+ (DataManager *)sharedDataManager {
    static DataManager *_sharedDataManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedDataManager = [[self alloc] init];
    });
    
    return _sharedDataManager;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(NSManagedObjectContext *)managedObjectContext{
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]){
        context = [delegate managedObjectContext];
    }
    return context;
}

- (void)addUserToDataBase:(UserCellModel *)user {
    NSManagedObjectContext *context = [self managedObjectContext];
    UserCellModel *cell = user;
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"UserCoreDataModel" inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entity];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"login" ascending:NO];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    [request setSortDescriptors:sortDescriptors];
    //[sortDescriptor release];
    NSError *error;
    NSMutableArray *mutableFetchResults = [[context executeFetchRequest:request error:&error] mutableCopy];
    
    if (!mutableFetchResults) {
        // error handling code.
    }
    if ([[mutableFetchResults valueForKey:@"login"] containsObject:user.login]) {
        //notify duplicates
        return;
    } else {
        NSManagedObject *newDevice = [NSEntityDescription insertNewObjectForEntityForName:@"UserCoreDataModel" inManagedObjectContext:context];
        [newDevice setValue:cell.login forKey:@"login"];
        [newDevice setValue:cell.userURL forKey:@"userURL"];
        [newDevice setValue:cell.avatarURL forKey:@"avatarURL"];
        
        //NSError *error = nil;
        if(![context save:&error]){
            NSLog(@"Can't save! %@ %@", error, [error localizedDescription]);
        } else {
            //NSLog(@"Data saved");
        }
    }
}

- (NSArray *)getUsersFromDataBase {
    NSManagedObjectContext *context = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"UserCoreDataModel"];
    NSArray *fetchedUsers = [[context executeFetchRequest:fetchRequest error:nil] mutableCopy];
    
    return fetchedUsers;
}

- (void)clearUsersDataBase {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"UserCoreDataModel"];
    [fetchRequest setIncludesPropertyValues:NO];
    NSError *error;
    NSArray *fetchedObjects = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    NSManagedObjectContext *context = [self managedObjectContext];
    for (NSManagedObject *object in fetchedObjects) {
        [context deleteObject:object];
    }
    if(![context save:&error]){
        NSLog(@"Can't delete! %@ %@", error, [error localizedDescription]);
    } else {
        //NSLog(@"Data deleted");
    }
}

@end

