//
//  LoginViewController.h
//  Covoicar
//
//  Created by Loris on 24/06/2015.
//  Copyright (c) 2015 Loris Venturelli. All rights reserved.
//

#import "ViewController.h"
#import "UserManager.h"
#import "AFNetworking.h"

@interface LoginViewController : ViewController

@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;


- (IBAction)connexionAction:(id)sender;

@end
