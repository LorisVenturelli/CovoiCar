//
//  LoginTableViewController.m
//  Covoicar
//
//  Created by Loris on 01/07/2015.
//  Copyright (c) 2015 Loris Venturelli. All rights reserved.
//

#import "LoginTableViewController.h"

@interface LoginTableViewController ()

@end

@implementation LoginTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)connexionAction:(id)sender {
    NSString* email = self.emailField.text;
    NSString* password = self.passwordField.text;
    
    // Champs vides
    if([email isEqualToString:@""] || [password isEqualToString:@""]){
        [self ShowAlertErrorWithMessage:@"Un ou plusieurs champs sont vides."];
    }
    // Test format email
    else if([self NSStringIsValidEmail:email] == false)
    {
        [self ShowAlertErrorWithMessage:@"Format de l'email est invalide !"];
    }
    // Test valid login
    else
    {
        // Methode de connexion
        [self APIConnectWithEmail:email andPassword:password];
    }
}

- (IBAction)superLoginAction:(id)sender {
    [self APIConnectWithEmail:@"vl@vl.fr" andPassword:@"test"];
}

- (BOOL) NSStringIsValidEmail:(NSString *)checkString
{
    BOOL stricterFilter = NO;
    NSString *stricterFilterString = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
    NSString *laxString = @".+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}

- (void)APIConnectWithEmail:(NSString *)email andPassword:(NSString *)password
{
    
    [[UserManager sharedInstance] connectToApiWithEmail:email AndPassword:password success:^(NSDictionary *responseJson) {
        
        // Next UIView
        UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UIViewController* arrivee = [storyboard instantiateViewControllerWithIdentifier:@"home"];
        
        // Transition UIView
        arrivee.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        [self presentViewController:arrivee animated:YES completion:nil];
        
    } error:^(NSDictionary *responseJson) {
        
        [self ShowAlertErrorWithMessage:[responseJson valueForKey:@"message"]];
        
    } failure:^(NSError *error) {
        
        [self ShowAlertErrorWithMessage:@"Connexion échouée au serveur."];
        
    }];
    
}

- (void)ShowAlertErrorWithMessage:(NSString *)message {
    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Erreur" message:message delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alertView show];
}


@end
