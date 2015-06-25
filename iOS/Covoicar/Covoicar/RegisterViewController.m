//
//  RegisterViewController.m
//  Covoicar
//
//  Created by Loris on 25/06/2015.
//  Copyright (c) 2015 Loris Venturelli. All rights reserved.
//

#import "RegisterViewController.h"
#import "RegisterTableViewController.h"

@interface RegisterViewController ()

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(registerAction:) name:@"registerAction" object:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)registerAction:(NSNotification *)notification
{
    
    NSDictionary* parameters = [notification userInfo];
    
    NSLog(@"register action void : %@", parameters);
    
    // HTTP POST
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:@"http://172.31.1.36:8888/covoicar/user/add" parameters:parameters success:^(AFHTTPRequestOperation *operation, id jsonResponse) {
        
        // Si success login
        if([[jsonResponse valueForKey:@"reponse"] isEqualToString:@"success"])
        {
            UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Bravo !" message:[jsonResponse valueForKey:@"message"] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [alertView show];
            
            /*
             // Next UIView
             UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
             UIViewController* arrivee = [storyboard instantiateViewControllerWithIdentifier:@"home"];
             // Transition UIView
             arrivee.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
             [self presentViewController:arrivee animated:YES completion:^(){
             self.emailField.text = @"";
             self.passwordField.text = @"";
             }];*/
        }
        else{
            // Error login
            [self ShowAlertErrorWithMessage:[jsonResponse valueForKey:@"message"]];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self ShowAlertErrorWithMessage:@"Connexion échouée au serveur."];
    }];
}

- (IBAction)registerButton:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"sendRegister" object:self];
}



- (void)ShowAlertErrorWithMessage:(NSString *)message {
    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Erreur" message:message delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alertView show];
}


@end
