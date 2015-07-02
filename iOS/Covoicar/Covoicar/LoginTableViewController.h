//
//  LoginTableViewController.h
//  Covoicar
//
//  Created by Loris on 01/07/2015.
//  Copyright (c) 2015 Loris Venturelli. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserManager.h"
#import "TripManager.h"
#import "AFNetworking.h"

@interface LoginTableViewController : UITableViewController <UITabBarControllerDelegate, UITabBarDelegate>

@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

/**
 * Button to connect the user
 * @return IBAction
 */
- (IBAction)connexionAction:(id)sender;

/**
 * Connection fast the user with an account write on the code (for the fatest test)
 * @return instancetype
 */
- (IBAction)superLoginAction:(id)sender;

@end
