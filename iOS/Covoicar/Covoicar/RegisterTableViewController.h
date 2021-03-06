//
//  RegisterTableViewController.h
//  Covoicar
//
//  Created by Loris on 25/06/2015.
//  Copyright (c) 2015 Loris Venturelli. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserManager.h"
#import "AFNetworking.h"

@interface RegisterTableViewController : UITableViewController <UITabBarControllerDelegate, UITabBarDelegate>

@property UIActivityIndicatorView* activityIndicator;

// All labels form
@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UITextField *rePasswordField;
@property (weak, nonatomic) IBOutlet UITextField *lastNameField;
@property (weak, nonatomic) IBOutlet UITextField *firstNameField;
@property (weak, nonatomic) IBOutlet UITextField *birthdayField;

/**
 * Send the form for save the user to API
 * @return IBAction
 */
- (IBAction)submitAction:(id)sender;

@end
