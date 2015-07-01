//
//  RegisterTableViewController.m
//  Covoicar
//
//  Created by Loris on 25/06/2015.
//  Copyright (c) 2015 Loris Venturelli. All rights reserved.
//

#import "RegisterTableViewController.h"

@interface RegisterTableViewController ()

@end

@implementation RegisterTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (IBAction)submitAction:(id)sender {
    
    NSDictionary *parameters = @{@"email":self.emailField.text,
                                 @"password":self.passwordField.text,
                                 @"repassword":self.rePasswordField.text,
                                 @"lastname":self.lastNameField.text,
                                 @"firstname":self.firstNameField.text,
                                 @"gender":@"1",
                                 @"birthday":self.birthdayField.text};
    
    [[UserManager sharedInstance] registerToApi:parameters success:^(NSDictionary *responseJson) {
        
        [[UserManager sharedInstance] connectToApiWithEmail:self.emailField.text AndPassword:self.passwordField.text success:^(NSDictionary *responseJson) {
            
            // Next UIView
            UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            UIViewController* arrivee = [storyboard instantiateViewControllerWithIdentifier:@"home"];
            
            // Transition UIView
            arrivee.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
            [self presentViewController:arrivee animated:YES completion:nil];
            
        } error:^(NSDictionary *responseJson) {
            
            [self ShowAlertErrorWithMessage:[responseJson valueForKey:@"message"]];
            
        } failure:^(NSError *error) {
            
            [self ShowAlertErrorWithMessage:@"Le serveur ne répond pas ..."];
            
        }];
        
    } error:^(NSDictionary *responseJson) {
        
        [self ShowAlertErrorWithMessage:[responseJson valueForKey:@"message"]];
        
    } failure:^(NSError *error) {
        
        [self ShowAlertErrorWithMessage:@"Le serveur ne répond pas ..."];
        
    }];
    
}

- (void)ShowAlertErrorWithMessage:(NSString *)message {
    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Erreur" message:message delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alertView show];
}

@end
