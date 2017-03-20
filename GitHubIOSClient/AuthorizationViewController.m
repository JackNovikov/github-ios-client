//
//  AuthorizationViewController.m
//  GitHubIOSClient
//
//  Created by Jack Novikov on 3/19/17.
//  Copyright © 2017 Jack Novikov. All rights reserved.
//

#import "AuthorizationViewController.h"
#import "RequestsManager.h"
#import "MyProfileViewController.h"

@interface AuthorizationViewController ()

@property (weak, nonatomic) IBOutlet UITextField *loginTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@end

@implementation AuthorizationViewController

static NSInteger OFFSET_FOR_KEYBOARD = 80.0;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
}

-(void)dismissKeyboard
{
    [self.loginTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    textField.placeholder = textField.text;
    textField.text = @"";
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField.text.length == 0) {
        textField.text = textField.placeholder;
    }
    
    textField.placeholder = @"";
}

/*- (IBAction)signInButtonClicked:(id)sender {
    RequestsManager *manager = [RequestsManager sharedRequestManager];
    [manager authUserWithLogin:self.loginTextField.text andPassword:self.passwordTextField.text completionBlock:^(UserInformationModel *myModel) {
        <#code#>
    }];
}*/

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"SignInToMyProfile"]) {
        
        RequestsManager *manager = [RequestsManager sharedRequestManager];
        [manager authUserWithLogin:self.loginTextField.text andPassword:self.passwordTextField.text completionBlock:^(UserInformationModel *myModel) {
            //[(MyProfileViewController *)segue.destinationViewController logModel:myModel];
            NSDictionary *userInfo = @{@"myProfileModel": myModel};
            NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
            [notificationCenter postNotificationName:@"SignInCompleted" object:self userInfo:userInfo];
            NSLog(@"notification posted");
        }];

        //[(UserInformationViewController *)segue.destinationViewController setUserURL:user.userURL];
    }
}



@end
