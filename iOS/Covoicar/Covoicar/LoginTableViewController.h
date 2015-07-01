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

- (IBAction)connexionAction:(id)sender;
- (IBAction)superLoginAction:(id)sender;

@end
