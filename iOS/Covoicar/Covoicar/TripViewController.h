//
//  TripViewController.h
//  Covoicar
//
//  Created by Loris on 01/07/2015.
//  Copyright (c) 2015 Loris Venturelli. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserManager.h"
#import "TripManager.h"
#import "TripTableViewController.h"

@interface TripViewController : UIViewController

// Property for reserve the trip (from segue "ListTrip" or "SearchTrip")
@property BOOL canReserve;

// User driver of the trip
@property User* _user;
// The trip instance to show
@property Trip* _trip;

@property (weak, nonatomic) IBOutlet UIButton *reserveButton;
@property (weak, nonatomic) IBOutlet UIView *reserveView;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

/**
 * Button for reserve the trip
 * @return IBAction
 */
- (IBAction)reserveAction:(id)sender;

/**
 * Function for show an alert with error message
 * @param message Message to show on alertView
 */
- (void)ShowAlertErrorWithMessage:(NSString *)message;

@end
