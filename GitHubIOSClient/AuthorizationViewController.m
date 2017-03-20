//
//  AuthorizationViewController.m
//  GitHubIOSClient
//
//  Created by Jack Novikov on 3/19/17.
//  Copyright © 2017 Jack Novikov. All rights reserved.
//

#import "AuthorizationViewController.h"
#import "RequestsManager.h"

@interface AuthorizationViewController ()

@property (weak, nonatomic) IBOutlet UITextField *loginTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@end

@implementation AuthorizationViewController

static NSInteger OFFSET_FOR_KEYBOARD = 80.0;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)signInButtonClicked:(id)sender {
    RequestsManager *manager = [RequestsManager sharedRequestManager];
    [manager authUserWithLogin:self.loginTextField.text andPassword:self.passwordTextField.text];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
