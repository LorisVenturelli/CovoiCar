//
//  LoginViewController.h
//  Covoicar
//
//  Created by Loris on 24/06/2015.
//  Copyright (c) 2015 Loris Venturelli. All rights reserved.
//

#import "UserManager.h"
#import "AFNetworking.h"

@interface LoginViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;

@property (strong, nonatomic) UIViewController *viewController;

- (IBAction)connexionAction:(id)sender;

@end
