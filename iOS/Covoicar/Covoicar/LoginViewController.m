//
//  LoginViewController.m
//  Covoicar
//
//  Created by Loris on 24/06/2015.
//  Copyright (c) 2015 Loris Venturelli. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

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
        [self APIConnectWithLogin:email andPassword:password];
    }
}

- (IBAction)superLoginAction:(id)sender {
    [self APIConnectWithLogin:@"vl@vl.fr" andPassword:@"test"];
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

- (void)APIConnectWithLogin:(NSString *)login andPassword:(NSString *)password
{
    // HTTP POST
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters = @{@"email":login,@"password":password};
    [manager POST:@"http://172.31.1.36:8888/covoicar/user/connect" parameters:parameters success:^(AFHTTPRequestOperation *operation, id jsonResponse) {
        
        // Si success login
        if([[jsonResponse valueForKey:@"reponse"] isEqualToString:@"success"])
        {
            NSDictionary *data = [jsonResponse objectForKey:@"data"];
            
            NSLog(@"data json = %@", data);
            
            
            User *user = [User userWithId:[[data valueForKey:@"id"] intValue]
                                    token:[data valueForKey:@"token"]
                                    email:[data valueForKey:@"email"]
                                firstName:[data valueForKey:@"firstname"]
                                 lastName:[data valueForKey:@"lastname"]
                                    phone:[data valueForKey:@"phone"]
                                      bio:[data valueForKey:@"bio"]
                                 birthday:[data valueForKey:@"birthday"]
                                   gender:[[data valueForKey:@"gender"] intValue]];
            
            [[UserManager sharedInstance] setUserInstance:user];
            [[TravelManager sharedInstance] refreshTravelsFromApi:^{
                // Next UIView
                UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                UIViewController* arrivee = [storyboard instantiateViewControllerWithIdentifier:@"home"];
                
                // Transition UIView
                arrivee.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
                [self presentViewController:arrivee animated:YES completion:nil];
            }];
            
        }
        else{
            // Error login
            [self ShowAlertErrorWithMessage:[jsonResponse valueForKey:@"message"]];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self ShowAlertErrorWithMessage:@"Connexion échouée au serveur."];
    }];
    
}

- (void)ShowAlertErrorWithMessage:(NSString *)message {
    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Erreur" message:message delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alertView show];
}


@end
